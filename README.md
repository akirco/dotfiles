
## scoop install

```powershell
# raw.githubusercontent.com is ok
iwr -useb 'https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1' -outfile 'install.ps1'

.\install.ps1 -ScoopDir 'G:\scoop' -ScoopGlobalDir 'G:\scoop\global' -NoProxy

```

## alias

```powershell
scoop alias add i 'scoop install $args[0]' "install app"
scoop alias add ls 'scoop list' 'List installed apps'
scoop alias add rm 'scoop uninstall $args[0]' "uninstall app"
scoop alias add up 'scoop update $args[0]' "Update app or Scoop itself"
scoop alias add rma 'scoop cleanup *' "remove old version"
scoop alias add rmc 'scoop cache rm *' "remove dowloaded file"
```

## install app

```powershell
scoop bucket add aki 'https://github.com/akirco/aki-apps.git'

scoop i git devsidecar

```

## terminal settings

```powershell
# Nologo info
# dir  G:\scoop\shims\pwsh.exe -Nologo
```

## $profile

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

 # ...
 Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

 Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward

 #Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

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
 Set-Alias sos scoop-search

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

