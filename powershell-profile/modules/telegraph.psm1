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

function dlSingleFile {
    param ( 
        [Parameter(Mandatory = $true, Position = 0)][string]$OriginURL
    )
    $ProgressPreference = 'SilentlyContinue'
    $EndPrefix = "?return_content=true"
    $StratPrefix = "https://telegra.ph"
    $url = [string]$OriginURL.replace('"href":', "").replace('//telegra.ph', "//api.telegra.ph/getPage").replace('"', "") + $EndPrefix
    $WebJSONData = Invoke-WebRequest -Uri $url -Method Get -ContentType "application/json; charset=utf-8" -ErrorAction SilentlyContinue
    $Images = (ConvertFrom-Json $WebJSONData.Content).result.content
    $Title = (ConvertFrom-Json $WebJSONData.Content).result.title
    $StorePath = "$PicturesPath\\telegraph\\$Title"
    if (!(Test-Path $StorePath)) {
        New-Item -ItemType Directory -Path $StorePath
    }
    Write-Host $Title

    $Images | ForEach-Object {
        if ($_.tag -eq "figure") {
            $ImageUrl = $_.children[0].attrs.src
        }
        if ($_.tag -eq "img") {
            $ImageUrl = $_.attrs.src
        }
        if ($ImageUrl) {
            Write-Host "URL:" $ImageUrl
            $ImageName = $ImageUrl.replace("/file/", "")
            Write-Host "即将下载:" $StratPrefix$ImageUrl -ForegroundColor Magenta
            # $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $StratPrefix$ImageUrl -OutFile $StorePath\$ImageName -ErrorAction SilentlyContinue 
        }
    }
}


function dlPaseredFile {
    param (
        [Parameter(Mandatory = $true)]
        [String] $PaserFile
    ) 
    if ($PaserFile) {
        Select-String -Path $PaserFile -Pattern "telegra.ph/" -AllMatches  | 
        Select-Object Line -Unique | 
        Format-Table -HideTableHeaders | 
        Out-String | 
        Set-Content .\TEMP
    }
    else {
        <# Action when all if and elseif conditions are false #>
        Write-Host "Please enter the named `Result` json file path..." -ForegroundColor DarkCyan
    } 
    if (Test-Path .\TEMP) {
        <# Action to perform if the condition is true #>
        $URLS = (Get-Content -Path .\TEMP).Split("\n")
        # Write-Host $URLS
        $Target = @()
        $EndPrefix = "?return_content=true"
        $StratPrefix = "https://telegra.ph"
        $URLS | ForEach-Object {
            # Write-Host $_
            # if ($_.StartsWith("//")) {
            if ($_.contains('"text":')) {
                $Target += $_.replace('"text":', "").replace('telegra.ph', "https://api.telegra.ph/getPage").replace('"', "") + $EndPrefix
            }
            if ($_.contains('"href":')) {
                $Target += $_.replace('"href":', "").replace('telegra.ph', "https://api.telegra.ph/getPage").replace('"', "") + $EndPrefix
            }
            # }
        }
        $Target | ForEach-Object {
            $RealUrl = ($_).Trim()
            $WebJSONData = Invoke-WebRequest -Uri $RealUrl -Method Get -ContentType "application/json; charset=utf-8" -ErrorAction SilentlyContinue
            $Images = (ConvertFrom-Json $WebJSONData.Content).result.content
            $Title = (ConvertFrom-Json $WebJSONData.Content).result.title
            $StorePath = "$PicturesPath\\telegraph\\$Title"
            if (Test-Path $StorePath) {
                return
            }
            else {
                New-Item -ItemType Directory -Path $StorePath
            }
            Write-Host $Title
            $Images | ForEach-Object {
                if ($null -eq $_.children -or $_.children.Length -eq 0) {
                    Write-Host "Null file..." -ForegroundColor Red
                }
                else {
                    $ImageUrl = $_.children[0].attrs.src
                    if ($ImageUrl) {
                        $ImageName = $ImageUrl.replace("/file/", "")
                        Write-Host "即将下载:" $StratPrefix$ImageUrl -ForegroundColor Magenta
                        $ProgressPreference = 'SilentlyContinue'
                        Invoke-WebRequest -Uri $StratPrefix$ImageUrl -OutFile $StorePath\$ImageName -ErrorAction SilentlyContinue -UseBasicParsing
                    }
                    else {
                        Write-Host "Null file..." -ForegroundColor Red
                    }
                }   
            }
        }
    }
    else {
        Write-Host "Please check named `TEMP` file is available..."
    }
}