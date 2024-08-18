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

function Set-Environment([String] $variable, [String] $value) {
  Set-ItemProperty "HKCU:\Environment" $variable $value
  Invoke-Expression "`$env:${variable} = `"$value`""
}


function AppendEnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function AppendEnvPathIfExists([String]$path) { if (Test-Path $path) { AppendEnvPath $path } }

