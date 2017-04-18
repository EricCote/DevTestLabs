$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"
$mgm = Get-WmiObject -Namespace $namespaceName -Class $className
$result = $mgm.UpdateScanMethod()


"resultat $($result.ReturnValue)"
