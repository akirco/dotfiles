#requires -Version 2 -Modules posh-git

function Get-HistoryId
{
    $id = 1
    $item = (Get-History -Count 1)
    if ($item)
    {
        $id = $item.Id + 1
    }

    return $id
}

function Write-StatusAsync
{
    param
    (
        $LastColor
    )

    Set-StrictMode -Version 2
    $ErrorActionPreference = "Stop"

    $position = $Host.UI.RawUI.CursorPosition

    # Runspaces need to be disposed, so keep track of them
    if (-not (Test-Path Variable:GitStatusRunspaces))
    {
        $global:GitStatusRunspaces = [Collections.ArrayList]::new()
    }
    foreach ($gsr in $global:GitStatusRunspaces.ToArray())
    {
        if ($gsr.AsyncHandle.IsCompleted)
        {
            $gsr.Powershell.EndInvoke($gsr.AsyncHandle)
            $gsr.Powershell.Dispose()
            $gsr.Runspace.Dispose()
            $global:GitStatusRunspaces.Remove($gsr)
        }
        # TODO: Should we cancel running jobs, since we're about to start a new one?
    }

    $runspace = [RunspaceFactory]::CreateRunspace($Host)
    $powershell = [Powershell]::Create()
    $powershell.Runspace = $runspace
    $runspace.Open()
    [void]$powershell.AddScript(
    {
        param
        (
            $WorkingDir,
            $Position,
            $ThemeSettings,
            $LastColor
        )

        Set-StrictMode -Version 2
        $ErrorActionPreference = "Stop"

        Set-Location $WorkingDir

        $status = Get-VCSStatus

        if ($status)
        {
            $themeInfo = Get-VcsInfo -status ($status)

            $buffer = $Host.UI.RawUI.NewBufferCellArray($ThemeSettings.PromptSymbols.SegmentForwardSymbol, $LastColor, $themeInfo.BackgroundColor)
            $buffer += $Host.UI.RawUI.NewBufferCellArray(" $($themeInfo.VcInfo) ", $ThemeSettings.Colors.GitForegroundColor, $themeInfo.BackgroundColor)

            $buffer += $Host.UI.RawUI.NewBufferCellArray($ThemeSettings.PromptSymbols.SegmentForwardSymbol, $themeInfo.BackgroundColor, $ThemeSettings.Colors.PromptBackgroundColor)

            # Appending to buffer makes a flat object array; we need to turn it back into a 2-dimensional one
            $bufferCells2d = [Management.Automation.Host.BufferCell[,]]::new(1, $buffer.Length)
            for ($i = 0; $i -lt $buffer.Length; $i++)
            {
              $bufferCells2d[0,$i] = $buffer[$i] 
            }

            $host.UI.RawUI.SetBufferContents($Position, $bufferCells2d)
        }
    }).AddParameters(@{ Position = $position; ThemeSettings = $ThemeSettings; WorkingDir = (Get-Location); LastColor = $LastColor })

    [void]$global:GitStatusRunspaces.Add((New-Object -TypeName PSObject -Property @{ Powershell = $powershell; AsyncHandle = $powershell.BeginInvoke(); Runspace = $runspace }))
}

function Write-Theme
{
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $ThemeSettings.Colors.PromptBackgroundColor

    Write-Prompt -Object $ThemeSettings.PromptSymbols.StartSymbol -ForegroundColor $ThemeSettings.Colors.SessionInfoForegroundColor -BackgroundColor $ThemeSettings.Colors.SessionInfoBackgroundColor

    #check the last command state and indicate if failed
    If ($lastCommandFailed)
    {
        Write-Prompt -Object "$($ThemeSettings.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $ThemeSettings.Colors.CommandFailedIconForegroundColor -BackgroundColor $ThemeSettings.Colors.SessionInfoBackgroundColor
    }

    #check for elevated prompt
    If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
    {
        Write-Prompt -Object "$($ThemeSettings.PromptSymbols.ElevatedSymbol) " -ForegroundColor $ThemeSettings.Colors.AdminIconForegroundColor -BackgroundColor $ThemeSettings.Colors.SessionInfoBackgroundColor
    }

    # Writes the time portion
    $time = ([DateTime]::Now.ToString("h:mm:ss") + " " + [char]::ConvertFromUtf32(0x1F553))
    Write-Prompt -Object "$time " -ForegroundColor $ThemeSettings.Colors.SessionInfoForegroundColor -BackgroundColor $ThemeSettings.Colors.SessionInfoBackgroundColor
    $lastColor = $ThemeSettings.Colors.SessionInfoBackgroundColor

    # Writes the history portion
    Write-Prompt -Object $ThemeSettings.PromptSymbols.SegmentForwardSymbol -ForegroundColor "$lastColor" -BackgroundColor $ThemeSettings.Colors.HistoryBackgroundColor
    Write-Prompt -Object " $(Get-HistoryId) " -ForegroundColor $ThemeSettings.colors.HistoryForegroundColor -BackgroundColor $ThemeSettings.Colors.HistoryBackgroundColor
    $lastColor = $ThemeSettings.Colors.HistoryBackgroundColor

    # Writes the drive portion
    Write-Prompt -Object $ThemeSettings.PromptSymbols.SegmentForwardSymbol -ForegroundColor "$lastColor" -BackgroundColor $ThemeSettings.Colors.DriveBackgroundColor
    Write-Prompt -Object " $(Get-FullPath -dir $pwd) " -ForegroundColor $ThemeSettings.Colors.DriveForegroundColor -BackgroundColor $ThemeSettings.Colors.DriveBackgroundColor
    $lastColor = $ThemeSettings.Colors.DriveBackgroundColor

    if ($with)
    {
        Write-Prompt -Object $ThemeSettings.PromptSymbols.SegmentForwardSymbol -ForegroundColor "$lastColor" -BackgroundColor $ThemeSettings.Colors.WithBackgroundColor
        Write-Prompt -Object " $($with.ToUpper()) " -BackgroundColor $ThemeSettings.Colors.WithBackgroundColor -ForegroundColor $ThemeSettings.Colors.WithForegroundColor
        $lastColor = $ThemeSettings.Colors.WithBackgroundColor
    }

    Write-StatusAsync -LastColor $lastColor

    # Writes the postfix to the prompt
    Write-Prompt -Object $ThemeSettings.PromptSymbols.SegmentForwardSymbol -ForegroundColor "$lastColor" -BackgroundColor $ThemeSettings.Colors.PromptBackgroundColor #-ForegroundColor $lastColor
    Write-Host ''
    Write-Prompt -Object $ThemeSettings.PromptSymbols.PromptIndicator -ForegroundColor $ThemeSettings.Colors.PromptSymbolColor
}

$global:ThemeSettings.PromptSymbols.TruncatedFolderSymbol = '...'

$ThemeSettings.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$ThemeSettings.Colors.HistoryForegroundColor = [ConsoleColor]::White
$ThemeSettings.Colors.HistoryBackgroundColor = [ConsoleColor]::Green
$ThemeSettings.Colors.DriveForegroundColor = [ConsoleColor]::White
$ThemeSettings.Colors.DriveBackgroundColor = [ConsoleColor]::DarkGray
$ThemeSettings.Colors.PromptForegroundColor = [ConsoleColor]::White
$ThemeSettings.Colors.PromptBackgroundColor = [ConsoleColor]::Black
$ThemeSettings.Colors.PromptSymbolColor = [ConsoleColor]::White
$ThemeSettings.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$ThemeSettings.Colors.GitForegroundColor = [ConsoleColor]::Black
$ThemeSettings.Colors.WithForegroundColor = [ConsoleColor]::White
$ThemeSettings.Colors.WithBackgroundColor = [ConsoleColor]::DarkRed
