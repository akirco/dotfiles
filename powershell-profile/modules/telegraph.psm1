$PicturesPath = "$env:USERPROFILE\Pictures"

function tdl() {
    param ( 
        [Parameter(Mandatory = $true, Position = 0)][string]$inputParam
    )
    $fileExtension = [System.IO.Path]::GetExtension($inputParam)
    $isJSONFile = ($fileExtension -eq ".json")
    if ($inputParam -match "^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}(/\S*)?$") {
        dlSingleFile -OriginURL $inputParam
    }
    elseif ($isJSONFile) {
        dlPaseredFile -PaserFile $inputParam
    }
    else {
        Write-Host "Invalid param...." -ForegroundColor Red
    }
}

function GetWebJSONData {
    param ( 
        [Parameter(Mandatory = $true, Position = 0)][string]$url
    )
    $ProgressPreference = 'SilentlyContinue'
    $WebJSONData = Invoke-WebRequest -Uri $url -Method Get -ContentType "application/json; charset=utf-8" -ErrorAction SilentlyContinue
    return $WebJSONData
}

function dlSingleFile {
    param ( 
        [Parameter(Mandatory = $true, Position = 0)][string]$OriginURL
    )
    $StratPrefix = "https://telegra.ph"
    $url = [string]$OriginURL.replace('"href":', "").replace('//telegra.ph', "//api.telegra.ph/getPage").replace('"', "") + "?return_content=true"
    $WebJSONData = GetWebJSONData -url $url
    $Images = (ConvertFrom-Json $WebJSONData.Content).result.content
    $Title = (ConvertFrom-Json $WebJSONData.Content).result.title
    $StorePath = "$PicturesPath\telegraph\$Title"
    if (!(Test-Path $StorePath)) {
        New-Item -ItemType Directory -Path $StorePath -ErrorAction SilentlyContinue
    }
    Write-Host "`nTelegraph Downloader`n" -BackgroundColor DarkGray 
    Write-Host `t"downloading: 🖼️  "$Title`n
    $ImagesInfo = @()
    $Images | ForEach-Object {
        if ($_.tag -eq "figure") {
            $ImageUrl = $_.children[0].attrs.src
        }
        if ($_.tag -eq "img") {
            $ImageUrl = $_.attrs.src
        }
        if ($ImageUrl) {
            $ImageName = $ImageUrl.replace("/file/", "")
            $imageFullPath = (Join-Path $StorePath $ImageName)
            $ImagesInfo += [PSCustomObject]@{
                Source      = "$StratPrefix$ImageUrl";
                Destination = $imageFullPath
            }
        }
    }
    $start_time = Get-Date
    $Global:throttleCount = 10
    Write-Host "`ttotal: 🖼️  $($ImagesInfo.Length)`n"
    $ImagesInfo | ForEach-Object -Parallel {
        $SourceURL = $_.Source
        $Destination = $_.Destination
        try {
            Start-BitsTransfer -Source $SourceURL -Destination $Destination -Description "⏳ downloading:$($_.Source)"
        }
        catch {
            Write-Host "Network error, retrying..." -ForegroundColor DarkMagenta
            $Global:throttleCount = 1
        }
        finally {
            Invoke-WebRequest -Uri $SourceURL -OutFile $Destination -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
    } -ThrottleLimit $Global:throttleCount
    Write-Host "Download Completed in: $((Get-Date).Subtract($start_time).Seconds) Seconds" -ForegroundColor green
}

function dlPaseredFile {
    param (
        [Parameter(Mandatory = $true)][String] $PaserFile
    ) 
    if ($PaserFile) {
        Select-String -Path $PaserFile -Pattern "telegra.ph/" -AllMatches  | 
        Select-Object Line -Unique | 
        Format-Table -HideTableHeaders | 
        Out-String | 
        Set-Content .\TEMP
    }
    else {
        Write-Host "Please enter the named `Result` json file path..." -ForegroundColor DarkCyan
    } 
    if (Test-Path .\TEMP) {
        $URLS = (Get-Content -Path .\TEMP).Split("\n")
        $StratPrefix = "https://telegra.ph"
        $URLS | ForEach-Object {
            if ($_.contains('"text":')) {
                $Target += $_.replace('"text":', "").replace('telegra.ph', "https://api.telegra.ph/getPage").replace('"', "") + "?return_content=true"
            }
            if ($_.contains('"href":')) {
                $Target += $_.replace('"href":', "").replace('telegra.ph', "https://api.telegra.ph/getPage").replace('"', "") + "?return_content=true"
            }
        }
        $Target | ForEach-Object {
            $RealUrl = ($_).Trim()
            $WebJSONData = GetWebJSONData -url $RealUrl
            $Images = (ConvertFrom-Json $WebJSONData.Content).result.content
            $Title = (ConvertFrom-Json $WebJSONData.Content).result.title
            $StorePath = "$PicturesPath\telegraph\$Title"
            if (!(Test-Path $StorePath)) {
                New-Item -ItemType Directory -Path $StorePath -ErrorAction SilentlyContinue

            }
            Write-Host "`nTelegraph Downloader`n" -BackgroundColor DarkGray 
            $ImagesInfo = @()
            $Images | ForEach-Object {
                if ($_.tag -eq "figure") {
                    $ImageUrl = $_.children[0].attrs.src
                }
                if ($_.tag -eq "img") {
                    $ImageUrl = $_.attrs.src
                }
                if ($ImageUrl) {
                    $ImageName = $ImageUrl.replace("/file/", "")
                    $imageFullPath = (Join-Path $StorePath $ImageName)
                    $ImagesInfo += [PSCustomObject]@{
                        Source      = "$StratPrefix$ImageUrl";
                        Destination = $imageFullPath
                    }
                }   
            }
            $start_time = Get-Date
            $Global:throttleCount = 10
            Write-Host "`ttotal: 🖼️  $($ImagesInfo.Length)`n"
            $ImagesInfo | ForEach-Object -Parallel {
                try {
                    Start-BitsTransfer -Source $_.Source -Destination $_.Destination -Description "⏳ downloading:$($_.Source)"
                }
                catch {
                    Write-Host "Network error, retrying..." -ForegroundColor DarkMagenta
                    $Global:throttleCount = 1
                }
                finally {
                    Invoke-WebRequest -Uri $SourceURL -OutFile $Destination -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                }   
            } -ThrottleLimit $Global:throttleCount
            Write-Host "Download Completed in: $((Get-Date).Subtract($start_time).Seconds) Seconds" -ForegroundColor green
        }
    }
    else {
        Write-Host "Please check named `TEMP` file is available..."
    }
}
