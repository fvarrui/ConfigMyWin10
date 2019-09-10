
# ----------------------------------
# Users/groups related functions
# ----------------------------------

# Get user name by SID
Function Get-UserBySID($sid) {
    return (Get-LocalUser | Where-Object SID -Match $sid).Name
}

# Get group name by SID
Function Get-GroupBySID($sid) {
    return (Get-LocalGroup | Where-Object SID -Match $sid).Name
}

# Get system administrator's username
Function Get-AdminUsername() {
    return (Get-UserBySID "S-1-5-21.*-500")
}

# Get administrators' group name
Function Get-AdminGroupname() {
    return (Get-GroupBySID "S-1-5-32-544")
}

# Check if current user has admin privileges
Function Test-RunningAsAdministrator() {
    return (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -Match "S-1-5-32-544")
}

# ----------------------------------
# Chocolatey related functions
# ----------------------------------

# Checking if Chocolatey is installed
function Test-ChocoInstalled() {
    Write-Host -NoNewline "Checking if Chocolatey is installed ... "
    $ChocoInstalled = $false
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        $ChocoInstalled = $true
        Write-Host "[INSTALLED]"
    } else {
        Write-Host "[NOT INSTALLED]"
    }
    return $ChocoInstalled
}

# Install Chocolatey
function Install-Choco() {
    Write-Host "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install a package with Chocolatey
function Install-Package([string]$package) {
    Write-Host -NoNewline "Installing $package ... "
    choco install --ignore-checksum -y $package | Out-Null
    If ($LASTEXITCODE -eq 0) {
        Write-Host "[Ok]"
    } else {
        Write-Host "[Error]"
    }
}

# ----------------------------------
# OneDrive related functions
# ----------------------------------

# https://lifehacker.com/how-to-completely-uninstall-onedrive-in-windows-10-1725363532
function Uninstall-OneDrive() {

    Write-Host "Uninstalling OneDrive..."
 
    # check if onedrive is running
    If ((Get-Process -ErrorAction SilentlyContinue OneDrive | Measure-Object).Count -ge 1) {

        # stopping onedrive process
        Write-Host "Stopping OneDrive process ..."
        Stop-Process -Force -Name OneDrive

        # run onedrive uninstaller
        Write-Host "Uninstalling OneDrive ..."
        If ([System.Environment]::Is64BitOperatingSystem) {
            &"$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall
        } else {
            &"$env:SystemRoot\System32\OneDriveSetup.exe" /uninstall
        }

        Write-Host "Process completed"

    } else {

        Write-Host -ForegroundColor Yellow "OneDrive is already uninstalled"

    }

 }

# ----------------------------------
# Software installation related functions
# ----------------------------------

Function Get-PackagesList() {
    return (((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/iesdpm/informatica/master/config/windows/packages.txt"))).Split("`n")
}

Function Install-Packages() {

    Write-Host "Installing packages ..."

    # Instalación del gestor de paquetes Chocolatey
    If (-Not (Test-ChocoInstalled)) {
        Install-Choco
    }

    # Instalación de paquetes
    Get-PackagesList | ForEach-Object { 
        Install-Package $_
    }

}

# ----------------------------------
# Registry related functions
# ----------------------------------

Function Find-SecondaryDrive() {
    
    # get removible drives excluding system volume
    $drives = Get-WmiObject Win32_Volume -Filter ("DriveType={0}" -f [int][System.io.Drivetype]::Fixed) `
                | Where-Object { $_.DriveLetter -ne $env:SystemDrive -and $_.SystemVolume -eq $false }

    foreach ($drive in $drives) {
        If ($drive.DriveLetter -ne $null) {
            return $drive.DriveLetter.Trim()
        }
    }

    return $null

}

Function Change-ProfilesLocation([string]$location = (Find-SecondaryDrive)) {

    Write-Host "Changing profiles location to $location in Windows Registry..."

    $drive = 

    If  ($location -eq $null -or $location.Length -eq 0) {
        Write-Host -ForegroundColor Yellow "There is no secondary disk drive to store user profiles"
        Return
    }

    $location = $location.Trim()

    $path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

    Set-ItemProperty -Path $path -Name "ProfilesDirectory" -Value "$location\Users".Trim()

    Write-Host "Profiles location changed to $location. New profiles will be stored in $location\Users"

}

# ----------------------------------
# Local users related functions
# ----------------------------------

Function Create-User($username, $password, $group) {

    Write-Host "Creating user $username ..."

    If (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
       
        Write-Host -ForegroundColor Yellow "User $username already exists."

    } else {

        New-LocalUser `            -Name $username `            -Password (ConvertTo-SecureString -Force -AsPlainText $password) `            -AccountNeverExpires `            -PasswordNeverExpires `            -UserMayNotChangePassword | Out-Null

        Add-LocalGroupMember -Group $group -Member $username

        Write-Host "User $username created successfully"

    }
}

# ----------------------------------
# Task scheduling related functions
# ----------------------------------

Function Schedule-Shutdown() {
    Write-Output "Scheduling system shutdown everyday at 3pm..."

    $taskName = "Shutdown computer"

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        
        Write-Host -ForegroundColor Yellow "Scheduled task $taskName already exists"

    } else { 

        $action = New-ScheduledTaskAction -Execute "shutdown" -Argument "/s /f /t 0"
        $trigger = New-ScheduledTaskTrigger -Daily -At "15:00:00"
        Register-ScheduledTask -Description "Power off computer everyday at 3pm" -TaskName $taskName -Action $action -Trigger $trigger
    }
}
