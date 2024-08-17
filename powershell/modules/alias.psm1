# alias
Set-Alias ll lsd.exe
Set-Alias sco scoop
Set-Alias c cls
Set-Alias t trash
Set-Alias mpx mpxplay
Set-Alias vm nvim
Set-Alias lg lazygit
Set-Alias mon monolith
Set-Alias n ntop
Set-Alias f2 rnr
Set-Alias qr qrcp
Set-Alias mpv mpvnet
Set-Alias mf musicfox
Set-Alias ct ChatGpt
Set-Alias gt GetTips

# --------------------------------- functions -------------------------------- #
${function:~} = { Set-Location ~ }
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:pic} = { Set-Location ~\Pictures }
${function:vod} = { Set-Location ~\Videos }
${function:song} = { Set-Location ~\Music }
${function:pros} = { Set-Location D:\projects }
# ---------------------------------- rm -rf ---------------------------------- #

if (Test-Path Alias:rm) { Remove-Item Alias:rm }
function rm {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [switch]$rf,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Path
  )
  Process {
    Remove-Item -Path $Path -Recurse:$rf -Force:$rf
  }
}

