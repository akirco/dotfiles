
# ------------------------------ globalVariable ------------------------------ #
$Global:DEVDRIVE = $null

$envDir = Join-Path $Global:DEVDRIVE "envs"
$pnpmDir = Join-Path $envDir  "pnpm"
$npmDir = Join-Path $envDir  "npm"
$pipDir = Join-Path $envDir  "pip"



$ScoopCommands = @(
  "scoop bucket add extras",
  "scoop install git 7zip innounp dark",
  "scoop alias add i 'scoop install $args[0]' 'install app'"
  "scoop alias add s 'scoop search $args[0]' search app",
  "scoop alias add ls 'scoop list' 'List installed apps'",
  "scoop alias add rm 'scoop uninstall $args[0]' 'uninstall app'",
  "scoop alias add up 'scoop update $args[0]' 'update app or itself'",
  "scoop alias add rma 'scoop cleanup *' 'remove old version'",
  "scoop alias add rmc 'scoop cache rm *' 'remove dowloaded file'"
  "Write-Host 'scoop setting done...' -ForegroundColor Green"
)

$WslCommands = @(
  "wsl --update",
  "wsl --set-default-version 2",
  "write-host 'installing archwsl' -ForegroundColor Green"
  "scoop install archwsl"
)

$extraCommands = @(
  "New-Item -Path $envDir -ItemType Directory -Force",
  "New-Item -Path $pnpmDir -ItemType Directory -Force",
  "New-Item -Path $npmDir -ItemType Directory -Force",
  "New-Item -Path $pipDir -ItemType Directory -Force",
  "git clone https://github.com/akirco/dotfiles.git $env:USERPROFILE\.config\dotfiles",
  "scoop import $env:USERPROFILE\.config\dotfiles\apps.json",
  "Write-Host 'installing dotfiles' -ForegroundColor Green",
  "lns -source $env:USERPROFILE\.gitconfig -target $env:USERPROFILE\.config\dotfiles\user-profile\.gitconfig",
  "lns -source $env:USERPROFILE\.npmrc -target $env:USERPROFILE\.config\dotfiles\user-profile\.npmrc"
  "lns -source $env:USERPROFILE\.condarc -target $env:USERPROFILE\.config\dotfiles\user-profile\.condarc",
  "lnj -source $env:USERPROFILE\pip -target $env:USERPROFILE\.config\dotfiles\user-profile\pip",
  "lnj -source $env:USERPROFILE\.cargo -target $env:USERPROFILE\.config\dotfiles\user-profile\.cargo",
  "lns -source $PROFILE.AllUsersCurrentHost -target $env:USERPROFILE\.config\dotfiles\powershell-profile\Microsoft.PowerShell_profile.ps1",
  "Get-Content $env:USERPROFILE\.config\dotfiles\nvm\settings.txt >> $(scoop prefix nvm)\settings.txt",
  "pip config set global.cache-dir $pipDir\global-caches"
  "pip config set user.cache-dir $pipDir\user-caches",
  "npm config set prefix=$npmDir\moudles",
  "npm config set cache=$npmDir\caches",
  "npm config set shell=where.exe pwsh.exe"
  "npm config set store-dir=$pnpmDir\.pnpm-store",
  "npm config set global-bin-dir=$pnpmDir\.pnpm-global\bin",
  "npm config set global-dir=$pnpmDir\.pnpm-global",
  "npm config set cache-dir=$pnpmDir\.pnpm-cache",
  "npm config set state-dir=$pnpmDir\.pnpm-state",
  "npm config set electron-cache-dir=$npmDir\electron-cache-dir",
  "npm config set node-gyp=$npmDir\moudles\node_modules\node-gyp\bin\node-gyp.js",
  "write-host 'settings completed...' -ForegroundColor Green"
)


# ----------------------------------- utils ---------------------------------- #

function Confirm-Action {
  param (
    [string]$Message = "Are you sure you want to proceed?",
    [string]$Default = "Yes"
  )

  $prompt = "$Message (Yes/No) [$Default]:"
  Write-Host -NoNewline $prompt -ForegroundColor Yellow
  $confirmation = Read-Host

  if ([string]::IsNullOrWhiteSpace($confirmation)) {
    $confirmation = $Default
  }
  switch ($confirmation.ToLower()) {
    "yes" {
      return $true
    }
    "no" {
      return $false
    }
    default {
      return  Confirm-Action -Message $Message -Default $Default
    }
  }
}


function Loading {
  param(
    [scriptblock]$function,
    [string]$Label
  )
  $job = Start-Job -ScriptBlock $function

  $symbols = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
  $i = 0

  while ($job.State -eq "Running") {
    $symbol = $symbols[$i]
    Write-Host -NoNewLine "`r$symbol $Label" -ForegroundColor Green
    Start-Sleep -Milliseconds 100
    $i++
    if ($i -eq $symbols.Count) {
      $i = 0
    }
    $output = Receive-Job -Job $job -Keep
    if ($output) {
      Write-Host -NoNewLine "`r$output"
    }
  }

  Write-Host -NoNewLine "`r"
  $finalOutput = Receive-Job -Job $job
  if ($finalOutput) {
    Write-Host $finalOutput
  }
  Remove-Job -Job $job
}


function LoadingAnimation {
  param (
    [int]$Delay = 100,
    [int]$Iterations = 10,
    [string]$Label = "Loading..."
  )

  $spinner = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")

  for ($i = 0; $i -lt $Iterations; $i++) {
    $currentChar = $spinner[$i % $spinner.Length]
    Write-Host -NoNewline "`r$currentChar $Label"  -ForegroundColor Red

    Start-Sleep -Milliseconds $Delay

    for ($j = 0; $j -lt $currentChar.Length; $j++) {
      Write-Host -NoNewline "`b"
    }
  }

  Write-Host "`r"
}


function ExecuteCommands {
  param (
    [string[]]$commands
  )

  foreach ($command in $commands) {
    Invoke-Expression $command
  }
}

function lns {
  param (
    [string]$source,
    [string]$target
  )
  New-Item -Path $source -ItemType SymbolicLink -Target $target -ErrorAction SilentlyContinue
}

function lnj {
  param (
    [string]$source,
    [string]$target
  )
  New-Item -Path $source -ItemType Junction -Target $target -ErrorAction SilentlyContinue
}


# -------------------------------- SYSTEMINFO -------------------------------- #
function Check_SystemInfo {

  $RAM = Get-WmiObject -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem"

  $totalRAM = [math]::Round($RAM.TotalVisibleMemorySize / 1MB, 2)
  $freeRAM = [math]::Round($RAM.FreePhysicalMemory / 1MB, 2)
  $usedRAM = [math]::Round(($RAM.TotalVisibleMemorySize - $RAM.FreePhysicalMemory) / 1MB, 2)

  # Operating System
  $OS = Get-WmiObject -class Win32_OperatingSystem

  # Convert WMI date format to a human-readable date
  $OS_InstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($OS.InstallDate)
  $OS_LastBootUpTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($OS.LastBootUpTime)

  $OS_Name = $OS.Caption
  $OS_Architecture = $OS.OSArchitecture
  $OS_SystemDrive = $OS.SystemDrive
  $OS_WindowsDirectory = $OS.WindowsDirectory
  $OS_BuildNumber = $OS.BuildNumber
  $OS_SerialNumber = $OS.SerialNumber
  $OS_Version = $OS.Version
  $OS_Manufacturer = $OS.Manufacturer

  # Computer System
  $CS = Get-WmiObject -class Win32_ComputerSystem

  $CS_Name = $CS.Name
  $CS_Owner = $CS.PrimaryOwnerName

  # CPU
  $CPU = Get-WmiObject -class Win32_Processor

  $CPU_Name = $CPU.Name
  $CPU_Manufacturer = $CPU.Manufacturer
  $CPU_MaxClockSpeed = $CPU.MaxClockSpeed / 1000
  $CPU_Used = (Get-WmiObject win32_processor).LoadPercentage
  $CPU_Free = 100 - $CPU_Used

  # Disk
  $Disk = Get-WmiObject -class Win32_LogicalDisk -Filter "DeviceID='C:'"
  $Disk_ID = $Disk.DeviceID
  $Disk_TotalSpace = [math]::Round($Disk.Size / 1GB, 2)
  $Disk_FreeSpace = [math]::Round($Disk.FreeSpace / 1GB, 2)
  $Disk_UsedSpace = [math]::Round(($Disk.Size - $Disk.FreeSpace) / 1GB, 2)

  # Create info object
  $infoprop = @{
    'RAM_total'           = $totalRAM;
    'RAM_free'            = $freeRAM;
    'RAM_used'            = $usedRAM;
    'OS_Name'             = $OS_Name;
    'OS_InstallDate'      = $OS_InstallDate;
    'OS_LastBootUpTime'   = $OS_LastBootUpTime;
    'OS_Architecture'     = $OS_Architecture;
    'OS_SystemDrive'      = $OS_SystemDrive;
    'OS_WindowsDirectory' = $OS_WindowsDirectory;
    'OS_BuildNumber'      = $OS_BuildNumber;
    'OS_SerialNumber'     = $OS_SerialNumber;
    'OS_Version'          = $OS_Version;
    'OS_Manufacturer'     = $OS_Manufacturer;
    'CS_Name'             = $CS_Name;
    'CS_Owner'            = $CS_Owner;
    'CPU_Name'            = $CPU_Name;
    'CPU_Manufacturer'    = $CPU_Manufacturer;
    'CPU_MaxClockSpeed'   = $CPU_MaxClockSpeed;
    'CPU_Used'            = $CPU_Used;
    'CPU_Free'            = $CPU_Free;
    'Disk_ID'             = $Disk_ID;
    'Disk_TotalSpace'     = $Disk_TotalSpace;
    'Disk_FreeSpace'      = $Disk_FreeSpace;
    'Disk_UsedSpace'      = $Disk_UsedSpace;
  }

  $info = New-Object -TypeName PSObject -Prop $infoprop
  # Output
  $info
}


# ---------------------------------- PARTITION --------------------------------- #

function Check_DiskVolumes {
  $partitions = Get-WmiObject -Class Win32_LogicalDisk
  $partitions | Select-Object -Property DeviceID, VolumeName, FileSystem, @{Name = "TotolSize(GB)"; Expression = { [math]::Round($_.Size / 1GB, 2) } }, @{Name = "FreeSpace(GB)"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } } | Format-Table -AutoSize
}



# ----------------------------------- VHDX ----------------------------------- #
function New_DevDrive {
  Write-Host "`nCreating new dev drive`n" -ForegroundColor Blue
  $vhdPath = Read-Host "Please input vhd path(e.g.'C:\devhome\dev.vhdx')"
  $size = Read-Host "Please input size in GB (e.g. 10GB)"
  $regex = "^[A-Z]:\\[^:*?<>|]+\\[^:*?<>|]+\.(vhdx)$"
  if (!($vhdPath -match $regex)) {
    Write-Host "The path is invalid." -ForegroundColor Red
    return
  }
  $res = Confirm-Action -Message "`r`n[$vhdPath]:[$size],Confirmed?" -Default "Yes"
  if ($res -eq $false) { return }
  try {
    New-VHD -Path $vhdPath -Dynamic -SizeBytes $size -ErrorAction Inquire

    $vhd = Get-VHD -Path $vhdPath -ErrorAction Stop

    $vhd | Select-Object -Property ComputerName, VhdType, VhdFormat, Path, @{Name = "TotolSize(GB)"; Expression = { [math]::Round($_.Size / 1GB, 2) } }, Number | Format-Table -AutoSize


    Mount-VHD -Path  $vhdPath


    $diskNumber = (Get-VHD -Path $vhdPath | Select-Object -Property Number).Number

    Write-Host "Disk number: $diskNumber" -ForegroundColor Blue

    Initialize-Disk -Number $diskNumber -PartitionStyle GPT -ErrorAction Stop

    New-Partition -DiskNumber $diskNumber -UseMaximumSize -AssignDriveLetter

    $driveLetter = (Get-Disk -Number $diskNumber | Get-Partition | Get-Volume | Select-Object -Property DriveLetter).DriveLetter

    Format-Volume -DriveLetter $driveLetter -FileSystem NTFS -NewFileSystemLabel "DevDrive" | Out-Null

    if ((Get-Volume -DriveLetter $driveLetter).OperationalStatus) {
      $Global:DEVDRIVE = $driveLetter
      Write-Host "New devdrive:$Global:DEVDRIVE created successfully`n`n" -ForegroundColor Blue
    }
  }
  catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Remove-DevDrive -vhdPath $vhdPath
  }
}

function Remove-DevDrive {
  try {
    $vhd = Get-VHD -Path $vhdPath -ErrorAction Stop
    $diskNumber = $vhd.DiskNumber

    $partitions = Get-Partition -DiskNumber $diskNumber -ErrorAction SilentlyContinue
    if ($partitions) {
      foreach ($partition in $partitions) {
        Remove-Partition -DiskNumber $diskNumber -PartitionNumber $partition.PartitionNumber
        Write-Host "Partition $($partition.PartitionNumber) removed successfully" -ForegroundColor Blue
      }
    }

    if ($vhd.Attached) {
      Dismount-VHD -Path $vhdPath -ErrorAction Stop
      Write-Host "VHD dismounted successfully" -ForegroundColor Blue
    }
    Remove-Item $vhdPath -Force -ErrorAction Stop
    Write-Host "VHD removed successfully" -ForegroundColor Blue
  }
  catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
  }
}

# ------------------------------------ WSL ----------------------------------- #
function Setup_WSL {

  $osVersion = [System.Environment]::OSVersion.Version

  $arch = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture

  $isSupported = $false
  if ($arch -eq "64-bit") {
    if ($osVersion.Major -eq 10 -and $osVersion.Minor -eq 0 -and $osVersion.Build -ge 18362) {
      $isSupported = $true
    }
  }
  elseif ($arch -eq "ARM64") {
    if ($osVersion.Major -eq 10 -and $osVersion.Minor -eq 0 -and $osVersion.Build -ge 19041) {
      $isSupported = $true
    }
  }
  else {
    Write-Host "Your system architecture ($arch) is not supported. WSL requires a 64-bit or ARM64 system."
    return
  }

  if (-not $isSupported) {
    Write-Host "Your system does not meet the minimum requirements for WSL."
    Write-Host "For x64 systems: Version 1903 or later, with Build 18362.1049 or later."
    Write-Host "For ARM64 systems: Version 2004 or later, with Build 19041 or later."
    return
  }

  try {
    $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    if ($wslFeature.State -ne "Enabled") {
      Write-Host "Microsoft-Windows-Subsystem-Linux is not enabled. Enabling..."
      Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
      Write-Host "WSL feature enabled successfully."
    }
    else {
      Write-Host "WSL is already enabled."
    }
  }
  catch {
    Write-Host "Failed to enable WSL feature. Please run the script as an administrator and try again."
    return
  }

  $vmFeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
  if ($vmFeature.State -ne "Enabled") {
    Write-Host "VirtualMachinePlatform is not enabled. Enabling..."
    try {
      Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
      Write-Host "VirtualMachinePlatform feature enabled successfully."
    }
    catch {
      Write-Host "Failed to enable VirtualMachinePlatform feature. Please ensure your system supports virtualization and try again."
      return
    }
  }
  else {
    Write-Host "VirtualMachinePlatform is already enabled."
  }

  try {
    ExecuteCommands -commands $WslCommands
  }
  catch {
    Write-Host "Failed to install WSL or set default version. Please check if WSL is already installed or if there are any errors."
  }
}

# ---------------------------------- NETWORK --------------------------------- #
function Check_Network {
  $networkStatus = Test-Connection -ComputerName github.com -Count 3 -Verbose
  $networkStatus | Format-Table -AutoSize
}

# ----------------------------------- scoop ---------------------------------- #


function install_scoop {
  Invoke-RestMethod get.scoop.sh -outfile "$env:USERPROFILE\Downloads\installer.ps1"
  if (Test-Path -Path "$env:USERPROFILE\Downloads\installer.ps1") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Write-Host -NoNewline "`nPlease input install dir:" -ForegroundColor Yellow
    $installPath = Read-Host
    $globalInstallPath = $installPath + "\global"

    @($installPath, $globalInstallPath) | Format-Table -AutoSize

    Write-Host "installing scoop..."

    Invoke-Expression "$env:USERPROFILE\Downloads\installer.ps1 -ScoopDir $installPath -ScoopGlobalDir $globalInstallPath -NoProxy"

    if ((Get-Command scoop).Name -eq "scoop.ps1") {
      Write-Host "scoop installed successfully" -ForegroundColor Green
      try {
        Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1

        ExecuteCommands -commands $ScoopCommands

      }
      catch {
        <#Do this if a terminating exception happens#>
      }
    }
  }
  else {
    Write-Host "scoop installer download failed, please check your network" -ForegroundColor Red
  }
}

# ------------------------------------ git ----------------------------------- #

function Setup_Git {
  Write-Host -NoNewline "Please input your git username:" -ForegroundColor DarkCyan
  $username = Read-Host
  Write-Host -NoNewline "Please input your git email:" -ForegroundColor DarkCyan
  $email = Read-Host
  $commands = @(
    "git config --global user.name $username",
    "git config --global user.email $email"
  )
  ExecuteCommands -commands $commands
}

# ------------------------------------ npm ----------------------------------- #
function Setup_Npm {

  if (!(Test-Path $Global:DEVDRIVE)) {
    $Global:DEVDRIVE = Read-Host -Prompt "Please input driveLetter"
  }
  $EnvsPath = $Global:DEVDRIVE + ":\envs"

  if (!(Test-Path $EnvsPath)) {
    New-Item -ItemType Directory -Path $EnvsPath
  }
  $npmPath = $EnvsPath + "\npm"
  $electronCachePath = $EnvsPath + "\electron"
  $pnpmPath = $EnvsPath + "\pnpm"
  $nodegypPath = $npmPath + "\modules\node_modules\node-gyp\bin\node-gyp.js"
  Write-Host "prefix=$npmPath\modules" >> "$env:USERPROFILE\.npmrc"
  Write-Host "cache=$npmPath\caches" >> "$env:USERPROFILE\.npmrc"
  Write-Host "store-dir=$pnpmPath\.pnpm-store" >> "$env:USERPROFILE\.npmrc"
  Write-Host "global-dir=$pnpmPath\.pnpm-global" >> "$env:USERPROFILE\.npmrc"
  Write-Host "global-bin-dir=$pnpmPath\.pnpm-global\bin" >> "$env:USERPROFILE\.npmrc"
  Write-Host "cache-dir=$pnpmPath\.pnpm-caches" >> "$env:USERPROFILE\.npmrc"
  Write-Host "state-dir=$pnpmPath\.pnpm-state" >> "$env:USERPROFILE\.npmrc"
  Write-Host "electron-cache-dir=$electronCachePath\caches" >> "$env:USERPROFILE\.npmrc"
  Write-Host "node-gyp=$nodegypPath" >> "$env:USERPROFILE\.npmrc"
}



# ----------------------------------- main ----------------------------------- #

Clear-Host

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin -eq $false) {
  Write-Host "Please run this script as an administrator" -ForegroundColor Red
  break;
}

LoadingAnimation -Delay 100 -Iterations 10 -Label "Checking system info..."
Check_SystemInfo



$res = Confirm-Action -Message "Do you want to create a new dev drive?" -Default "Yes"

if ($res) {
  LoadingAnimation -Delay 100 -Iterations 10 -Label "Checking disk volumes..."

  Check_DiskVolumes

  New_DevDrive

  LoadingAnimation -Delay 100 -Iterations 10 -Label "Checking network..."

  Check_Network

  LoadingAnimation -Delay 100 -Iterations 10 -Label "downloading scoop installer..."

  install_scoop

  Setup_WSL

  Setup_Git

  ExecuteCommands -commands $extraCommands

  Setup_Npm
}
else {
  Write-Host "`nSkipping dev drive creation`n" -ForegroundColor Blue

  LoadingAnimation -Delay 100 -Iterations 10 -Label "Checking network..."

  Check_Network

  LoadingAnimation -Delay 100 -Iterations 10 -Label "downloading scoop installer..."

  install_scoop

  Setup_WSL

  Setup_Git

  ExecuteCommands -commands $extraCommands

  Setup_Npm
}










