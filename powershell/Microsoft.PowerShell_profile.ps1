
# global path
# git clone https://github.com/akirco/dotfiles "$env:USERPROFILE\\documents\\dotfiles"
$ModulePath = "$env:USERPROFILE\\.config\\dotfiles\\powershell\\modules"
$OMPThemesPath = "$ModulePath\\..\\theme\\omp.json"


# Enable-ExperimentalFeature PSSubsystem
try {
    Get-PSSubsystem -Kind CommandPredictor | Out-Null
}
catch {
    Enable-ExperimentalFeature -Name PSSubsystemPluginModel -WarningAction SilentlyContinue
}
# initial oh-my-posh themes
oh-my-posh --init --shell pwsh --config $OMPThemesPath | Invoke-Expression

Import-Module Terminal-Icons

Import-Module PSWindowsUpdate

Import-Module ZLocation

Import-Module CompletionPredictor

Import-Module DirectoryPredictor

Import-Module PSEverything

Import-Module "$ModulePath\\gettips.psm1"

Import-Module "$ModulePath\\alias.psm1"

Import-Module "$ModulePath\\pyc.psm1"

Import-Module "$ModulePath\\pyinit.psm1"

Import-Module "$ModulePath\\pstools.psm1"

Import-Module "$ModulePath\\git.psm1"

Import-Module "$ModulePath\\everything.psm1"

Import-Module "$ModulePath\\telegraph.psm1"

Import-Module "$ModulePath\\scoop.psm1"

Import-Module "$ModulePath\\r3skin.psm1"

Import-Module "$ModulePath\\remove.psm1"

Import-Module "$ModulePath\\sd.psm1"

Import-Module "$ModulePath\\extras.psm1"

Import-Module "$ModulePath\\winget.psm1"

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'alt+s' -PSReadlineChordReverseHistory 'alt+h'

# pass your override to PSFzf:
$commandOverride = [ScriptBlock] { param($Location) z $Location }
Set-PsFzfOption -AltCCommand $commandOverride

Set-PsFzfOption -EnableAliasFuzzyEdit
Set-PsFzfOption -EnableAliasFuzzyFasd
Set-PsFzfOption -EnableAliasFuzzyHistory
Set-PsFzfOption -EnableAliasFuzzyKillProcess
Set-PsFzfOption -EnableAliasFuzzySetLocation
Set-PsFzfOption -EnableAliasFuzzyScoop
Set-PsFzfOption -EnableAliasFuzzySetEverything
Set-PsFzfOption -EnableAliasFuzzyZLocation
Set-PsFzfOption -EnableAliasFuzzyGitStatus
Set-PsFzfOption -EnableFd

Enable-PoshTooltips
Enable-PoshTransientPrompt
Set-PSReadlineOption -ShowToolTip -PredictionViewStyle ListView -HistoryNoDuplicates -WarningAction SilentlyContinue
Set-PSReadLineOption -PredictionSource HistoryAndPlugin -HistoryNoDuplicates -Colors @{
    Command            = '#21acff'
    Number             = '#c678dd'
    Member             = '#e43535'
    Operator           = '#f6ad55'
    Type               = '#6262ea'
    Variable           = '#21c68b'
    Parameter          = '#e9967a'
    ContinuationPrompt = '#ff8c00'
    Default            = '#12c768'
}
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }


function lzd {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Attributes Directory | Invoke-Fzf | Set-Location
}
function lfzd {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { lf $_ }
}
function vmf {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { nvim $_ }
}
function coded {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes Directory | Where-Object { $_.PSIsContainer } | Invoke-Fzf |  ForEach-Object { code $_ -n }
}
function codef {
    param (
        [Parameter(Mandatory = $false, Position = 0)][string]$parentPath
    )
    if (!$parentPath) {
        $parentPath = $PWD.Path
    }
    Get-ChildItem $parentPath -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ -r }
}
function vmfdf {
    param (
        [Parameter(Mandatory = $true, Position = 0)][string]$regxExp
    )
    fd.exe --glob $regxExp | Invoke-Fzf | ForEach-Object { nvim $_ }
}
