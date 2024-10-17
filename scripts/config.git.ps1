# Configure Git script

Write-Host "Getting required variables"

$homeDirectory = $env:USERPROFILE

Write-Host "Defining functions"

function Base-Config {
    Write-Host "Starting base config process"

    Write-Host "Generating ssh keys"

    # Create SSH directory
    New-Item -Path "$homeDirectory" -Name ".ssh" -ItemType "directory"

    # Generate SSH key
    ssh-keygen -b 4096 -t rsa -f "$homeDirectory\.ssh\id_rsa"

    Write-Host "Setting basic git configuration globally"

    # Global Git configuration
    git config --global core.editor "code --wait"
    git config --global core.autocrlf true
    git config --global push.autoSetupRemote true
    git config --global rerere.enabled true
    git config --global commit.gpgSign true
    git config --global gpg.format ssh
    git config --global alias.lg "log --graph --abbrev-commit --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'"
    git config --global user.signingKey "$homeDirectory\.ssh\id_rsa.pub"
}

function Multi-Install {
    Write-Host "Starting a multi install process"

    Base-Config

    Write-Host "Multi config is going to be setup in the directory $homeDirectory\source\repos"

    Write-Host "Creating required directories"

    New-Item -Path "$homeDirectory" -Name "source" -ItemType "directory"
    New-Item -Path "$homeDirectory\source" -Name "repos" -ItemType "directory"

    $configName = "NONE"
    while ($configName -ne "") {
        $configName = Read-Host "What's the name of the configuration (empty if no other configurations); name cannot be 'NONE'"

        if ($configName -ne "") {
	    Write-Host "Creating required directory and config file"


            New-Item -Path "$homeDirectory\source\repos" -Name "$configName" -ItemType "directory"
            $configFilePath = "$homeDirectory\source\repos\$configName\.gitconfig-$configName"
            New-Item -Path "$homeDirectory\source\repos\$configName" -Name ".gitconfig-$configName" -ItemType "file"

            $configUserName = Read-Host "What's the git username?"
            $configUserEmail = Read-Host "What's the git email?"

            $configFileContent = @"
[user]
    name = $configUserName
    email = $configUserEmail
"@

            Set-Content -Path $configFilePath -Value $configFileContent

	    Write-Host "Patching .gitconfig base file"

            $includeIfConfig = @"
[includeif "gitdir:~/source/repos/$configName/"]
    path = ~/source/repos/$configName/.gitconfig-$configName
"@

            Add-Content -Path "$homeDirectory\.gitconfig" -Value $includeIfConfig
        }
    }
}

function Single-Install {
    Write-Host "Starting a single install process"

    Base-Config

    $configUserName = Read-Host "What's the git username?"
    $configUserEmail = Read-Host "What's the git email?"

    Write-Host "Setting up git user informations"

    git config --global user.name $configUserName
    git config --global user.email $configUserEmail
}

Write-Host "Starting script"

$isMultiConfig = Read-Host "Does the git installation require multiple .gitconfig files? [y/yes n/no]"

if ($isMultiConfig -eq "y" -or $isMultiConfig -eq "yes") {
    Multi-Install
} else {
    Single-Install
}
