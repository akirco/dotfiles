using namespace System.IO
using namespace System.Text
using namespace System.Threading

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
            try {
                Invoke-WebRequest -Uri $SourceURL -OutFile $Destination -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
            catch {
                Write-Host "Current request is being used by another process" -ForegroundColor Red
            }
        }
    } -ThrottleLimit $Global:throttleCount
    Write-Host "Download Completed in: $((Get-Date).Subtract($start_time).Seconds) Seconds" -ForegroundColor green
}

function parserFile () {
    param (
        [Parameter(Mandatory = $true)][string]$filePath
    )
    $searchPattern = "telegra.ph/"

    # 以流的方式读取JSON文件
    $streamReader = [StreamReader]::new($filePath)

    # 定义每个块的大小（根据实际情况进行调整）
    $blockSize = 1000

    # 定义一个数组用于存储搜索结果
    $searchResults = @()

    # 定义计数器变量
    $totalLines = 0
    $processedLines = 0

    while (!$streamReader.EndOfStream) {
        $block = @()
        for ($i = 0; $i -lt $blockSize -and !$streamReader.EndOfStream; $i++) {
            $block += $streamReader.ReadLine()
            $totalLines++
        }

        # 在当前块中搜索模式
        $matchedLines = $block | Where-Object { $_ -match $searchPattern }


        $matchedLines = $matchedLines.Trim().Split(": ")[1]

        if ($matchedLines -match "telegra.ph/pass") {
            continue
        }

        # 将搜索结果添加到数组中
        $searchResults += $matchedLines

        # 更新已处理行数
        $processedLines += $matchedLines.Count

        # 计算处理进度
        $progress = [math]::Round($processedLines / $totalLines * 100, 2)

        # 打印处理进度
        Write-Host "处理进度：$progress% ($processedLines / $totalLines)"
    }

    # 关闭流
    $streamReader.Close()

    # 将搜索结果保存到文件
    $outputFilePath = "$env:USERPROFILE\Downloads\searchResults.txt"
    $searchResults | Out-File -FilePath $outputFilePath
    # 打印保存结果的文件路径
    Write-Host "搜索结果已保存到文件：$outputFilePath"
    $isCountinue = Read-Host "download? (y/n)"
    if (-not($isCountinue -eq "y")) {
        break
    }
}



function dlPaseredFile {
    param (
        [Parameter(Mandatory = $true)][String]$PaserFile
    )
    if ($PaserFile) {
        $absolutePath = Convert-Path -Path $PaserFile
        Write-Host $absolutePath
        parserFile -filePath $absolutePath
    }
    else {
        Write-Host "Please enter the named `Result` json file path..." -ForegroundColor DarkCyan
    }
    if (Test-Path ".\searchResults.txt") {
        $URLS = (Get-Content -Path ".\searchResults.txt").Split("\n")
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
                    try {
                        Invoke-WebRequest -Uri $SourceURL -OutFile $Destination -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                    }
                    catch {
                        Write-Host "Current request is being used by another process" -ForegroundColor Red
                    }
                }
            } -ThrottleLimit $Global:throttleCount
            Write-Host "Download Completed in: $((Get-Date).Subtract($start_time).Seconds) Seconds" -ForegroundColor green
        }
    }
    else {
        Write-Host "Please check named `TEMP` file is available..."
    }
}
