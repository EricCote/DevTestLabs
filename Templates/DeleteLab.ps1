$labs = Find-AzureRmResource -ResourceType 'Microsoft.DevTestLab/labs' -ResourceNameContains $labName
$lab=$labs[0]

$jobId = Start-Job -ScriptBlock {
  param($lab, $groupName)
  Remove-AzureRmResource -ResourceId $lab.ResourceId -Force
  #delete res group
  Remove-AzureRmResourceGroup -Name $groupName -Force
}
