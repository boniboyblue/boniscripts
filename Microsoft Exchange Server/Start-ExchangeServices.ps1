<#
.DESCRIPTION
  Quick and easy way to start Exchange services. This requires an elavated PowerShell window.

.NOTES
  Version:        1.0
  Author:         Christopher Boni
  Creation Date:  3rd January 2019
  Purpose/Change: Initial script development
#>

# Queries all services to find servies that start with Microsoft Exchange and then sets start type to automatic.
Get-Service | Where-Object { $_.DisplayName –like “Microsoft Exchange *” } | Set-Service –StartupType Automatic

# Queries all services to find servies that start with Microsoft Exchange and then attempts to start services.
Get-Service | Where-Object { $_.DisplayName –like “Microsoft Exchange *” } | Start-Service