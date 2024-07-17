<#
.DESCRIPTION
  Simple script that moves mouse cursor every 60 seconds to stop device from sleeping

.NOTES
  Version:        1.2.1
  Author:         Christopher Boni
  Creation Date:  16th July 2024
  Purpose/Change: Display text on console window. Fixed typo.
#>

# Load the required libraries
Add-Type -AssemblyName System.Windows.Forms

# Find current mouse position
$x = [System.Windows.Forms.Cursor]::Position.X
$y = [System.Windows.Forms.Cursor]::Position.Y

# Start timer for 1 hour.
$StartTime = Get-Date
$EndTime = $StartTime.AddHours(1)

# Adding some text so not an empty PS Window.
Write-Host "Running script - mouse will move slightly every 60 seconds"
Write-Host "Script will stop running after one hour, alternatively press CTRL + C to stop early"

# Start a loop to move mouse every 60 seconds.
while ((Get-Date) -lt $EndTime) {
    # RNG new mouse position.
    $newX = $x + (Get-Random -Minimum -2 -Maximum 2)
    $newY = $y + (Get-Random -Minimum -2 -Maximum 2)
    
    # Move use to the RNG calc.
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($newX, $newY)

    # Wait 60 seconds before going back to start of loop
    Start-Sleep -Seconds 60
}