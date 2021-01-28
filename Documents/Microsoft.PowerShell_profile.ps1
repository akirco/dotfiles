Invoke-Expression (oh-my-posh --init --shell pwsh --config ~/Documents/Oh-my-posh3/poshthemes/myself.omp.json)
# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme Avit
Import-Module PackageManagement
Import-Module PowerShellGet
Import-Module PSReadline
Import-Module "$($(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName)\modules\scoop-completion"
