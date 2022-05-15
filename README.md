Say goodbye to yesterday.

Say hello to tomorrow.

Remember you can be better.

Be yourself and do yourself.

Year by year, day by day.

Enhance yourself to meet challenges.

## Scoop install
```
#修改hosts
#github
140.82.114.3 github.com
185.199.110.153  assets-cdn.github.com
199.232.69.194 github.global.ssl.fastly.net
199.232.68.133 raw.githubusercontent.com

Set-ExecutionPolicy RemoteSigned -scope CurrentUser
$env:SCOOP='D:\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
$env:SCOOP_GLOBAL='D:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine') #此步骤管理员运行
Invoke-Expression (New-Object 
#确保raw.githubusercontent.com可以访问
System.Net.WebClient).DownloadString('https://get.scoop.sh')
```

```
scoop install sudo -g
#ssr代理
scoop config proxy 127.0.0.1:1080
#scoop config rm proxy
scoop install aria2 #喵的死活下不动
scoop install git
scoop update
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
scoop install innounp
scoop install dark
scoop checkup
scoop bucket add extras
scoop install typora
scoop install vscode
code  $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

```

```powershell
scoop install figlet
scoop install cowsay
scoop bucket add dorado https://github.com/h404bi/dorado
sudo scoop install trash -g
sudo scoop install nvm -g
scoop bucket add Ash258 'https://github.com/Ash258/Scoop-Ash258.git'
scoop install carnac
scoop bucket add iszy 'https://github.com/ZvonimirSun/scoop-iszy.git'
scoop install wechat
scoop install qq-dreamcast
scoop install utools
scoop install switchhosts
scoop install scoop bucket add my-scoop-bucket https://github.com/destinyenvoy/my-scoop-bucket
scoop install gvim
#设置别名
scoop alias add i 'scoop install $args[0]'
scoop alias add rm 'scoop uninstall $args[0]'
scoop alias add ls 'scoop list' 'List installed apps'
scoop alias add up 'scoop update $args[0]' 'Update apps, or Scoop itself'
```
## windows terminal
### installation
```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
$profile
cd C:\Users\16877\Documents\WindowsPowerShell\
ls
New-Item "Microsoft.PowerShell_profile.ps1" -type file
code Microsoft.PowerShell_profile.ps1
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox
```
### color scheme


| Property              | Necessity  | Type   | Description                                              | chinese        | customize  |
| --------------------- | ---------- | ------ | -------------------------------------------------------- | --------------  | ---------- |
| `name`                | *Required* | String | Name of the color scheme.                                | 名称            | casuordark |
| `foreground`          | *Required* | String | Sets the foreground color of the color scheme.           | 前景色          | #008080    |
| `background`          | *Required* | String | Sets the background color of the color scheme.           | 背景色          | #002B36    |
| `selectionBackground` | Optional   | String | Sets the selection background color of the color scheme. | 选择后的背景色   | #93A1A1    |
| `cursorColor`         | Optional   | String | Sets the cursor color of the color scheme.               | 光标的颜色      | #FF5F56    |
| `black`               | *Required* | String | Sets the color used as ANSI black.                       |                | #002731    |
| `blue`                | *Required* | String | Sets the color used as ANSI blue.                        |                | #21A3F1    |
| `brightBlack`         | *Required* | String | Sets the color used as ANSI bright black.                |                | #111111    |
| `brightBlue`          | *Required* | String | Sets the color used as ANSI bright blue.                 |                | #31C3C1    |
| `brightCyan`          | *Required* | String | Sets the color used as ANSI bright cyan.                 |                | #00FFFF    |
| `brightGreen`         | *Required* | String | Sets the color used as ANSI bright green.                |                | #00FFCC    |
| `brightPurple`        | *Required* | String | Sets the color used as ANSI bright purple.               |                | #EE82EE    |
| `brightRed`           | *Required* | String | Sets the color used as ANSI bright red.                  |                | #FF5F56    |
| `brightWhite`         | *Required* | String | Sets the color used as ANSI bright white.                |                | #F5F5F5    |
| `brightYellow`        | *Required* | String | Sets the color used as ANSI bright yellow.               |                | #FFBD2E    |
| `cyan`                | *Required* | String | Sets the color used as ANSI cyan.                        |                | #00A6CC    |
| `green`               | *Required* | String | Sets the color used as ANSI green.                       |                | #05E177    |
| `purple`              | *Required* | String | Sets the color used as ANSI purple.                      |                | #B57EDC    |
| `red`                 | *Required* | String | Sets the color used as ANSI red.                         |                | #EB4B3D    |
| `white`               | *Required* | String | Sets the color used as ANSI white.                       |                | #F9F6F6    |
| `yellow`              | *Required* | String | Sets the color used as ANSI yellow.                      |                | #EDC87D    |




```json
{
            "name": "CasuorDark",
            "black": "#002731",
            "red": "#EB4B3D",
            "green": "#05E177",
            "yellow": "#EDC87D",
            "blue": "#1498eb",
            "purple": "#B57EDC",
            "cyan": "#25c5b8",
            "white": "#9DA4B0",
            "brightBlack": "#CCCCCC",
            "brightRed": "#FF5F56",
            "brightGreen": "#788E05",
            "brightYellow": "#FFBD2E",
            "brightBlue": "#00BBFF",
            "brightPurple": "#EE82EE",
            "brightCyan": "#00FFFF",
            "brightWhite": "#C2616A",
            "background": "#00313f",
            "foreground": "#008080",
            "selectionBackground": "#93A1A1",
            "cursorColor": "#FF5F56"
  }
```


```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",

    "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "copyOnSelect": false,
    "copyFormatting": false,
    "initialCols" : 100,
    "initialRows" : 30,
    "profiles":
    {
        "defaults":
        {
            // Put settings here that you want to apply to all profiles.

        },
        "list":
        [
            {
                // Make changes here to the powershell.exe profile.
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "name": "Windows PowerShell",
                "commandline": "powershell.exe",
                "hidden": false,
                "fontFace" : "Hack",
                "fontSize" : 10,
                "cursorShape" : "filledBox",
                "useAcrylic": true,
                "acrylicOpacity" : 0.5,
                "colorScheme" : "CasuorDark",
                "backgroundImage": "E:/OneDrive/Pictures/terminal/win.jpg",
                "backgroundImageOpacity": 0.1
            },
            {
                // Make changes here to the cmd.exe profile.
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "name": "命令提示符",
                "commandline": "cmd.exe",
                "hidden": false
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "name" : "Git Bash",
                "commandline" : "D:/Scoop/apps/git/current/bin/bash.exe -li",
                "icon" : "D:/Scoop/apps/git/current/mingw64/share/git/git-for-windows.ico",
                "startingDirectory" : "%USERPROFILE%",
                "hidden": false,
                "fontFace" : "Hack",
                "fontSize" : 10,
                "cursorColor" : "#FFF55F",
                "cursorShape" : "bar",
                "useAcrylic": true,
                "acrylicOpacity" : 0.1,
                "colorScheme" : "CasuorDark"
            }
        ]
    },
    "schemes": 
    [
    
        {
            "name": "CasuorDark",
            "black": "#002731",
            "red": "#EB4B3D",
            "green": "#05E177",
            "yellow": "#EDC87D",
            "blue": "#1498eb",
            "purple": "#B57EDC",
            "cyan": "#25c5b8",
            "white": "#9DA4B0",
            "brightBlack": "#CCCCCC",
            "brightRed": "#FF5F56",
            "brightGreen": "#788E05",
            "brightYellow": "#FFBD2E",
            "brightBlue": "#00BBFF",
            "brightPurple": "#EE82EE",
            "brightCyan": "#00FFFF",
            "brightWhite": "#C2616A",
            "background": "#00313f",
            "foreground": "#008080",
            "selectionBackground": "#93A1A1",
            "cursorColor": "#FF5F56"
          }
         
    ],
    "keybindings":
    [
        { "command": {"action": "copy", "singleLine": false }, "keys": "ctrl+c" },
        { "command": "paste", "keys": "ctrl+v" },
        { "command": "find", "keys": "ctrl+shift+f" },
        { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" }
    ]
}

```

## oh-my-posh3

### install

```powershell
Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease

Get-PoshThemes

oh-my-posh --print-shell

$PROFILE

Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)/themes/jandedobbeleer.omp.json")

. $profile
```


### myself.omp.json
```json
{
    "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh3/main/themes/schema.json",
    "blocks": [
      {
        "type": "prompt",
        "alignment": "left",
        "segments": [
        // {
        //   "type": "text",
        //   "style": "plain",
        //   "foreground": "#ffffff",
        //   "properties": {
        //     "prefix": "",
        //     "text": "<#C591E8>\u276F</><#69FF94>\u276F</>"
        //   }
        // },
        {
          "type": "os",
          "style": "powerline",
          "powerline_symbol": "\uE0B0",
          "foreground": "#ffffff",
          "background": "#f35325",
          "properties": {
            "alpine": "\uf300",
            "arch": "\uf303",
            "centos": "\uf304",
            "debian": "\uf306",
            "elementary": "\uf309",
            "fedora": "\uf30a",
            "gentoo": "\uf30d",
            "linux": "\ue712",
            "macos": "\ue711",
            "manjaro": "\uf312",
            "mint": "\uf30f",
            "opensuse": "\uf314",
            "raspbian": "\uf315",
            "ubuntu": "\uf31c",
            "wsl": "\ue712",
            "wsl_separator": " on ",
            "windows": "\ue70f"
          }
        },
          {
            "type": "time",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#5a4cab",
            "background": "#ffba08",
            "properties": {
              "time_format": "15:04:05",
              "postfix": " \uF017 "
            }
          },
          {
            "type": "path",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#ffffff",
            "background": "#FF479C",
            "properties": {
              "prefix": " \uE5FF ",
              "home_icon": "\uF7DB",
              "folder_icon": "\uF115",
              "folder_separator_icon": " \uE0B0 ",
              "style": "agnoster"
            }
          },
          {
            "type": "git",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#193549",
            "background": "#fffb38",
            "properties": {
              "display_stash_count": true,
              "display_upstream_icon": true
            }
          },
          {
            "type": "battery",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#193549",
            "background": "#F36943",
            "properties": {
              "battery_icon": "",
              "charged_icon": "\uE22F ",
              "charging_icon": "\uE234 ",
              "discharging_icon": "\uE231 ",
              "color_background": true,
              "charged_color": "#4caf50",
              "charging_color": "#FF479C",
              "discharging_color": "#ff5722",
              "postfix": "\uF295 ",
              "display_charging": true
            }
          },
          {
            "type": "node",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#ffffff",
            "background": "#6CA35E",
            "properties": {
              "prefix": " \uE718 "
            }
          },
          {
            "type": "shell",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#ffffff",
            "background": "#0077c2",
            "properties": {
              "prefix": " \uFCB5 "
            }
          },
          {
            "type": "root",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#193549",
            "background": "#ffff66"
          },
          {
            "type": "exit",
            "style": "powerline",
            "powerline_symbol": "\uE0B0",
            "foreground": "#ffffff",
            "background": "#ff8080"
          }
        ]
      }
    ],
    "final_space": true
  }
  
```

### powershell_profile
```ps1

# initial oh-my-posh themes
   oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\negligible.omp.json" | Invoke-Expression
 #  oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\di4am0nd.omp.json" | Invoke-Expression
 #  oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\peru.omp.json" | Invoke-Expression
 # initial scoop auto complete
 Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
 
 # initial terminal icons
 Import-Module Terminal-Icons
 
 # set-alias
 Set-Alias ll ls
 
 Set-Alias sco scoop
 
 Set-Alias c cls
 
 Set-Alias k kate
 
 Set-Alias t trash
 
#  Set-Alias rm trash
 
 #alias function
 function pscoop {start -FilePath 'F:\OS Scoop'}

 function otmp {start -FilePath 'C:\Users\Canary\AppData\Local'}

 # extras
 Enable-PoshTooltips
 Enable-PoshTransientPrompt
```
