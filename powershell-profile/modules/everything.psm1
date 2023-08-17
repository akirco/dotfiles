
# open file with every-thing cli & Invoke-Fzf & neovim
function esf {
    param ( 
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    es -parent "$parentPath" /a-d /on -sort-descending | Invoke-Fzf | ForEach-Object { nvim $_ }
}
  
# Set-Location with every-thing cli & Invoke-Fzf
function esd {
    param ( 
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    es /ad -parent $parentPath | Invoke-Fzf | Set-Location
}