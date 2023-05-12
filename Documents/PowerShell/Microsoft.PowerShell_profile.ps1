# https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3

# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config "~\Documents\dotfiles\Documents\PowerShell\ayu.omp.json" | Invoke-Expression

# oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\json.omp.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

# initial scoop auto complete
$scoopComoletion = "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"

Import-Module $scoopComoletion

Import-Module npm-completion

Import-Module ZLocation

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
Set-Alias mpv mpvnet
Set-Alias mf musicfox


Set-PSReadlineOption -ShowToolTip #-PredictionViewStyle "ListView"
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

function lzf {Get-ChildItem . -Attributes Directory | Invoke-Fzf | Set-Location}
function ldzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { lf $_ } }
function vmfzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ } }
function codzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { code $_ -n } }
function cofzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ -r } }
function fdff {fd --glob $args | Invoke-Fzf | ForEach-Object { nvim $_ }}
function esf {
    if(!$args) {
     $args = $PWD.Path
    }
   es -parent "$args" /a-d /on -sort-descending | Invoke-Fzf | ForEach-Object { nvim $_ }
}
function esd {
    if(!$args) {
     $args = $PWD.Path
    }
   es /ad -parent $args | Invoke-Fzf | Set-Location
}

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
function rwsl { sudo netsh winsock reset}

# get-CmdletAlias
function gca ($cmdletname) {
  Get-Alias |
  Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
  Format-Table -Property Definition, Name -AutoSize
}
# Clear-RecycleBin
function crb { Clear-RecycleBin -Force }

function rma($item) {Remove-Item $item -Recurse -Force}


# nc

function ncr { nc rm }
function ncu { nc up }

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


# conda

function conda_init {
  #region conda initialize
  # !! Contents within this block are managed by 'conda init' !!
  If (Test-Path "F:\Scoop\local\apps\anaconda3\current\Scripts\conda.exe") {
      (& "F:\Scoop\local\apps\anaconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
  }
#endregion
}

function cc($params){
  conda create -n $params[0] python=$params[1]
}

# tips

function Get-Tips {

  $tips = @(
    [pscustomobject]@{
      Command     = 'fcd'
      Description = 'navigate to subdirectory'

    },
    [pscustomobject]@{
      Command     = 'ALT+C'
      Description = 'navigate to deep subdirectory'

    },
    [pscustomobject]@{
      Command     = 'z'
      Description = 'ZLocation'

    },
    [pscustomobject]@{
      Command     = 'fz'
      Description = 'ZLocation through fzf'

    },
    [pscustomobject]@{
      Command     = 'fe'
      Description = 'fuzzy edit file'

    },
    [pscustomobject]@{
      Command     = 'fh'
      Description = 'fuzzy invoke command from history'

    },
    [pscustomobject]@{
      Command     = 'fkill'
      Description = 'fuzzy stop process'

    },
    [pscustomobject]@{
      Command     = 'fd'
      Description = 'find https://github.com/sharkdp/fd#how-to-use'

    },
    [pscustomobject]@{
      Command     = 'rg'
      Description = 'find in files https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md'

    }
  )

  Write-Output $tips | Format-Table
}