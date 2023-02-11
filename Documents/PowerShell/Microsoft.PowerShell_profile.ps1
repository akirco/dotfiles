# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config "~\Documents\dotfiles\Documents\PowerShell\SHELL.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

# initial scoop auto complete
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"

# fast scoop search
Invoke-Expression (&scoop-search --hook)

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
Set-PSReadlineOption -PredictionSource History
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Enable-PoshTooltips
Enable-PoshTransientPrompt


function scoop_home {Start-Process -FilePath $(scoop prefix scoop)}
function localdata {Start-Process -FilePath $env:userprofile\appdata\Local}

# git
function gia { git add . }
function gim {git commit -m $args}


 #set init dim
 #$env:dim = $(scoop prefix dim)
 #[System.Environment]::SetEnvironmentVariable('dim',$env:dim,'User')
 #$Env:PATH += $env:dim+';'
 #[System.Environment]::SetEnvironmentVariable('path',$Env:PATH,'User')


