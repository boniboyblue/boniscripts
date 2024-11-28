<#
.DESCRIPTION
Simple script to grab permissions to all folders within a folder.

.NOTES
Version:        1.0
Author:         Christopher Boni
Creation Date:  28th November 2024
Purpose/Change: 1st Upload
#>

# Ask for the folder location for the script to scan.
$parentFolderPath = Read-Host "Enter full folder location."

# Varible to output the final results to a csv file in the current user's temp folder.
$outputCsvPath = "$env:TEMP\Permissions.csv"

# Get the first set of subfolders within the parent folder
$subfolders = Get-ChildItem -Path $parentFolderPath -Directory

# Initialise an array to store the permissions data
$permissionsData = @()

# Loop through each subfolder and get its permissions
foreach ($folder in $subfolders) {
    $acl = Get-Acl -Path $folder.FullName
    foreach ($access in $acl.Access) {
        $permissionsData += [PSCustomObject]@{
            Folder            = $folder.FullName
            Identity          = $access.IdentityReference
            Permissions       = $access.FileSystemRights
            Inheritance       = $access.InheritanceFlags
            Propagation       = $access.PropagationFlags
            AccessControlType = $access.AccessControlType
        }
    }
}

# Export the permissions data to a CSV file
$permissionsData | Export-Csv -Path $outputCsvPath -NoTypeInformation
Write-Output "Permissions have been exported to $outputCsvPath"