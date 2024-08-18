
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

function upload {
  param ([string]$file)
  $siteAddress = "https://file.io/?expires=1w"
  $webClient = New-Object System.Net.WebClient
  $response
  try {
    $response = $webClient.UploadFile($siteAddress, $file)
  }
  catch {
    Write-Host $_
  }
  [System.Text.Encoding]::ASCII.GetString($response) | Format-Table
}

function Uninstall-AppPackage {
  [CmdletBinding()]
  param (
    [Parameter( Position = 0, Mandatory = $TRUE)]
    [String]
    $Name
  )

  try {
    Get-AppxPackage $Name -AllUsers | Remove-AppxPackage;
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -like $Name | Remove-AppxProvisionedPackage -Online;
  }
  catch {

  }
}

function touch($file) { "" | Out-File $file -Encoding  utf8 }



function rpwsh {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "pwsh";
  $newProcess.Arguments = "-nologo";
  [System.Diagnostics.Process]::Start($newProcess);
  exit
}


function CleanDisks {
  Start-Process "$(Join-Path $env:WinDir 'system32\cleanmgr.exe')" -ArgumentList "/sagerun:6174" -Verb "runAs"
}
function RefreshEnvironment {
  $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
  'HKCU:\Environment'

  $locations | ForEach-Object {
    $k = Get-Item $_
    $k.GetValueNames() | ForEach-Object {
      $name = $_
      $value = $k.GetValue($_)
      Set-Item -Path Env:\$name -Value $value
    }
  }

  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}
