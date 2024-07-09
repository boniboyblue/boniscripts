# Get the value of the EnableMDNS regedit.
# If entry doesn't exist, the $Reg variable will be null.
$Reg = Get-ItemProperty -Path 'HKLM:\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name "EnableMDNS" -ErrorAction SilentlyContinue

# Check if entry was found.
if ($Null -eq $Reg) {
    # Entry not found
    Write-host "mDNS regedit entry found"
    Exit 1
}
else {
    # Entry found
    Write-Host "mDNS regedit entry not found"
    Exit 0
}