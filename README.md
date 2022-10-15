
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
scoop alias add ls 'scoop list' 'List installed apps'
scoop alias add rm 'scoop uninstall $args[0]' "uninstall app"
scoop alias add up 'scoop update $args[0]' "Update app or Scoop itself"
scoop alias add rma 'scoop cleanup *' "remove old version"
scoop alias add rmc 'scoop cache rm *' "remove dowloaded file"
```

- app bucket

```powershell
scoop bucket add aki 'https://github.com/akirco/aki-apps.git'

scoop i git devsidecar
scoop i oh-my-posh
```

## terminal settings

- Nologo info

```powershell
# dir  G:\scoop\shims\pwsh.exe -Nologo
```

- PSModules

  - scoop-completion
  - scoop-search
  - Terminal-Icons
  - PSReadline
  - z
  - Pester

- $profile 

```powershell
#Microsoft.PowerShell_profile.ps1
 # initial oh-my-posh themes
 oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\negligible.omp.json" | Invoke-Expression
 # initial scoop auto complete
 Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"

 # scoop search
 # Invoke-Expression (&scoop-search --hook)

 # initial terminal icons
 Import-Module Terminal-Icons

 # set GuiCompletion
 Set-PSReadlineKeyHandler -Key DownArrow -ScriptBlock { Invoke-GuiCompletion }

 # ...PSReadLine
 Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

 Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward

 # Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

 Set-PSReadlineOption -PredictionSource History

 Set-PSReadlineOption -ShowToolTip

 # ls
 Set-Alias ll ls

 # scoop
 Set-Alias sco scoop

 # 清屏Ctrl+L
 Set-Alias c cls

 # kate
 Set-Alias k kate

 # 删除文件或目录
 Set-Alias t trash

 # 终端的播放器
 Set-Alias mpx mpxplay

 # nvim
 Set-Alias vm nvim

 # scoop search
 Set-Alias scps scoop-search

 # git
 Set-Alias lg lazygit

 # 打包网页到一个html
 Set-Alias mon monolith

 # 创建文件
 Set-Alias h touch

 # 终端的系统监视器
 Set-Alias n ntop

 # 重命名
 Set-Alias f2 rnr

 # 二维码发送文件
 Set-Alias qr qrcp

 #alias function
 function scoop_home {start -FilePath $(scoop prefix scoop)}

 function localdata {start -FilePath $env:userprofile\appdata\Local}

 function _apps {
    $apps = scoop.ps1 export | ConvertFrom-Json
    $app_list = $apps.apps | Format-Table
    Write-Output $app_list
 }

 # extras
 Enable-PoshTooltips
 Enable-PoshTransientPrompt
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


