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

## dev env setup

```powershell
# #This scripts is not tested yet...
# run as admin
irm https://raw.githubusercontent.com/akirco/dotfiles/master/setup.ps1 | iex

```

## neovim

- use [astronvim](https://docs.astronvim.com/)

## scoop

- install

```powershell
# raw.githubusercontent.com is ok
iwr -useb 'https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1' -outfile 'install.ps1'

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

.\install.ps1 -ScoopDir 'G:\scoop' -ScoopGlobalDir 'G:\scoop\global' -NoProxy

scoop install sudo git

sudo Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

scoop install innounp dark

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
# link profile

New-Item -Path $PROFILE.AllUsersCurrentHost -ItemType SymbolicLink -Target $env:USERPROFILE\.config\dotfiles\powershell\Microsoft.PowerShell_profile.ps1 -Force
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
