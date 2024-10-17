<#
	configure git script
#>


$homeDirectory = $env:USERPROFILE;


$isMultiConfig = Read-Host "Does the git installation requires multiple .gitconfig files ? [y/yes n/no]";

function Base-Config {
	echo "Starting base config process";

	# create ssh directory
	New-Item -Path "$($homeDirectory)" -Name ".ssh" -ItemType "directory";
	
	ssh-keygen -b 4096 -t rsa -f "$(homeDirectory)\.ssh\id_rsa";

	git config --global core.editor "code --wait";
        git config --global core.autocrlf true;
        git config --global push.autoSetupRemote true;
        git config --global rerere.enabled true;
        git config --global commit.gpgSign true;
        git config --global gpg.format ssh;
        git config --global alias.lg "log --graph --abbrev-commit --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
	git config --global user.signingKey "$($homeDirectory)\.ssh\id_rsa.pub"
}

function Multi-Install {
	echo "Starting a multi install process";

	Base-Config;
}

function Signle-Install {
	echo "Starting a single install process";

	Base-Config;
}

If ($isMultiConfig -eq "y" -Or $isMultiConfig -eq "yes") {
        Multi-Install;
}
Else {
        Single-Install;
}
