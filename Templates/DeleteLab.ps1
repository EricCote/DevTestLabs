$groupName="CoursVs2019"
$labName="Vs2019"
$path = "$env:temp\context.json"

Login-AzureRmAccount
Get-AzureRmSubscription -SubscriptionName "Msdn2 sub" | Select-AzureRmSubscription


$lab = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs' -ResourceNameContains $labName | Select-Object -first 1



$deleteBlock = {
    Param($path, $lab, $groupName)
    Import-AzureRmContext -Path $path
    Remove-AzureRmResource -ResourceId $lab.ResourceId -Force
    #delete res group
    Remove-AzureRmResourceGroup -Name $groupName -Force
}

Save-AzureRmContext -Path $path -force

$myjob = Start-Job -ScriptBlock $deleteBlock -ArgumentList $path, $lab, $groupName -name "delete job"
#Wait-Job $myjob
#Receive-Job $myjob

$myjob.State


