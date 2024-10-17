#	entrypoint of the installation process
#	######################################
#	created by : MGREMY
#	created the : 17/10/2024
#	######################################


#Requires -RunAsAdministrator

# INSTALLATION OF WINGET
$WINGET_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$WINGET_URL = (Invoke-WebRequest -Uri $WINGET_URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

# download
Invoke-WebRequest -Uri $WINGET_URL -OutFile "winget_setup.msix" -UseBasicParsing

# install
Add-AppxPackage -Path "winget_setup.msix"

# delete file
Remove-Item "winget_setup.msix"


# Starting installation scripts
.\scripts\install.wsl_installs.ps1
.\scripts\install.winget_installs.ps1
