<#
.DESCRIPTION
  Quick and easy way to rename local computer. This requires an elavated PowerShell window.

.NOTES
  Version:        1.0
  Author:         Christopher Boni
  Creation Date:  5th July 2024
  Purpose/Change: Initial script development
#>
#Requires -RunAsAdministrator

# Gather the current computer name
$currentComputerName = $env:COMPUTERNAME

# Prompt for the new computer name. Two options uncomment the one you want.
$newComputerName = Read-Host "Enter the new computer name"
#$newComputerName = ""

# Rename the computer
Rename-Computer -NewName $newComputerName -Force

# Restart the computer for the changes to take effect
Restart-Computer -Force