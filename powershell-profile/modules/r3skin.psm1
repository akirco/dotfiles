function r3skinInjector {
    $gameName = "英雄联盟"
    $uninstallKeys = Get-ChildItem -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall' | Get-ItemProperty
    $gameKey = $uninstallKeys | Where-Object { $_.DisplayName -like "*$gameName*" }
    $R3skinRelease = "https://api.github.com/repos/R3nzTheCodeGOD/R3nzSkin/releases/latest"
    if ($gameKey) {
        $installLocation = $gameKey.InstallSource
        Write-Host "Found <League of Legends> path: $installLocation" -BackgroundColor Yellow
        $gamePath = Join-Path $installLocation "Game"
        if ($gamePath) {
            $Response = Invoke-WebRequest -Uri $R3skinRelease -UseBasicParsing 
            $downloadUrl = (ConvertFrom-Json $Response).assets[0].browser_download_url
            Write-Host "downloading..." -ForegroundColor DarkGray
            $outputFile = $gamePath + "\" + "R3nzSkin.zip"
            $ExpandedPath = $gamePath + "\" + "R3nzSkin"
            $ExpandedFile = $gamePath + "\" + "R3nzSkin" + "\" + "R3nzSkin.dll"
            $InjectFile = $gamePath + "\" + "hid.dll"
            Invoke-WebRequest -Uri https://ghproxy.com/$downloadUrl -OutFile $outputFile
            if (Test-Path $outputFile) {
                Write-Host "downloaded..." -ForegroundColor DarkGray
                Write-Host "expand archive..." -ForegroundColor DarkGray
                Expand-Archive -Path $outputFile -DestinationPath $ExpandedPath -Force
                if (Test-Path $ExpandedFile) {
                    Move-Item $ExpandedFile -Destination $InjectFile -Force
                    Write-Host "Successfully injected" -ForegroundColor Cyan

                }
                else {
                    Write-Host "download error" -BackgroundColor Red
                }
            }
            else {
                Write-Host "download error" -BackgroundColor Red
            }
        }
    }
    else {
        Write-Host "not found lol path"
    }
    
}