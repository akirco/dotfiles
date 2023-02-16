# https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3

# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config "~\Documents\dotfiles\Documents\PowerShell\SHELL.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

# initial scoop auto complete
$scoopComoletion = "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"

Import-Module $scoopComoletion

Import-Module npm-completion

Import-Module z

# fast scoop search
Invoke-Expression (&scoop-search --hook)



Import-Module CompletionPredictor
Import-Module DirectoryPredictor
# if (!(Get-PSSubsystem -Kind CommandPredictor).IsRegistered) {
#   Enable-ExperimentalFeature PSSubsystemPluginModel
# }



# alias
Set-Alias ll ls
Set-Alias sco scoop
Set-Alias c cls
Set-Alias t trash
Set-Alias mpx mpxplay
Set-Alias vm nvim
Set-Alias lg lazygit
Set-Alias mon monolith
Set-Alias h touch
Set-Alias n ntop  
Set-Alias f2 rnr
Set-Alias qr qrcp

Set-PSReadlineOption -ShowToolTip
Set-PSReadLineOption -PredictionSource HistoryAndPlugin -HistoryNoDuplicates -PredictionViewStyle "ListView" -Colors @{
  Command            = '#21acff'
  Number             = '#c678dd'
  Member             = 'DarkRed'
  Operator           = 'DarkYellow'
  Type               = 'DarkGray'
  Variable           = '#21c68b'
  Parameter          = '#e9967a'
  ContinuationPrompt = '#ff8c00'
  Default            = 'DarkGray'
}
# Set-PSReadlineOption -PredictionSource History -PredictionViewStyle "ListView" -Colors @{
#   Command            = '#21acff'
#   Number             = '#c678dd'
#   Member             = 'DarkRed'
#   Operator           = 'DarkYellow'
#   Type               = 'DarkGray'
#   Variable           = '#21c68b'
#   Parameter          = '#e9967a'
#   ContinuationPrompt = '#ff8c00'
#   Default            = 'DarkGray'
# }

# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward


# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'alt+s' -PSReadlineChordReverseHistory 'alt+h'

# example command - use $Location with a different command:
$commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }
# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Enable-PoshTooltips
Enable-PoshTransientPrompt
  

function ldzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { lf $_ } }
function vmfzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ } }
function codzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { code $_ -n } }
function cofzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ -r } }
function scoop_home { Start-Process -FilePath $(scoop prefix scoop) }
function localdata { Start-Process -FilePath $env:APPDATA }
function home { Start-Process -FilePath $env:USERPROFILE }
# git
function gia { git add . }
function gim { git commit -m $args }
function gill { git pull }
function gish { git push origin $args }

function glne { git clone $args}

function lsd { Get-ChildItem -Filter .* -Path $args }
function lsf { Get-ChildItem -Recurse . -Include *.$args }

# open $profile
function pro { code $PROFILE.AllUsersCurrentHost }
function lspro { $PROFILE | Get-Member -Type NoteProperty }

# get-CmdletAlias
function gca ($cmdletname) {
  Get-Alias |
  Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
  Format-Table -Property Definition, Name -AutoSize
}
# Clear-RecycleBin
function crb { Clear-RecycleBin -Force }


# pip powershell completion start
if ((Test-Path Function:\TabExpansion) -and -not `
  (Test-Path Function:\_pip_completeBackup)) {
  Rename-Item Function:\TabExpansion _pip_completeBackup
}
function TabExpansion($line, $lastWord) {
  $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
  if ($lastBlock.StartsWith("F:\Scoop\local\apps\python\current\python.exe -m pip ")) {
    $Env:COMP_WORDS = $lastBlock
    $Env:COMP_CWORD = $lastBlock.Split().Length - 1
    $Env:PIP_AUTO_COMPLETE = 1
        (& F:\Scoop\local\apps\python\current\python.exe -m pip).Split()
    Remove-Item Env:COMP_WORDS
    Remove-Item Env:COMP_CWORD
    Remove-Item Env:PIP_AUTO_COMPLETE
  }
  elseif (Test-Path Function:\_pip_completeBackup) {
    # Fall back on existing tab expansion
    _pip_completeBackup $line $lastWord
  }
}
# pip powershell completion end

