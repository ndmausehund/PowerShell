#Import AD Module
Import-Module ActiveDirectory

#Import Azure AD Module
Import-Module MSOnline

Connect-MsolService

$Samaccountname = Read-Host "Enter a username to remove"

#removes the users from all groups besides domain users
Get-AdPrincipalGroupMembership -Identity $Samaccountname | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $Samaccountname
Write-Host 'Now removed from group memberships'

#disables the ad account
Disable-ADAccount -Identity $Samaccountname
Write-Host 'AD account now disabled'

#since get-msoluser does not use samaccount name we will have to create a new variable to add @morganservices.com to create a upn
$upn = $Samaccountname + '@morganservices.com'

#This retrieves the active licenses by the upn and loops through them in order to set each of them to inactive
(Get-MsolUser -UserPrincipalName $upn).licenses.AccountSkuID | foreach {
Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $_
}
Write-Host 'Removed licenses'