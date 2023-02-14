
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

> scoop import  [apps.json](https://github.com/akirco/dotfiles/blob/master/apps.json)

## terminal settings

- Nologo info

```powershell
# dir  G:\scoop\shims\pwsh.exe -Nologo
```

- PSModules

  - scoop-completion
  - scoop-search
  - npm-completion
  - Terminal-Icons
  - PSReadline(`already existed`)
  - z
  - Pester(`already existed`)
- $profile 

```powershell
# open profile
code $PROFILE.AllUsersCurrentHost
```

```powershell
#Microsoft.PowerShell_profile.ps1
# https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3

# initial oh-my-posh themes
# git clone https://github.com/akirco/dotfiles.git $HOME\Documents\dotfiles --depth 1

oh-my-posh --init --shell pwsh --config "~\Documents\dotfiles\Documents\PowerShell\SHELL.json" | Invoke-Expression

# terminal icons
Import-Module Terminal-Icons

# initial scoop auto complete
$scoopComoletion="$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
write-host $scoopComoletion

Import-Module $scoopComoletion

$DirectoryPredictor = ("scoop prefix DirectoryPredictor" | Invoke-Expression )+"\DirectoryPredictor.dll"

Import-Module $DirectoryPredictor

Import-Module npm-completion

Import-Module z

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
Set-PSReadlineOption -PredictionSource History -PredictionViewStyle "ListView" -Colors @{
  Command            = 'Magenta'
  Number             = 'DarkGray'
  Member             = 'DarkGray'
  Operator           = 'DarkGray'
  Type               = 'DarkGray'
  Variable           = 'DarkGreen'
  Parameter          = 'DarkGreen'
  ContinuationPrompt = 'DarkGray'
  Default            = 'DarkGray'
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
#Set GuiCompletion 
#Set-PSReadlineKeyHandler -Key DownArrow -ScriptBlock { Invoke-GuiCompletion }

Enable-PoshTooltips
Enable-PoshTransientPrompt


if(!(Get-PSSubsystem -Kind CommandPredictor).IsRegistered){
    Enable-ExperimentalFeature PSSubsystemPluginModel
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin 
}    

function scoop_home {Start-Process -FilePath $(scoop prefix scoop)}
function localdata {Start-Process -FilePath $env:userprofile\appdata\Local}
function home {Start-Process -FilePath $env:userprofile}
# git
function gia {git add .}
function gim {git commit -m $args}
function gill {git pull}
function gish {git push origin $args}
function gine {git clone $args}

function lsd{Get-ChildItem -Filter .* -Path $args }
function lsf{Get-ChildItem -Recurse . -Include *.$args}

# open $profile
function pro {code $PROFILE.AllUsersCurrentHost}
function lspro {$PROFILE | Get-Member -Type NoteProperty}

# get-CmdletAlias
function gca ($cmdletname) {
  Get-Alias |
    Where-Object -FilterScript {$_.Definition -like "$cmdletname"} |
      Format-Table -Property Definition, Name -AutoSize
}
# Clear-RecycleBin
function crb {Clear-RecycleBin -Force}
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

