<#
.DESCRIPTION
  Change the default permission for all calendars in M365 tenant to Limited Details.

.NOTES
  Version:        1.0.0
#>
#REQUIRES -Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Change permissions for all users with calendars to Limited Details (https://learn.microsoft.com/en-us/powershell/module/exchange/add-mailboxfolderpermission?view=exchange-ps)
foreach ($user in Get-Mailbox -RecipientTypeDetails UserMailbox) {
    Set-MailboxFolderPermission -Identity ($user.alias + ':\calendar’) -User Default -AccessRights LimitedDetails
}