<#
.DESCRIPTION
Quick and dirty script to update Office number of a user's M365. Please ensure the CVS file is setups as:-

UserPrincipalName,OfficeNumber

.NOTES
Version:        1.0
Author:         Christopher Boni
Creation Date:  16th December 2024
Purpose/Change: First release
#>
#REQUIRES -Module MSOnline

# Import the CSV file
$users = Import-Csv -Path "test.csv"

# Connect to Microsoft 365
# Connect-MsolService

# Loop through each user in the CSV file and update their Office Number
foreach ($user in $users) {
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -Phone $user.OfficeNumber
}