
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
# 待更新
```
