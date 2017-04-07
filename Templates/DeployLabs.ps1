#Get-Module -ListAvailable Azure*

#Install-Module AzureRM -AllowClobber
#Import-Module azurerm

#$PSVersionTable.PSVersion

#Import-Module AzureRM

###########################
# start of script

Set-ExecutionPolicy -ExecutionPolicy bypass -Scope Process


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


############################

# To log in to Azure Resource Manager
Login-AzureRmAccount

# You can also use a specific Tenant if you would like a faster log in experience
# Login-AzureRmAccount -TenantId xxxx

# To view all subscriptions for your account
Get-AzureRmSubscription

# To select a default subscription for your current session.
# This is useful when you have multiple subscriptions.
Get-AzureRmSubscription -SubscriptionName "Msdn3 sub" | Select-AzureRmSubscription

# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
#Get-AzureRmContext

#Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob

$vmUsername="afi"
$SecurePassword = $MyPwd | ConvertTo-SecureString -AsPlainText -Force


$createVMTemplate="https://raw.githubusercontent.com/Azure/azure-devtestlab/master/ARMTemplates/101-dtl-create-vm-username-pwd-galleryimage/azuredeploy.json"
$createFormulaTemplate="https://raw.githubusercontent.com/Azure/azure-devtestlab/master/ARMTemplates/201-dtl-create-formula/azuredeploy.json"
$createImageFromVHD= "https://raw.githubusercontent.com/Azure/azure-devtestlab/master/ARMTemplates/201-dtl-create-customimage-from-vhd/azuredeploy.json"  

$createLab=          "C:\code\DevTestLabs\templates\createLab.json"
$addPrivateRepo=     "C:\code\DevTestLabs\templates\addPrivateRepo.json"
$createFormula=      "C:\code\DevTestLabs\templates\FormulaTemplate.json"
$deployVm=           "C:\code\DevTestLabs\templates\deployvm.json"
$deployCustomVm=     "C:\code\DevTestLabs\templates\deployCustomVm.json"


$groupName="CoursWebApi"
$location="East US"
$labName="WebApi"
$imageName= "Windows10WithChrome"
$vmPrefix="afiVs1"

 

New-AzureRmResourceGroup -Name $groupName -Location $location


#On installe un lab vierge
#New-AzureRmResourceGroupDeployment -name "CoursWebApi12345" `
#                                   -ResourceGroupName $groupName `
#                                   -TemplateFile $CreateLabTemplate `
#                                   -newLabName $labName





#On créé un Lab
New-AzureRmResourceGroupDeployment -name "CoursWebApi99" `                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createLab `
                                   -newLabName $LabName
                                   
#On ajoute un private repo
New-AzureRmResourceGroupDeployment -name "CoursWebApi96" `                                   -ResourceGroupName $groupName `
                                   -TemplateFile $addPrivateRepo `
                                   -existingLabName $LabName `
                                   -repoName "privaterepo1" `
                                   -displayName "PrivateRepo1" `
                                   -uri "https://github.com/EricCote/DevTestLabs.git" `
                                   -securityToken $gitHubToken
                                   


#Règle de shutdown
#set-AzureRmDtlAutoShutdownPolicy -LabName $labName `
#                                 -ResourceGroupName $groupName `
#                                 -Enable  `
#                                 -Time "6:00 PM-5:00" 
                                 

#Règle de start automatique
#set-AzureRmDtlAutoStartPolicy    -LabName $labName `
#                                 -ResourceGroupName $groupName `
#                                 -Enable  `
#                                 -Time "8:00 AM-5:00" -Days Monday, Tuesday, wednesday, Thursday, Friday


#on saute
New-AzureRmResourceGroupDeployment -name "CoursWebApi97" `                                   -ResourceGroupName $groupName `
                                   -TemplateUri $createVMTemplate `
                                   -existingLabName $labName `
                                   -newVMName "coursWeb01" `
                                   -offer "Windows" `
                                   -publisher "MicrosoftVisualStudio" `
                                   -sku "Windows-10-N-x64" `
                                   -osType "Windows" `
                                   -version "latest" `
                                   -newVMSize "Standard_DS2_V2" `
                                   -userName $vmUsername `
                                   -password $SecurePassword


#On créé une formule nommée Win10Formula
New-AzureRmResourceGroupDeployment -name "CoursWebApi99" `                                   -ResourceGroupName $groupName `
                                   -TemplateFile $createFormula `
                                   -formulaName "win18Formula" `
                                   -existingLabName $labName 




#On instancie une machine "gold"                                
New-AzureRmResourceGroupDeployment -name "CoursWebApi97" `                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployVm `
                                   -newVMName "CoursApi0" `
                                   -labName $labName `
                                   -numberOfInstances 1 `
                                   -password $SecurePassword `
                                   -userName $vmUsername

#ici, il faut copier le vhd du blob source au blob destination (dossier upload)


#Creation du Custom Image à partir du vhd
New-AzureRmResourceGroupDeployment -name "CoursWebApi977" `                                   -ResourceGroupName $groupName `
                                   -TemplateUri $createImageFromVHD `
                                   -existingLabName $labName `
                                   -existingVhdUri $vhdUrl `
                                   -imageName $imageName `
                                   -imageDescription  "Windows 10 avec vs2017"

                                 


#deploy 10 instances from an image

$imageRef = Get-AzureRMResource  -ResourceType 'Microsoft.DevTestLab/labs/customImages' `
                                 -ApiVersion '2016-05-15' `
                                 -ResourceName ($labName + "/" + $imageName) `
                                 -ResourceGroupName $groupName
                $vmPrefix ="afivs1"   
New-AzureRmResourceGroupDeployment -name "CoursWebApi97" `                                   -ResourceGroupName $groupName `
                                   -TemplateFile $deployCustomVm `
                                   -existingCustomImageId $imageRef.resourceId `
                                   -newVMName $vmPrefix `
                                   -labName  $labName   `
                                   -numberOfInstances 10 `
                                   -userName $vmUsername `
                                   -password $SecurePassword





#this will create the image vhd from a syspreped machine.  

#Get the LAb
$labs = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs' -ResourceName $labName
$lab=$labs[0]

#set the destination folder to the lab's "default storage" (the upload directory)
$properties = (Get-AzureRMResource  -ResourceType 'Microsoft.DevTestLab/labs'  -ResourceName $lab.ResourceName -ResourceGroupName $lab.ResourceGroupName -WarningAction SilentlyContinue).Properties
$labStorageAccountId = $properties.DefaultStorageAccount.Split('/')
$labStorageAccountName =  $labStorageAccountId[$labStorageAccountId.Length-1]
$labStorageAccountKey = (Get-AzureRMStorageAccountKey -Name $labStorageAccountName -ResourceGroupName $lab.ResourceGroupName)[0].Value 

#Get the first machine of the lab, this is going to be our source
$LabVmToCapture = Get-AzureRmResource  -ResourceType 'Microsoft.DevTestLab/labs/virtualmachines' -ResourceName $labName -ResourceGroupName $GroupName | select -first 1

$vmToCapture = Find-AzureRmResource -ResourceType 'Microsoft.Compute/virtualMachines' -ResourceName  $LabVmToCapture.Name | select -first 1
$properties = (Get-AzureRMResource  -ResourceType 'Microsoft.Compute/virtualMachines' -ResourceName $vmToCapture.ResourceName -ResourceGroupName $vmToCapture.ResourceGroupName).Properties 

#get the location of the source VHD to copy
$sourceUri = $properties.storageProfile.osDisk.vhd.uri
$uri = New-Object System.Uri($sourceUri)
$vmStorageAccountName = $uri.Host.Split('.')[0]
$storageAccounts = Find-AzureRmResource -ResourceType 'Microsoft.Storage/storageAccounts'  

#let's find the not only the right account name, but also the right resource group (these are dynamic for labs)
foreach($storageAccount in $storageAccounts){
  if($storageAccount.ResourceName -eq $vmStorageAccountName){
    $vmStorageAccountRG = $storageAccount.ResourceGroupName
  }
}        

#let's get the source key
$vmStorageAccountKey = (Get-AzureRMStorageAccountKey -Name $vmStorageAccountName -ResourceGroupName $vmStorageAccountRG)[0].Value

#let's set the context (connection) for the source and destination with the  right keys
$srcContext = New-AzureStorageContext –StorageAccountName $vmStorageAccountName -StorageAccountKey $vmStorageAccountKey 
$destContext = New-AzureStorageContext –StorageAccountName $labStorageAccountName -StorageAccountKey $labStorageAccountKey 
 
#this can have a better name
$vhdFileName='vs2017.vhd'

$vhdUrl = $destContext.BlobEndPoint + "uploads/" + $vhdFileName

#start the copy
$copyHandle = Start-AzureStorageBlobCopy -srcUri $sourceUri -SrcContext $srcContext -DestContainer 'uploads' -DestBlob $vhdFileName -DestContext $destContext -Force

Write-Host "Copy started..."
$copyStatus = $copyHandle | Get-AzureStorageBlobCopyState 

While($copyStatus.Status -eq "Pending"){
  $copyStatus = $copyHandle | Get-AzureStorageBlobCopyState 
  $perComplete = ($copyStatus.BytesCopied/$copyStatus.TotalBytes)*100
  Write-Progress -Activity "Copying blob..." -status "Percentage Complete" -percentComplete "$perComplete"
  Start-Sleep 10
}

if($copyStatus.Status -eq "Success")
{
  Write-Host "$vhdFileName successfully copied to Lab $labName "
}


#let's delete the source machine
Remove-AzureRmResource -ResourceId $LabVmToCapture.ResourceId -Force


######################################3

$labProperties = (Get-AzureRmResource -ResourceName $labName -ResourceType "microsoft.devtestlab/labs" -ResourceGroupName $groupName).Properties
$labStorageAccountName = $labProperties.defaultStorageAccount

#Generaliser machine
Set-AzureRmVm -ResourceGroupName coursapi2303488234000 -Name CoursApi3 -Generalized

#verifier Generalisation
$vm = Get-AzureRmVM -ResourceGroupName coursapi2303488234000 -Name CoursApi3  -Status
$vm.Statuses

#copier vhd
Save-AzureRmVMImage -ResourceGroupName coursapi2303488234000 -Name CoursApi3 `
     -DestinationContainerName mesimages -VHDNamePrefix eric `
     -Path C:\code\Filename456.json


& "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe" `
       /Source:https://dcoursapi6131.blob.core.windows.net/system/Microsoft.Compute/Images/mesimages/ `
       /Dest:https://dcoursapi6131.blob.core.windows.net/uploads `
       /SourceKey:5sHPAWRMy8Rjaip6e4bsTalWFYZCDBmf37+85yY/GZ/NKgfG1aADrazaHcObb8tbExnvCJoujlKIr3xFzsAu3A== `
       /DestKey:5sHPAWRMy8Rjaip6e4bsTalWFYZCDBmf37+85yY/GZ/NKgfG1aADrazaHcObb8tbExnvCJoujlKIr3xFzsAu3A== `
       /pattern:"eric-osDisk.7079f5a9-d15a-44a0-8d9d-bf8b1a6a97af.vhd"

     Get-AzureRMVMImage


##### DELETE  VM and labs

$labs = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs' -ResourceNameContains $labName
$lab=$labs[0]

# Get the VMs from that lab.
$labVMs = Get-AzureRmResource | Where-Object { 
          $_.ResourceType -eq 'microsoft.devtestlab/labs/virtualmachines'  -and
          $_.ResourceName -like "$($lab.ResourceName)/*"}

# Delete the VMs.
foreach($labVM in $labVMs)
{
    Remove-AzureRmResource -ResourceId $labVM.ResourceId -Force
}

#Delete lab
Remove-AzureRmResource -ResourceId $lab.ResourceId -Force

#delete res group
Remove-AzureRmResourceGroup -Name $groupName -force





##############################################################################

$srcContext = New-AzureStorageContext –StorageAccountName 'dwebapi3075' -StorageAccountKey "SGJZAicsNAn0ghGtNOz+OdXckhMshcCJpmQ3vvWWD2hGVngtTJrDKdf0RuJwyE8iRkQ2WWdjskN0MlvjoPPW5w=="
$destContext = New-AzureStorageContext –StorageAccountName 'dwebapi9188' -StorageAccountKey "TUTLxNqY560umV8z9+5XvBx3GxNZ9CtWoILKzqPIogQJ0bZuu9FQh/gKmvxyzuhvEZ4Sti+L04l2hw12KEjr8A=="

#start the copy
$copyHandle = Start-AzureStorageBlobCopy -srcUri "https://dwebapi3075.blob.core.windows.net/uploads/VS2017.vhd" `
                                         -SrcContext $srcContext -DestContainer 'uploads' `
                                         -DestBlob "vs2017.vhd" -DestContext  $destContext -Force

Write-Host "Copy started..."
$copyStatus = $copyHandle | Get-AzureStorageBlobCopyState 

While($copyStatus.Status -eq "Pending"){
  $copyStatus = $copyHandle | Get-AzureStorageBlobCopyState 
  $perComplete = ($copyStatus.BytesCopied/$copyStatus.TotalBytes)*100
  Write-Progress -Activity "Copying blob..." -status "Percentage Complete" -percentComplete "$perComplete"
  Start-Sleep 10
}

if($copyStatus.Status -eq "Success")
{
  Write-Host "$vhdFileName successfully copied to Lab $labName"
}
