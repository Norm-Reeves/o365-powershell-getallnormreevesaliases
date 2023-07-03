function Connect-Exo{
	#Checks that EXO v2 module is installed. If not prompt for install. Then connects/prompts for AAD credentials.
	$module = Get-Module ExchangeOnlineManagement -ListAvailable
	if($module.count -eq 0){
		Write-Host Exchange Online PowerShell V2 module is not available  -ForegroundColor yellow  
		$confirm = Read-Host Are you sure you want to install module? [Y] Yes [N] No 
		if($confirm -match "[yY]"){
			Write-host "Installing Exchange Online PowerShell module"
			Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
			Import-Module ExchangeOnlineManagement
		}
		else{ 
			Write-Host "EXO V2 module is required to connect Exchange Online. Please install module using Install-Module ExchangeOnlineManagement cmdlet."
			exit
		}
	}
	
	Connect-ExchangeOnline -ShowBanner:$false
}

Write-Host -NoNewline "Establishing connection to Exchange Online..."
Connect-Exo
Write-Host "done.`n"

#Load all aliases into an array
$RecipientType='UserMailbox',  'SharedMailbox'
Write-Host -NoNewline "Downloading raw data from Exchange Online..."
$O365Data = Get-Recipient -ResultSize Unlimited -RecipientTypeDetails $RecipientType
Write-Host "done.`n"

Write-Host -NoNewline "Finding @normreeves.com aliases with a period in username..."
$allAliases = @()
$count = 0
foreach($user in $O365Data){
	#Write-Progress -Activity "`n     Retrieving email aliases of $_.DisplayName.."`n" Processed count: $Count"
	$userAliases = $user.EmailAddresses | Where-Object {$_ -clike "smtp:*"}
	foreach($userAlias in $userAliases){
		$allAliases += $userAlias -replace "smtp:",""
	}
	$count++
}
#Filter for only @normreeves.com aliases that have a "." in the username.
$normreevesAliases = "string[] aliases = {"
foreach($alias in $allAliases){
	if( $alias.ToLower().Contains("normreeves.com") -And $alias.substring(0,$alias.length-15).Contains(".") ){
		$normreevesAliases = $normreevesAliases + '"' + $alias + '", '
	}
}

$normreevesAliases.substring(0,$normreevesAliases.length-2) + "};" | Out-File normreevesAliases.txt
Write-Host "done. Output written to 'normreevesAliases.txt'`n"

#Disconnect Exchange Online session
Write-Host -NoNewline "Disconnecting Exchange Online connection..."
Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue
Write-Host "done.`n"