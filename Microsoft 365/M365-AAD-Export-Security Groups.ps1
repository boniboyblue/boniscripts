# Connects to AzureAD - use GA account when prompted.
Connect-AzureAD

# Let's creaste some varibables
$SecurityGroups = Get-AzureADGroup -Filter "SecurityEnabled eq true" -all $true
$Result = @()

# Let's create a looping arugment to grab the list of members from all security groups.
$SecurityGroups | ForEach-Object {
    $SecurityGroup = $_
    Get-AzureADGroupMember -ObjectId $SecurityGroup.ObjectId | ForEach-Object {
        $GroupMember = $_
        $Result += New-Object PSObject -property @{ 
            GroupName = $SecurityGroup.DisplayName
            Member = $GroupMember.DisplayName
            UserPrincipalName = $GroupMember.UserPrincipalName
        }
    }
}

# Let's export the above results into a CSV file.
$Result | Export-CSV "C:\Temp\Security-Group-Members.csv" -NoTypeInformation -Encoding UTF8