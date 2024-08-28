<#
.DESCRIPTION
  Quick PS script I created to be used to install .exe version of 8x8 Work for Desktop which would be deployed via Datto RMM.

.NOTES
  Version:        8.15.2
#>

(New-Object System.Net.WebClient).DownloadFile("https://work-desktop-assets.8x8.com/prod-publish/ga/work-64-exe-v8.15.2-7.exe", "$env:TEMP/work-64-exe-v8.15.2-7.exe"); start-process "$env:TEMP/work-64-exe-v8.15.2-7.exe"