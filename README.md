<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#scoop">scoop</a>
      <ul>
        <li>install</li>
        <li>alias</li>
        <li>bucket</li>
      </ul>
    </li>
    <li>
      <a href="#terminal settings">terminal settings</a>
      <ul>
        <li>Nologo info</li>
        <li>PSModules</li>
        <li>$profile</li>
      </ul>
    </li>
    <li><a href="#wsl">wsl</a></li>
  </ol>
</details>

## tips

- `if you have a better share to leave a link.`

## neovim

- use [NvChad](https://github.com/NvChad/NvChad)

## scoop

- install

```powershell
# raw.githubusercontent.com is ok
iwr -useb 'https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1' -outfile 'install.ps1'

.\install.ps1 -ScoopDir 'G:\scoop' -ScoopGlobalDir 'G:\scoop\global' -NoProxy

```

- alias

```powershell
scoop alias add i 'scoop install $args[0]' "install app"
scoop alias add s 'scoop search $args[0]' "search app"
scoop alias add ls 'scoop list' 'List installed apps'
scoop alias add rm 'scoop uninstall $args[0]' "uninstall app"
scoop alias add up 'scoop update $args[0]' "update app or itself"
scoop alias add rma 'scoop cleanup *' "remove old version"
scoop alias add rmc 'scoop cache rm *' "remove dowloaded file"
```

- app bucket

```powershell
scoop bucket add aki 'https://github.com/akirco/aki-apps.git'
```

- app backup

> scoop import [apps.json](https://github.com/akirco/dotfiles/blob/master/apps.json)

## terminal settings

- Nologo info

```powershell
# dir  G:\scoop\shims\pwsh.exe -Nologo
```

- PSModules

> use scoop install follow modules

- scoop-completion
- [scoop-search](https://github.com/akirco/shell-scripts)(aki-apps)
- npm-completion
- Terminal-Icons
- [CompletionPredictor](https://github.com/PowerShell/CompletionPredictor)
- [DirectoryPredictor](https://github.com/Ink230/DirectoryPredictor)
- lazy-posh-git
- npm-completion
- posh-git
- PSFzf
- PSReadline(`already existed`)
- z
- Pester(`already existed`)
- [hosts](https://github.com/akirco/shell-scripts)(aki-apps)

- $profile

```powershell
# open profile
code $PROFILE.AllUsersCurrentHost
```

```powershell
# https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3

Import-Module D:\Projects\PowerShellScripts\scoop-search\scoop-search.ps1

# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config "~\Documents\dotfiles\Documents\PowerShell\ayu.omp.json" | Invoke-Expression

# oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\json.omp.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

Import-Module hosts

# initial scoop auto complete
Import-Module scoop-completion

Import-Module npm-completion

Import-Module z

# fast scoop search

#Import-Module scoop-search




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
Set-Alias emp empty-recycle-bin


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

function lzf { Get-ChildItem . -Attributes Directory | Invoke-Fzf | Set-Location }
function ldzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { lf $_ } }
function vmfzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ } }
function codzf { Get-ChildItem . -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { code $_ -n } }
function cofzf { Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ -r } }
function fdff { fd --glob $args | Invoke-Fzf | ForEach-Object { nvim $_ } }
function esf {
  if (!$args) {
    $args = $PWD.Path
  }
  es -parent "$args" /a-d /on -sort-descending | Invoke-Fzf | ForEach-Object { nvim $_ }
}
function esd {
  if (!$args) {
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

function glne { git clone $args }

function lsd { Get-ChildItem -Filter .* -Path $args }
function lsf { Get-ChildItem -Recurse . -Include *.$args }

# open $profile
function pro { nvim $PROFILE.AllUsersCurrentHost }
function lspro { $PROFILE | Get-Member -Type NoteProperty }
function rwsl { sudo netsh winsock reset }

# get-CmdletAlias
function gca ($cmdletname) {
  Get-Alias |
  Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
  Format-Table -Property Definition, Name -AutoSize
}
# Clear-RecycleBin
function crb { Clear-RecycleBin -Force }

function rma($item) { Remove-Item $item -Recurse -Force }

function sprefix {
  param (
    [Parameter(Mandatory=$false, Position=0)][string]$appName
  )
  Start-Process $(scoop prefix $appName)
}
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
  } elseif (Test-Path Function:\_pip_completeBackup) {
    # Fall back on existing tab expansion
    _pip_completeBackup $line $lastWord
  }
}
# pip powershell completion end


# conda

function conda_init {
  #region conda initialize
  conda config --set env_prompt ''
  # !! Contents within this block are managed by 'conda init' !!
  If (Test-Path "E:\scoop\apps\miniconda3\current\Scripts\conda.exe") {
      (& "E:\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
  }
  #endregion
}

# create conda env
function pyc() {
  param(
    [Parameter(Mandatory=$false, Position=0)][string]$name,
    [Parameter(Mandatory=$false, Position=1)][string]$pyversion
  )
  conda create -n $name python=$pyversion
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
```

## WSL

- wsl python env config

```powershell
# get installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# grant permission
sudo chmod 777 Miniconda3-latest-Linux-x86_64.sh

# install
./Miniconda3-latest-Linux-x86_64.sh

# rm installer
rm ./Miniconda3-latest-Linux-x86_64.sh -rf

# create pyenv
conda create -n py36 python=3.6

# activate pyenv
conda activate py36

# exit pyenv
conda deactivate
```

- conda settings

```powershell
# set conda mirror
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
conda config --add channels https://pypi.tuna.tsinghua.edu.cn/simple/torch/

# set show channel urls
conda config --set show_channel_urls yes

# show config info
conda config --show

# restore mirror
conda config --remove-key channels

# remove old mirror
conda config --remove channels https://mirrors.tuna.tsinghua.edu.cn/tensorflow/linux/cpu/

# local whl install
## download .whl
wget <pkg-url>

## extract pkg to site-packages
conda install --use-local <xxx.tar.gz>

## link deps
conda install -c local <pkgPath>
```
