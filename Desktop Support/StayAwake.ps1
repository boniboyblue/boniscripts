<#
.DESCRIPTION
Simple script that simulates a key press every 60 seconds to stop device from sleeping

.NOTES
Version:        1.5
Author:         Christopher Boni
Creation Date:  16th July 2024
Purpose/Change: Reworked to simulate key press.
#>

# Start timer for 1 hour.
$StartTime = Get-Date
$EndTime = $StartTime.AddHours(1)

# Clear PS Windows Screen and display text showing that script is running.
Clear-Host
Write-Host "Running script - Keeping device awake"
Write-Host "Script will stop running after one hour, alternatively press CTRL + C to stop early"

# Start a loop to press key every 60 seconds.
$KeyPress = New-Object -ComObject WScript.Shell
while ((Get-Date) -lt $EndTime) {
  # Send F15 keyboard press
  $KeyPress.SendKeys('+{F15}')

  # Wait 60 seconds before going back to start of loop
  Start-Sleep -Seconds 60
}