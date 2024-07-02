<#
.DESCRIPTION
  Quick and easy way to stop Exchange services. This requires an elavated PowerShell window.

.NOTES
  Version:        1.0
  Author:         Christopher Boni
  Creation Date:  3rd January 2019
  Purpose/Change: Initial script development
#>

# Queries all services to find servies that start with Microsoft Exchange and then attempts to stop services.
Get-Service | Where-Object { $_.DisplayName –like “Microsoft Exchange *” } | Stop-Service

# Run command a 2nd time to stop stop the services that failed to stop due to dependencies.
Get-Service | Where-Object { $_.DisplayName –like “Microsoft Exchange *” } | Stop-Service