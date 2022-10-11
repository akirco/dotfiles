
 # initial oh-my-posh themes
 oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh)\themes\negligible.omp.json" | Invoke-Expression
 # initial scoop auto complete
 Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
 
 # scoop search 
 # Invoke-Expression (&scoop-search --hook)
 
 # initial terminal icons
 # Import-Module Terminal-Icons
 
 Set-PSReadlineKeyHandler -Key DownArrow -ScriptBlock { Invoke-GuiCompletion }
 
 Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
 
 Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
 
 #Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
 
 Set-PSReadlineOption -PredictionSource History
 
 Set-PSReadlineOption -ShowToolTip
 
 # ls
 Set-Alias ll ls
 
 # scoop
 Set-Alias brew scoop
 
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
 
 # 终端的系统监视器
 Set-Alias n ntop  
 
 # 重命名
 Set-Alias f2 rnr
 
 # 二维码发送文件 
 Set-Alias qr qrcp
 
 #alias function
 function pscoop {start -FilePath 'F:\OS Scoop'}

 function otmp {start -FilePath 'C:\Users\Canary\AppData\Local'}

 # extras
 Enable-PoshTooltips
 Enable-PoshTransientPrompt
 
