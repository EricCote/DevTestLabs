# 1..10 | % {
# $computer = [ADSI]"WinNT://$env:ComputerName"
# $user = $computer.Create("User", "Eric$_")
# $user.SetPassword("af123123123!")
# $user.Put("Description", "eric$_")
# $user.SetInfo()

# $group = [ADSI]"WinNT://$env:ComputerName/Administrators,group"
# $group.add("WinNT://$env:ComputerName/Eric$_") | Out-Null
# }

# return $user