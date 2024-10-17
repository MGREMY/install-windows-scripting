#	install and configure WSL2

#Requires -RunAsAdministrator

Write-Host "Installing WSL with Debian distro"

wsl --install
wsl --install -d debian
