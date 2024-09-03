<#
.DESCRIPTION
  Modified script to get email stats.

.NOTES
  Version: 1.0
  Link to orginal script: https://github.com/Scine/Office365/blob/master/Get-DetailedMessageStats.ps1
#>
#REQUIRES -Module ExchangeOnlineManagement

# Define the output CSV file path in the user's temporary directory
$OutputFile = "$env:TEMP\DetailedMessageStats.csv"

# Connect to Exchange Online
Connect-ExchangeOnline

Write-Host "Collecting Recipients..."

# Get all recipients from Office 365, selecting only their primary email addresses
$Recipients = Get-Recipient * -ResultSize Unlimited | Select-Object PrimarySMTPAddress

# Initialize a hash table to store mail traffic data for each recipient
$MailTraffic = @{}
foreach ($Recipient in $Recipients) {
    # Create an empty nested hash table for each recipient, using their email as the key
    $MailTraffic[$Recipient.PrimarySMTPAddress.ToLower()] = @{}
}
# Clear the $Recipients variable to free up memory
$Recipients = $null

# Collect Message Tracking Logs
$Messages = $null
$Page = 1
do {
    Write-Host "Collecting Message Tracking - Page $Page..."
    # Get a page of message trace logs, selecting relevant properties
    $CurrMessages = Get-MessageTrace -PageSize 5000 -Page $Page | Select-Object Received, SenderAddress, RecipientAddress, Size
    $Page++
    # Append the current page's messages to the main $Messages array
    $Messages += $CurrMessages
}
# Continue fetching pages until there are no more messages
until ($null -eq $CurrMessages)

Write-Host "Crunching Results..."

# Process each message and update the mail traffic hash table
foreach ($Message in $Messages) {
    # Check if the sender address exists
    if ($null -ne $Message.SenderAddress) {
        if ($MailTraffic.ContainsKey($Message.SenderAddress)) {
            # Format the message date
            $MessageDate = Get-Date -Date $Message.Received -Format yyyy-MM-dd

            if ($MailTraffic[$Message.SenderAddress].ContainsKey($MessageDate)) {
                # Increment outbound count and add message size if the date already exists
                $MailTraffic[$Message.SenderAddress][$MessageDate]['Outbound']++
                $MailTraffic[$Message.SenderAddress][$MessageDate]['OutboundSize'] += $Message.Size
            }
            else {
                # Create a new entry for the date and initialize counts and sizes
                $MailTraffic[$Message.SenderAddress][$MessageDate] = @{}
                $MailTraffic[$Message.SenderAddress][$MessageDate]['Outbound'] = 1
                $MailTraffic[$Message.SenderAddress][$MessageDate]['Inbound'] = 0
                $MailTraffic[$Message.SenderAddress][$MessageDate]['InboundSize'] = 0
                $MailTraffic[$Message.SenderAddress][$MessageDate]['OutboundSize'] += $Message.Size
            }

        }
    }
    # Check if the recipient address exists
    if ($null -ne $Message.RecipientAddress) {
        if ($MailTraffic.ContainsKey($Message.RecipientAddress)) {
            # Format the message date
            $MessageDate = Get-Date -Date $Message.Received -Format yyyy-MM-dd

            if ($MailTraffic[$Message.RecipientAddress].ContainsKey($MessageDate)) {
                # Increment inbound count and add message size if the date already exists
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['Inbound']++
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['InboundSize'] += $Message.Size
            }
            else {
                # Create a new entry for the date and initialize counts and sizes
                $MailTraffic[$Message.RecipientAddress][$MessageDate] = @{}
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['Inbound'] = 1
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['Outbound'] = 0
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['OutboundSize'] = 0
                $MailTraffic[$Message.RecipientAddress][$MessageDate]['InboundSize'] += $Message.Size

            }
        }
    }
}

Write-Host "Formatting Results..."

# Create a DataTable to store the formatted results
$table = New-Object system.Data.DataTable "DetailedMessageStats"

# Add columns to the DataTable with appropriate data types
$col1 = New-Object system.Data.DataColumn Date, ([datetime])
$table.columns.add($col1)
$col2 = New-Object system.Data.DataColumn Recipient, ([string])
$table.columns.add($col2)
$col3 = New-Object system.Data.DataColumn Inbound, ([int])
$table.columns.add($col3)
$col4 = New-Object system.Data.DataColumn Outbound, ([int])
$table.columns.add($col4)
$col5 = New-Object system.Data.DataColumn InboundSize, ([int])
$table.columns.add($col5)
$col6 = New-Object system.Data.DataColumn OutboundSize, ([int])
$table.columns.add($col6)

# Transpose the hash table data into the DataTable
ForEach ($Recipient in $MailTraffic.keys) {
    $RecipientName = $Recipient

    foreach ($Date in $MailTraffic[$RecipientName].keys) {
        $row = $table.NewRow()
        $row.Date = $Date
        $row.Recipient = $RecipientName
        $row.Inbound = $MailTraffic[$RecipientName][$Date].Inbound
        $row.Outbound = $MailTraffic[$RecipientName][$Date].Outbound
        $row.InboundSize = $MailTraffic[$RecipientName][$Date].InboundSize
        $row.OutboundSize = $MailTraffic[$RecipientName][$Date].OutboundSize
        $table.Rows.Add($row)
    }
}

# Export the results
$table | Sort-Object Date, Recipient, Inbound, Outbound, InboundSize, OutboundSize | export-csv $OutputFile
Write-Host "Results saved to $OutputFile"