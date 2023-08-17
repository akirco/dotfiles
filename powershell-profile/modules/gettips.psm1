function GetTips {

    $tips = @(
        [pscustomobject]@{
            Command     = 'hosts'
            Parameter   = "up/cat"
            Description = 'cat hosts or update github dns'
  
        },
        [pscustomobject]@{
            Command     = 'z'
            Parameter   = "dir"
            Description = 'zlocation'
  
        },
        [pscustomobject]@{
            Command     = 'scoop'
            Parameter   = "dir:open appdir with fileExplorer. add:add remote app"
            Description = 'scoop extendsions'
  
        },
        [pscustomobject]@{
            Command     = 'ct/ChatGpt'
            Description = 'the terminal chabot'
  
        },
        [pscustomobject]@{
            Command     = 'gt/gettips'
            Description = 'get all commands tips'
  
        },
        [pscustomobject]@{
            Command     = 'pyc'
            Parameter   = "arg1:envName,arg2:python version"
            Description = 'conad create env'
  
        },
        [pscustomobject]@{
            Command     = 'pyinit'
            Description = 'active python env'
  
        },
        [pscustomobject]@{
            Command     = 'gia'
            Description = 'git add .'
  
        },
        [pscustomobject]@{
            Command     = 'gim'
            Parameter   = "arg: commit message"
            Description = 'git commit -m $arg'
        },
        [pscustomobject]@{
            Command     = 'glne'
            Parameter   = "arg: git repo url"
            Description = 'git clone $arg'
        },
        [pscustomobject]@{
            Command     = 'gish'
            Parameter   = "arg: remote branch name"
            Description = 'git push origin $arg'
        },
        [pscustomobject]@{
            Command     = 'rma'
            Parameter   = "arg: remote branch name"
            Description = 'remove item force & recurse'
        },
        [pscustomobject]@{
            Command     = 'crb'
            Description = 'empty the Recycle Bin'
        },
        [pscustomobject]@{
            Command     = 'gca'
            Parameter   = "arg: command full name"
            Description = 'get command alias'
        },
        [pscustomobject]@{
            Command     = 'nwr'
            Description = 'netsh winsock reset'
        },
        [pscustomobject]@{
            Command     = 'vpro'
            Description = 'open $PROFILE with nvim'
        },
        [pscustomobject]@{
            Command     = 'cpro'
            Description = 'open $PROFILE with vscode'
        },
        [pscustomobject]@{
            Command     = 'rpro'
            Description = 'refresh $PROFILE'
        },
        [pscustomobject]@{
            Command     = 'lspro'
            Description = 'list all $PROFILE'
        },
        [pscustomobject]@{
            Command     = 'lsd'
            Parameter   = "arg: the parent path"
            Description = 'list all items of startwith dot'
        },
        [pscustomobject]@{
            Command     = 'lsf'
            Parameter   = "arg: the ext name"
            Description = 'list all items of endwith $arg ext'
        },
        [pscustomobject]@{
            Command     = 'esd'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'Set-Location with every-thing cli & Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'esf'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'open file with every-thing cli & Invoke-Fzf & neovim'
        },
        [pscustomobject]@{
            Command     = 'lzd'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'Set-Location with Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'lfzd'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'open dir with lf & Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'vmf'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'open file with neovim & Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'coded'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'open dir with vscode in new window & Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'codef'
            Parameter   = "optionsArg: the parentPath,default:pwd"
            Description = 'open file with vscode in current window & Invoke-Fzf'
        },
        [pscustomobject]@{
            Command     = 'vmfdf'
            Parameter   = "arg: the regxExp example:*.md"
            Description = 'open file with neovim  & Invoke-Fzf & fd'
        },
        [pscustomobject]@{
            Command     = 'tdl'
            Parameter   = "arg: the telegraph url or telegram export json file"
            Description = 'download telegraph images'
        },
        [pscustomobject]@{
            Map         = 'alt+s'
            Description = 'list & open file with default app'
        },
        [pscustomobject]@{
            Map         = 'alt+h'
            Description = 'list all history with psfzf'
        },
        [pscustomobject]@{
            Map         = 'F2'
            Description = 'switch the Set-PSReadlineOption predictionViewStyle'
        }
    )
    Write-Output $tips | Format-Table
}