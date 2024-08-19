<#
.DESCRIPTION
Quick and dirty script to add multiple aliases from to a mailbox. Please ensure the CVS file is setups as:-

alias
name@domain.com
name@domain.com
name@domain.com

.NOTES
Version:        1.0
Author:         Christopher Boni
Creation Date:  19 August 2024
Purpose/Change: First release
#>
#REQUIRES -Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Ask the user which email address they want to add aliases to
$mailbox = Read-Host "What email address do you want to add aliases too?"

# Grab the aliases from the CSV file (make sure it's named "alias.csv" and in the "C:\" drive)
$users = Import-Csv "C:\alias.csv"

# Loop through each alias in the file
foreach ($alias in $users) {
    # Get the actual alias value from the CSV row
    $alias = $($alias.alias)

    # Add the alias to the mailbox we specified earlier
    Set-Mailbox $mailbox -EmailAddresses @{Add = $alias }
}