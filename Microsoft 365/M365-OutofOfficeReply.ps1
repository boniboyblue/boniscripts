<#
.DESCRIPTION
    Set out of office for multiple users.
    Please ensure the CSV file is setups as:-

    EmailAddress   
    name@domain.com
    name@domain.com
    name@domain.com

.NOTES
    Version:        1.0.0
#>
#REQUIRES -Module ExchangeOnlineManagement

# Connect to Exchange Online using your admin credentials
Connect-ExchangeOnline

# Import the list of users from a CSV file
$users = Import-Csv -Path "ooo.csv"

# Loop through each user in the CSV file
foreach ($user in $users) {
    # Set the out of office message for the current user
    Set-MailboxAutoReplyConfiguration -Identity $user.EmailAddress -AutoReplyState Enabled -InternalMessage "Message Goes Here." -ExternalMessage "Message Goes Here."
}