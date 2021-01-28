#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.PromptBackgroundColor
    $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    #check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    $user = $sl.CurrentUser
    $computer = [System.Environment]::MachineName
    $path = Get-FullPath -dir $pwd
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object "$user@$computer " -ForegroundColor $sl.Colors.SessionInfoForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }
    else {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }

    # Writes the drive portion
    $prompt += Write-Prompt -Object "$path " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $lastColor = $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object $($sl.PromptSymbols.SegmentForwardSymbol) -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
    }

    # Writes the postfix to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor

    $timeStamp = Get-Date -UFormat %R
    $timestamp = "[$timeStamp]"

    $prompt += Set-CursorForRightBlockWrite -textLength ($timestamp.Length + 1)
    $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.PromptForegroundColor

    $prompt += Set-Newline

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor $sl.Colors.PromptBackgroundColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.StartSymbol = ''
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x276F)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptSymbolColor = [ConsoleColor]::White
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.GitForegroundColor = [ConsoleColor]::Black
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White


######################################################################################
$sl.PromptSymbols.PromptIndicator            = '%'
If (Test-Administrator) {
    $sl.PromptSymbols.PromptIndicator        = '$'
}
$sl.GitSymbols.BranchSymbol                  = ''
$sl.GitSymbols.BranchUntrackedSymbol         = 'x'
$sl.GitSymbols.BranchIdenticalStatusToSymbol = 'o'
$sl.PromptSymbols.FailedCommandSymbol        = '?'

# === for non-powerline fonts : yahei ===============================
$sl.PromptSymbols.PromptIndicator            = '>'
If (Test-Administrator) {
    $sl.PromptSymbols.PromptIndicator        = [char]::ConvertFromUtf32(0x00BB)  # 0x00BB, Right-Pointing Double Angle Quotation Mark, 双大于号
}
$sl.GitSymbols.BranchSymbol                  = ''
$sl.GitSymbols.BranchUntrackedSymbol         = [char]::ConvertFromUtf32(0x2260)  # 0x2260, Not Equal To， 不等号（两条横线一条斜线）
$sl.GitSymbols.BranchIdenticalStatusToSymbol = [char]::ConvertFromUtf32(0x2261)  # 0x2261, Identical To， 等同于（三条横线）
$sl.PromptSymbols.FailedCommandSymbol        = '?'

# === for non-powerline fonts : jetbrains ===============================
$sl.PromptSymbols.PromptIndicator            = '>'
If (Test-Administrator) {
    $sl.PromptSymbols.PromptIndicator        = [char]::ConvertFromUtf32(0x27E9)  # 0x27E9, Mathematical Right Angle Bracket，数学直角右括号
}
$sl.GitSymbols.BranchSymbol                  = [char]::ConvertFromUtf32(0xE0A0)  # 0xE0A0, Version Control Branch, 版本控制符号
$sl.GitSymbols.BranchUntrackedSymbol         = [char]::ConvertFromUtf32(0x2260)  # 0x2260, Not Equal To， 不等号（两条横线一条斜线）
$sl.GitSymbols.BranchIdenticalStatusToSymbol = [char]::ConvertFromUtf32(0x2261)  # 0x2261, Identical To， 等同于（三条横线）
$sl.PromptSymbols.FailedCommandSymbol        = '?'

# === for light theme ======================================================
# concfg import google-light
$sl.Colors.PromptForegroundColor             = [ConsoleColor]::Yellow
$sl.Colors.PromptHighlightColor              = [ConsoleColor]::Cyan
$sl.Colors.PromptSymbolColor                 = [ConsoleColor]::DarkGray
$sl.Colors.GitDefaultColor                   = [ConsoleColor]::Red
$sl.Colors.GitForegroundColor                = [ConsoleColor]::Magenta
$sl.Colors.CommandFailedIconForegroundColor  = [ConsoleColor]::DarkGray

# === for dark theme ======================================================= 
# concfg import vs-code-dark-plus
$sl.Colors.PromptHighlightColor              = [ConsoleColor]::DarkBlue
$sl.Colors.PromptForegroundColor             = [ConsoleColor]::Blue
$sl.Colors.PromptSymbolColor                 = [ConsoleColor]::Magenta
$sl.Colors.GitDefaultColor                   = [ConsoleColor]::Green
$sl.Colors.GitForegroundColor                = [ConsoleColor]::DarkGreen
$sl.Colors.CommandFailedIconForegroundColor  = [ConsoleColor]::DarkRed