#requires -Version 2 -Modules posh-git
#Author: Hans Koch
#Based on Agnoster Theme from https://github.com/JanDeDobbeleer/oh-my-posh

function Write-Theme {

  param(
    [bool]
    $lastCommandFailed,
    [string]
    $with
  )    

  # Info Icons ---------------------------------------------------------------

  #check the last command state and indicate if failed
  $symbolColor = $sl.Colors.StartSymbolColor

  
  #check for elevated prompt
  If (Test-Administrator) {
    $symbolColor = $sl.Colors.AdminIconForegroundColor
  }

  #something went wrong
  If ($lastCommandFailed -and $slSettings.ShowErrorColorInSymbol) {
    $symbolColor = $sl.Colors.CommandFailedIconForegroundColor
  }

  $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $symbolColor
  
  # Computername -------------------------------------------------------------

  $user = [System.Environment]::UserName
  
  if (Test-NotDefaultUser($user)) {
    $prompt += Write-Prompt -Object " $user " -ForegroundColor $sl.Colors.UserColor
  }

  if (Test-VirtualEnv) {
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor
  }
  else {
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) "  -ForegroundColor $sl.Colors.SegmentSymbolColor
  }

  # Path ---------------------------------------------------------------------

  # Writes the drive portion
  $prompt += Write-Prompt -Object (Get-FullPath -dir $pwd) -ForegroundColor $sl.Colors.PromptBackgroundColor

  # Git ----------------------------------------------------------------------
  
  $status = Get-VCSStatus
  if ($status) {
    $prompt += Write-Prompt -Object " $($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SegmentSymbolColor
    $themeInfo = Get-VcsInfo -status ($status)
    $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -ForegroundColor $sl.Colors.VCSColor
  }

  if ($with) {
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol  -ForegroundColor $sl.Colors.SegmentSymbolColor
    $prompt += Write-Prompt -Object " $($with.ToUpper()) " -ForegroundColor $sl.Colors.VCSColor
  }

  # Input Line ---------------------------------------------------------------

  Set-NewLine
  $prompt += Write-Prompt -Object $sl.PromptSymbols.NewLineSymbol -ForegroundColor $sl.Colors.FontColor
  $prompt += '  ' 
  $prompt
}

#local settings
$sl = $global:ThemeSettings

# Symbols
$sl.PromptSymbols.StartSymbol = [char]::ConvertFromUtf32(0x3BB) # λ
$sl.PromptSymbols.NewLineSymbol = [char]::ConvertFromUtf32(0x2B91) # ⮑
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0x276F) # ❯

# Colors
$sl.Colors.StartSymbolColor = [ConsoleColor]::Green
$sl.Colors.SegmentSymbolColor = [ConsoleColor]::Green
$sl.Colors.Background = [ConsoleColor]::Black
$sl.Colors.FontColor = [ConsoleColor]::White
$sl.Colors.PathColor = [ConsoleColor]::Cyan
$sl.Colors.VCSColor = [ConsoleColor]::Yellow
$sl.Colors.UserColor = $sl.Colors.FontColor
