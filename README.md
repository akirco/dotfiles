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

# global path
# git clone https://github.com/akirco/dotfiles "$env:USERPROFILE\\documents\\dotfiles"
$ModulePath = "$env:USERPROFILE\\documents\\dotfiles\\powershell-profile\\modules"

# Enable-ExperimentalFeature PSSubsystem
if (!(Get-PSSubsystem -Kind CommandPredictor).IsRegistered) {
    Enable-ExperimentalFeature -Name PSSubsystemPluginModel -WarningAction SilentlyContinue
}

# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config "$ModulePath\\..\\theme\\ayu.omp.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

# hosts editor
Import-Module hosts

# initial scoop auto complete
Import-Module scoop-completion

# npm-completion
Import-Module npm-completion

# ZLocation
Import-Module ZLocation


# completion suggestions
Import-Module CompletionPredictor

# directory suggestions
Import-Module DirectoryPredictor

# PSEverything
Import-Module PSEverything



# chatgpt
Import-Module "$ModulePath\\chatgpt.psm1"

# tips log
Import-Module "$ModulePath\\gettips.psm1"

# alias
Import-Module "$ModulePath\\alias.psm1"

# conda create env : pyc name pyversion
Import-Module "$ModulePath\\pyc.psm1"

# active_conda_env
Import-Module "$ModulePath\\pyinit.psm1"

Import-Module "$ModulePath\\pstools.psm1"

Import-Module "$ModulePath\\git.psm1"

Import-Module "$ModulePath\\everything.psm1"

Import-Module "$ModulePath\\telegraph.psm1"

# fast scoop search
Import-Module "$ModulePath\\scoop.psm1"

Import-Module "$ModulePath\\r3skin.psm1"

Import-Module "$ModulePath\\remove.psm1"

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'alt+s' -PSReadlineChordReverseHistory 'alt+h'

# pass your override to PSFzf:
$commandOverride = [ScriptBlock] { param($Location) z $Location }
Set-PsFzfOption -AltCCommand $commandOverride

# Set-PsFzfOption -EnableAliasFuzzyEdit
# Set-PsFzfOption -EnableAliasFuzzyFasd
# Set-PsFzfOption -EnableAliasFuzzyHistory
# Set-PsFzfOption -EnableAliasFuzzyKillProcess
# Set-PsFzfOption -EnableAliasFuzzySetLocation
# Set-PsFzfOption -EnableAliasFuzzyScoop
# Set-PsFzfOption -EnableAliasFuzzySetEverything
# Set-PsFzfOption -EnableAliasFuzzyZLocation
# Set-PsFzfOption -EnableAliasFuzzyGitStatus
# Set-PsFzfOption -EnableFd

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
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }


function lzd {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Attributes Directory | Invoke-Fzf | Set-Location
}
function lfzd {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { lf $_ }
}
function vmf {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ }
}
function coded {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { code $_ -n }
}
function codef {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ -r }
}
function vmfdf {
    param (
        [Parameter(Mandatory = $true, Position = 0)][string]$regxExp
    )
    fd.exe --glob $regxExp | Invoke-Fzf | ForEach-Object { nvim $_ }
}
```

## commands help

```powershell
get-tips
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
