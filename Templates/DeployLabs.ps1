##############################################
#preReq for Azure modules

#Install-PackageProvider -Name NuGet -force
#Install-Module AzureRM -AllowClobber -force

#Get-Module -ListAvailable Azure*

###########################
# start of script

Set-ExecutionPolicy -ExecutionPolicy bypass -Scope Process -force

$myPwd=$env:AzureVmPwd;
if ($myPwd -eq $null)
{
    $myPwd = Read-Host "Enter the password for Azure Virtual Machines"
    [Environment]::SetEnvironmentVariable("AzureVmPwd",$myPwd, [System.EnvironmentVariableTarget]::User)
    $env:AzureVmPwd = $myPwd
    Write-Output "This is now saved in the environnement variable AzureVmPwd."
}

$gitHubToken=$env:gitHubToken;
if ($gitHubToken -eq $null)
{
    $gitHubToken = Read-Host "Enter the Personnal Access Token for GitHub"
    [Environment]::SetEnvironmentVariable("gitHubToken",$gitHubToken, [System.EnvironmentVariableTarget]::User)
    $env:gitHubToken = $gitHubToken
    Write-Output "This is now saved in the environnement variable gitHubToken."
}

$VsEntKey=$env:vsEnterpriseKey;
if ($VsEntKey -eq $null)
{
    $VsEntKey = Read-Host "Enter the Visual Studio Enterprise Key"
    [Environment]::SetEnvironmentVariable("vsEnterpriseKey",$VsEntKey, [System.EnvironmentVariableTarget]::User)
    $env:vsEnterpriseKey = $VsEntKey
    Write-Output "This is now saved in the environnement variable vsEnterpriseKey."
}

$VsProKey=$env:vsProfessionalKey;
if ($VsProKey -eq $null)
{
    $VsProKey = Read-Host "Enter the Visual Studio Professional Key"
    [Environment]::SetEnvironmentVariable("vsProfessionalKey",$VsProKey, [System.EnvironmentVariableTarget]::User)
    $env:vsProfessionalKey = $VsProKey
    Write-Output "This is now saved in the environnement variable vsProfessionalKey."
}


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
$addMasterImage=     "C:\code\DevTestLabs\templates\addMasterImage.json"
$createFormula=      "C:\code\DevTestLabs\templates\FormulaTemplate.json"
$deployMasterVm=     "C:\code\DevTestLabs\templates\deployMasterVm.json"
$deployVm=           "C:\code\DevTestLabs\templates\deployvm.json"
$deployCustomVm=     "C:\code\DevTestLabs\templates\deployCustomVm.json"

$location=        "Canada East"
$groupName=       "CoursVs2017"
$labName=         "Vs2017"
$goldVmName=      "Vs2017-Master"
$imageName=       "Vs2017-Image"
$vmPrefix=        "afivs-"
$vmUsername=      "afi"
$SecurePassword = $MyPwd | ConvertTo-SecureString -AsPlainText -Force

#début du travail!
$startTime=get-Date;
"### Script started at: $startTime"

New-AzureRmResourceGroup -Name $groupName -Location $location

#On créé un Lab
New-AzureRmResourceGroupDeployment -name "CreateLab" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createLab `
                                   -newLabName $LabName 
                               
#On ajoute un private repo
New-AzureRmResourceGroupDeployment -name "CreatePrivateRepo" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $addPrivateRepo `
                                   -existingLabName $LabName `
                                   -repoName "privaterepo1" `
                                   -displayName "Private Repo 1" `
                                   -uri "https://github.com/EricCote/DevTestLabs.git" `
                                   -securityToken $gitHubToken


#On instancie une VM "gold"                                
New-AzureRmResourceGroupDeployment -name "CreateGoldVm" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployMasterVm `
                                   -newVMName $goldVmName `
                                   -labName $labName `
                                   -password $SecurePassword `
                                   -userName $vmUsername `
                                   -vskey $VsEntKey

$goldTime = get-Date
$goldElapsed=$goldTime.Subtract($startTime)

"#### Gold Time:  $($goldElapsed.TotalMinutes) minutes."

$masterVm = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs/virtualMachines' `
                                 -ResourceNameContains $goldVmName | select-object -First 1

#On crée une image custom "gold"                                
New-AzureRmResourceGroupDeployment -name "CreateGoldImage" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $addMasterImage `
                                   -imageName $imageName `
                                   -existingLabName $labName `
                                   -existingVMResourceId $masterVm.ResourceId `
                                   -windowsOsState "SysprepApplied" `
                                   -imageDescription "C'est une image de Windows 10 avec Visual Studio 2017 Enterprise"

#On delete la VM gold
$contextPath = "$env:temp\context.json"
Save-AzureRmContext -Path $contextPath -force

$jobId = Start-Job -ScriptBlock {
  Param($contextPath, $masterVm)
  Import-AzureRmContext -Path $contextPath
  Remove-AzureRmResource -ResourceId $masterVm.ResourceId -Force
} -ArgumentList $contextPath, $masterVm 

#$jobId.state
#receive-job $jobId

$imageTime = get-Date
$imageElapsed=$imageTime.Subtract($goldTime)

"#### Image Creation Time: $($imageElapsed.TotalMinutes) minutes."

#On créé une formule 
New-AzureRmResourceGroupDeployment -name "CreateFormula" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createFormula `
                                   -formulaName "Vs2017Formula" `
                                   -existingLabName $labName `
                                   -description "Créer des VM avec Windows 10 et Visual Studio 2017..." `
                                   -customImage $imageName `
                                   -userName $vmUsername `
                                   -password $SecurePassword

$formulaTime = get-Date
$formulaElapsed=$formulaTime.Subtract($imageTime)

"#### Formula Time: $($formulaElapsed.TotalMinutes) minutes."

$seven = [Datetime]::Now.AddDays(7)
$expires = New-Object -TypeName "DateTime" ($seven.Year, $seven.Month, $seven.Day, 18,15,00)


#on créé quelques machines
New-AzureRmResourceGroupDeployment -name "CreateMachines" `
                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployCustomVm `
                                   -newVMName $vmPrefix `
                                   -customImage $imageName `
                                   -labName  $labName   `
                                   -numberOfInstances 2 `
                                   -userName $vmUsername `
                                   -password $SecurePassword `
                                   -expirationDate $expires.ToString("yyyy-MM-ddTHH:mm:ss-05:00")


$creationTime = get-Date
$creationElapsed=$creationTime.Subtract($formulaTime)
"#### VM deploy time: $($creationElapsed.TotalMinutes) minutes."
