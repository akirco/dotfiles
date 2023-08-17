function rma($item) { Remove-Item $item -Recurse -Force }

function crb { Clear-RecycleBin -Force }


# todo use psfzf 扩展 
# get-CmdletAlias
function gca ($cmdletname) {
    Get-Alias |
    Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
    Format-Table -Property Definition, Name -AutoSize
}

#! rest wsl winsock
function nwr { sudo netsh winsock reset }

#! powershell profile settings
function vpro { nvim $PROFILE.AllUsersCurrentHost }
function cpro { code $PROFILE.AllUsersCurrentHost }
function rpro { . $PROFILE.AllUsersCurrentHost }
function lspro { $PROFILE | Get-Member -Type NoteProperty }

#! ls tool
function lsd { Get-ChildItem -Filter .* -Path $args }
function lsf { Get-ChildItem -Recurse . -Include *.$args }