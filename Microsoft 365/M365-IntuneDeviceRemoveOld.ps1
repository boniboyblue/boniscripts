<#
.SYNOPSIS
Azure Active Directory Device Management

.NOTES
AzureADDevice commands are pending deprecation.
Need to use MGDevice commands instead.

.LINK
https://learn.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0
#>
#REQUIRES -Modules AzureAD

# Connect to Azure AD.
Import-Module AzureAD
Connect-AzureAD

# Pull the list of devices where the last login was more than 365 days and delete the selected ones.
$Days = 365; $DatePast = Get-Date $((Get-Date).AddDays(-$Days))
Write-Host -NoNewline "Gathering list of AAD devices not used from "; Write-Host -NoNewline -Fore Yellow (Get-Date $DatePast -Format "yyyy-MM-dd HH:mm:ss"); Write-Host " until now..."
$ListDevices = Get-AzureADDevice | Where-Object {$_.ApproximateLastLogonTimeStamp -lt $DatePast}
$ListDevices | Where-Object {$_.ApproximateLastLogonTimeStamp -le $DatePast} | Select-Object DisplayName,AccountEnabled,ApproximateLastLogonTimeStamp,DeviceOSType,DeviceOSVersion,DeviceTrustType,IsCompliant,IsManaged,LastDirSyncTime,ProfileType,SystemLabels,DeviceId,ObjectId | Out-GridView -PassThru
$ListDevicesToRemove = $ListDevices | Where-Object {$_.ApproximateLastLogonTimeStamp -le $DatePast} | Select-Object DisplayName,AccountEnabled,ApproximateLastLogonTimeStamp,DeviceOSType,DeviceOSVersion,DeviceTrustType,IsCompliant,IsManaged,LastDirSyncTime,ProfileType,SystemLabels,DeviceId,ObjectId | Out-GridView -PassThru
$ListDevicesToRemove | ForEach-Object {Remove-AzureADDevice -ObjectId $_.ObjectId}
