# git
function gia { git add . }
function gim {
    param ( 
        [Parameter(Mandatory = $false, Position = 0)][string]$message
    )
    git commit -m $message 
}
function gill { git pull }
function gish {
    param ( 
        [Parameter(Mandatory = $false, Position = 0)][string]$branchName
    )
    git push origin $branchName 
}
function glne { 
    param ( 
        [Parameter(Mandatory = $false, Position = 0)][string]$gitRepoUrl
    )
    git clone $gitRepoUrl 
}