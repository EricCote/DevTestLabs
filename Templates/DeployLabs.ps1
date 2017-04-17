##############################################
#preReq for Azure modules

#Install-PackageProvider -Name NuGet -force
#Install-Module AzureRM -AllowClobber -force

#Get-Module -ListAvailable Azure*

###########################
# start of script

$location=      "Canada East"
$labName=       "Vs2018"

$vmPrefix=          "Classe01-"
$ExpiresInXDays=    7
$numberOfInstances= 2
$imageDescription=  "Windows 10 with Visual Studio 2017 Enterprise and Office 2016"


Set-ExecutionPolicy -ExecutionPolicy bypass -Scope Process -force

#this will return the value of an environment variable, or interactively create it when it doesn't exist.
#This is how we store secrets in this script
function Stuff-EnvironmentVariable 
(
    $name,
    $description
)
{
    $value = [Environment]::GetEnvironmentVariable($name, "User");
    if ($value -ne $null) {  
      return $value;  
    } 
    $value = Read-Host "Enter the $description";
    [Environment]::SetEnvironmentVariable($name, $value, "User");
    Write-Output "This is now saved in the environnement variable $name.";
    return $value;
}

$myPwd=      Stuff-EnvironmentVariable -Name "AzureVmPwd" -Description "password for Azure Virtual Machines"
$gitHubToken=Stuff-EnvironmentVariable -Name "gitHubToken" -Description "personal access token for GitHub"
$VsEntKey=   Stuff-EnvironmentVariable -Name "vsEnterpriseKey" -Description "Visual Studio Enterprise ProductKey"
$VsProKey=   Stuff-EnvironmentVariable -Name "vsProfessionalKey" -Description "Visual Studio Professional ProductKey"


############################
# To log in to Azure Resource Manager

Login-AzureRmAccount

# You can also use a specific Tenant if you would like a faster log in experience
# Login-AzureRmAccount -TenantId xxxx


# To select a default subscription for your current session.
# This is useful when you have multiple subscriptions.
Get-AzureRmSubscription -SubscriptionName "Msdn2 sub" | Select-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
#Get-AzureRmContext

#Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob

$createLab=          "C:\code\DevTestLabs\templates\createLab.json"
$addPrivateRepo=     "C:\code\DevTestLabs\templates\addPrivateRepo.json"
$createMasterImage=  "C:\code\DevTestLabs\templates\CreateMasterImage.json"
$addFormula=         "C:\code\DevTestLabs\templates\AddFormula.json"
$deployMasterVm=     "C:\code\DevTestLabs\templates\deployMasterVm.json"
$deployVm=           "C:\code\DevTestLabs\templates\deployvm.json"
$deployCustomVm=     "C:\code\DevTestLabs\templates\deployCustomVm.json"


$groupName=       "Cours$labName"
$goldVmName=      "$labName-Master"
$imageName=       "$labName-Image"
$vmUsername=      "afi"
$SecurePassword = $MyPwd | ConvertTo-SecureString -AsPlainText -Force

#début du travail!
#Step 1:  create the ResourceGroup, the lab and the reference to the private repository 
$startTime=get-Date;
"### Script started at: $startTime"

#step 1a:  create the ResourceGroup
New-AzureRmResourceGroup -Name $groupName -Location $location

#step 1b:  Create the lab
New-AzureRmResourceGroupDeployment -name "CreateLab" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createLab `
                                   -newLabName $LabName 
                               
#step 1c: create the private repo
New-AzureRmResourceGroupDeployment -name "CreatePrivateRepo" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $addPrivateRepo `
                                   -existingLabName $LabName `
                                   -repoName "privaterepo1" `
                                   -displayName "Private Repo 1" `
                                   -uri "https://github.com/EricCote/DevTestLabs.git" `
                                   -securityToken $gitHubToken


#step 2: create the Master VM, a machine with everyting in it.                          
New-AzureRmResourceGroupDeployment -name "CreateGoldVm" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployMasterVm `
                                   -newVMName $goldVmName `
                                   -labName $labName `
                                   -password $SecurePassword `
                                   -userName $vmUsername `
                                   -vskey $VsEntKey
                                 

#display elapsed time
$goldTime = get-Date
$goldElapsed=$goldTime.Subtract($startTime)
"#### Gold Time:  $($goldElapsed.TotalMinutes) minutes."



#check that the machine is deallocated. If it isn't the case, something wrong happened.
$vmToCheck = Find-AzureRmResource -ResourceType 'Microsoft.Compute/virtualMachines' -ResourceNameEquals  $goldVmName | select-object -first 1
$vmStatus = Get-AzureRmVm   -Name $vmToCheck.ResourceName   -ResourceGroupName $vmToCheck.ResourceGroupName -Status -WarningAction SilentlyContinue
if ($vmStatus.Statuses[1].Code -ne 'PowerState/deallocated' )
{ 
  #exit the script
  "The artifacts have NOT finished with a sysprep that deallocated the machine. Let's interrupt this script";
  return ;
}

#Step 3: create a Master image from the VM
#find a reference to the machine
$masterVm = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs/virtualMachines' `
                                 -ResourceNameContains $goldVmName | select-object -First 1

#Create a Master (gold) image                                
New-AzureRmResourceGroupDeployment -name "CreateGoldImage" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createMasterImage `
                                   -imageName $imageName `
                                   -existingLabName $labName `
                                   -existingVMResourceId $masterVm.ResourceId `
                                   -windowsOsState "SysprepApplied" `
                                   -imageDescription $imageDescription

#We can now delete the Master VM now that the Master Image is created
#To have asynchronous actions in our script, we need to save the Azure context (name and security token) on the disk.
$contextPath = "$env:temp\context.json"
Save-AzureRmContext -Path $contextPath -force -WarningAction SilentlyContinue

#This is our Asynchronous job to delete the Master VM
$jobId = Start-Job -ScriptBlock {
  Param($contextPath, $masterVm)
  Import-AzureRmContext -Path $contextPath -WarningAction SilentlyContinue
  Remove-AzureRmResource -ResourceId $masterVm.ResourceId -Force
} -ArgumentList $contextPath, $masterVm 

#$jobId.state
#receive-job $jobId

#display elapsed time 
$imageTime = get-Date
$imageElapsed=$imageTime.Subtract($goldTime)
"#### Image Creation Time: $($imageElapsed.TotalMinutes) minutes."

#Step 4: Create a formula for future usage
New-AzureRmResourceGroupDeployment -name "addFormula" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $addFormula `
                                   -formulaName "$LabName Formula" `
                                   -existingLabName $labName `
                                   -description "Créer des VM avec Windows 10 et Visual Studio 2017..." `
                                   -customImage $imageName `
                                   -userName $vmUsername `
                                   -password $SecurePassword

#display elapsed time
$formulaTime = get-Date
$formulaElapsed=$formulaTime.Subtract($imageTime)
"#### Formula Time: $($formulaElapsed.TotalMinutes) minutes."


#Machines expires in X days, at 18:15
$ExpiryDate = [Datetime]::Now.AddDays($ExpiresInXDays)
$expires = New-Object -TypeName "DateTime" ($ExpiryDate.Year, $ExpiryDate.Month, $ExpiryDate.Day, 18,15,00)


#on créé quelques machines
New-AzureRmResourceGroupDeployment -name "CreateMachines" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployCustomVm `
                                   -newVMName $vmPrefix `
                                   -customImage $imageName `
                                   -labName  $labName   `
                                   -numberOfInstances $numberOfInstances `
                                   -userName $vmUsername `
                                   -password $SecurePassword `
                                   -expirationDate $expires.ToString("yyyy-MM-ddTHH:mm:ss-05:00")


$creationTime = get-Date
$creationElapsed=$creationTime.Subtract($formulaTime)
"#### VM deploy time: $($creationElapsed.TotalMinutes) minutes."
