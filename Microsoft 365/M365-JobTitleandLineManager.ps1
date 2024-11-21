# Connect to Azure AD
Connect-AzureAD

# Define the path for the CSV file
$csvPath = "ExportedUsers.csv"

# Get all users from Azure AD and select the required properties
$users = Get-AzureADUser -All $true | ForEach-Object {
    $user = $_
    $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
    $licenses = ($user.AssignedLicenses | ForEach-Object { (Get-AzureADSubscribedSku | Where-Object { $_.SkuId -eq $_.SkuId }).SkuPartNumber }) -join ","
    [PSCustomObject]@{
        DisplayName = $user.DisplayName
        JobTitle = $user.JobTitle
        Manager = if ($manager) { $manager.DisplayName } else { "No Manager" }
        Licenses = $licenses
    }
}

# Export the selected properties to a CSV file
$users | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Export completed. The CSV file is located at $csvPath"