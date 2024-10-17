# Configure NodeJS script

#Requires -RunAsAdministrator

Write-Host "Setting NodeJS environment variable 'NODE_TLS_REJECT_UNAUTHORIZED' to '0' due to some network restrictions"

[Environment]::SetEnvironmentVariable('NODE_TLS_REJECT_UNAUTHORIZED', '0', 'user')
