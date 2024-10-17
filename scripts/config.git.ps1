<#
	configure git script
#>

$isMultiConfig = Read-Host "Does the git installation requires multiple .gitconfig files ? [y/yes n/no]";

If ($isMultiConfig -eq "y" -Or $isMultiConfig -eq "yes") {
	Multi-Install;
}
Else {
	Single-Install;
}

function Multi-Install {
	echo "Starting a multi install process";
}

function Signle-Install {
	echo "Starting a single install process";
}
