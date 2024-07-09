$Reg = Get-ItemProperty -Path 'HKLM:\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name "EnableMDNS" -ErrorAction SilentlyContinue
if ($Null -eq $Reg){

    Write-host "mDNS regedit entry found"
    Exit 1
}
else {
    Write-Host "mDNS regedit entry not found"
    Exit 0
}