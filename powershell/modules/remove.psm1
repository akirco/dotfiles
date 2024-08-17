function ParallelDelete {
    param(
        [Parameter(Valuefrompipeline = $true, Mandatory = $true, Position = 0)] [array]$filelist,
        [Parameter(Valuefrompipeline = $true, Mandatory = $true, Position = 1)] [int]$number
    )
    0..($filelist.count - 1) | Where-Object { $_ % 16 -eq $number } | ForEach-Object { Remove-Item -Path $filelist[$_] }
}

function FastDelete {
    Param(
        [Parameter(Valuefrompipeline = $True, Mandatory = $True)] [String]$Directory0
    )
    $Directory = $Directory0
    $subDirectories = Get-Childitem -Path $Directory -Directory -Force -Depth 0
    $files = Get-Childitem -Path $Directory -File -Force
    While ($subDirectories.Count -ne 0) {
        $Directory = $subDirectories[0].FullName
        $subDirectories = Get-Childitem -Path $Directory -Directory -Force -Depth 0
        $files += Get-Childitem -Path $Directory -File -Force
    }

    if ($files.Count -ne 0) {
        if ($files.Count -ge 128) {
            [array]$filelist = $files.Fullname
            0..15 | foreach-object { Invoke-Command -ScriptBlock { ParallelDelete $filelist $_ } }
        }
        else {
            $files.Fullname | ForEach-Object { Remove-Item -Path $_ }
        }
    }

    $Directory1 = $Directory
    $Directory = $Directory | Split-Path -Parent
    Remove-Item -Path $Directory1 -Force -ErrorAction Stop

    if ((Get-Childitem -Path $Directory0 -Depth 0 -Force).Count -ne 0) {
        FastDelete $Directory
    }
    else {
        Remove-Item -Path $Directory0 -ErrorAction SilentlyContinue
    }
}

function rma($item) {
    $isFile = Test-Path -Path $item -PathType Leaf
    $progress = 0
    $spinnerChars = "-\|/"
    $spinnerIndex = 0
    $spinnerPosition = [Console]::CursorLeft
    if ($isFile) {
        $size = (Get-Item -Path $item).Length
        while ($progress -le $size) {
            $spinnerChar = $spinnerChars[$spinnerIndex]
            [Console]::SetCursorPosition($spinnerPosition, [Console]::CursorTop)
            Write-Host "Removing... $spinnerChar" -NoNewline -ForegroundColor DarkMagenta
            $spinnerIndex = ($spinnerIndex + 1) % $spinnerChars.Length
            $progress += $size / 3
            Start-Sleep -Milliseconds 100
        }
        Remove-Item -Path $item -Force -Recurse
        $progress = 0
    }
    else {
        $files = Get-ChildItem -Path $item -Recurse -File
        $size = ($files | Measure-Object -Property Length -Sum).Sum
        while ($progress -le $size) {
            $spinnerChar = $spinnerChars[$spinnerIndex]
            [Console]::SetCursorPosition($spinnerPosition, [Console]::CursorTop)
            Write-Host "Removing... $spinnerChar" -NoNewline -ForegroundColor DarkMagenta
            $spinnerIndex = ($spinnerIndex + 1) % $spinnerChars.Length
            $progress += $size / 3
            Start-Sleep -Milliseconds 100
        }
        FastDelete $item
        $progress = 0
    }
}