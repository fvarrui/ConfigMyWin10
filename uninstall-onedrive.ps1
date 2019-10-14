Write-Host @"
Script para desinstalar OneDrive del usuario actual
"@

# Load functions from library
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/fvarrui/ConfigMyWin10/master/functions.ps1"))

# Check if is running as administrator
If (Test-RunningAsAdministrator) {

    # Uninstall onedrive
    Uninstall-OneDrive

} Else {

    Write-Host -ForegroundColor Red "Must be run as" (Get-AdminUsername)

 }
