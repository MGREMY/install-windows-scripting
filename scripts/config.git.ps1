# Configure Git script

$homeDirectory = $env:USERPROFILE

$isMultiConfig = Read-Host "Does the git installation require multiple .gitconfig files? [y/yes n/no]"

function Base-Config {
    Write-Host "Starting base config process"

    # Create SSH directory
    New-Item -Path "$homeDirectory" -Name ".ssh" -ItemType "directory"

    # Generate SSH key
    ssh-keygen -b 4096 -t rsa -f "$homeDirectory\.ssh\id_rsa"

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

    New-Item -Path "$homeDirectory" -Name "source" -ItemType "directory"
    New-Item -Path "$homeDirectory\source" -Name "repos" -ItemType "directory"

    $configName = "NONE"
    while ($configName -ne "") {
        $configName = Read-Host "What's the name of the configuration (empty if no other configurations); name cannot be 'NONE'"

        if ($configName -ne "") {
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

    git config --global user.name $configUserName
    git config --global user.email $configUserEmail
}

if ($isMultiConfig -eq "y" -or $isMultiConfig -eq "yes") {
    Multi-Install
} else {
    Single-Install
}
