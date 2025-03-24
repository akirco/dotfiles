
# global path
# git clone https://github.com/akirco/dotfiles "$env:USERPROFILE\\documents\\dotfiles"

$ModulePath = "E:\\config\\powershell\\modules"
$OMPThemesPath = "$ModulePath\\..\\theme\\tokyonight_storm.omp.json"


# Enable-ExperimentalFeature PSSubsystem
try {
  Get-PSSubsystem -Kind CommandPredictor | Out-Null
}
catch {
  Enable-ExperimentalFeature -Name PSSubsystemPluginModel -WarningAction SilentlyContinue
}
# initial oh-my-posh themes
oh-my-posh.exe --init --shell pwsh --config $OMPThemesPath | Invoke-Expression
# (@(& oh-my-posh.exe init pwsh --config=$OMPThemesPath --print) -join "") | Invoke-Expression


Import-Module Terminal-Icons

Import-Module ZLocation

Import-Module CompletionPredictor

Import-Module DirectoryPredictor

Import-Module PSEverything

Import-Module PSFzf

$(Get-ChildItem -Path $ModulePath).FullName | ForEach-Object {
  Import-Module $_
}



# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'alt+s' -PSReadlineChordReverseHistory 'alt+h'

# pass your override to PSFzf:
$commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }

Set-PsFzfOption -AltCCommand $commandOverride

Set-PsFzfOption -EnableAliasFuzzyEdit
Set-PsFzfOption -EnableAliasFuzzyFasd
Set-PsFzfOption -EnableAliasFuzzyHistory
Set-PsFzfOption -EnableAliasFuzzyKillProcess
Set-PsFzfOption -EnableAliasFuzzySetLocation
Set-PsFzfOption -EnableAliasFuzzyScoop
Set-PsFzfOption -EnableAliasFuzzySetEverything
Set-PsFzfOption -EnableAliasFuzzyZLocation
Set-PsFzfOption -EnableAliasFuzzyGitStatus
Set-PsFzfOption -EnableFd

Enable-PoshTooltips
Enable-PoshTransientPrompt
Set-PSReadlineOption -ShowToolTip -PredictionViewStyle ListView -HistoryNoDuplicates -WarningAction SilentlyContinue
Set-PSReadLineOption -PredictionSource HistoryAndPlugin -HistoryNoDuplicates -Colors @{
  Command            = '#21acff'
  Number             = '#c678dd'
  Member             = '#e43535'
  Operator           = '#f6ad55'
  Type               = '#6262ea'
  Variable           = '#21c68b'
  Parameter          = '#e9967a'
  ContinuationPrompt = '#ff8c00'
  Default            = '#12c768'
}
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

(& s --completion powershell) | Out-String | Invoke-Expression
