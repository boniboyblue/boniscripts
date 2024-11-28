<#
.DESCRIPTION
I needed a script to export all user's Job Titles & Managers - turned out to be a bit more complex than I suspected.

.NOTES
Version:        1.1
Author:         Christopher Boni
Creation Date:  21st November 2024
Purpose/Change: Updated formatting.
#>
#REQUIRES -Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Define the path for the CSV file
$CSVFilePath = "$env:TEMP\ExportedUsers.csv"

# Get all users from Azure AD and select the required properties
$users = Get-AzureADUser -All $true | ForEach-Object {
    $user = $_
    $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
    $licenses = ($user.AssignedLicenses | ForEach-Object { (Get-AzureADSubscribedSku | Where-Object { $_.SkuId -eq $_.SkuId }).SkuPartNumber }) -join ","
    [PSCustomObject]@{
        DisplayName = $user.DisplayName
        JobTitle    = $user.JobTitle
        Manager     = if ($manager) { $manager.DisplayName } else { "No Manager" }
        Licenses    = $licenses
    }
}

# Export the selected properties to a CSV file
$users | Export-Csv -Path $CSVFilePath -NoTypeInformation

Write-Host "Export completed. The CSV file is located at $CSVFilePath"