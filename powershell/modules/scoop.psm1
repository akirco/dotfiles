$config_path = Join-Path $env:USERPROFILE ".config\scoop\config.json"

if (!(Test-Path $config_path)) {
  Write-Host "Please notice: $env:USERPROFILE\.config\scoop\config.json is available!" -ForegroundColor DarkYellow
  return
}

$JSON = Get-Content $config_path | ConvertFrom-Json

$root_path = $JSON.root_path

function getBuckets() {
  try {
    $buckets = Join-Path $root_path "buckets\*\bucket"
    $bucketsDirs = Get-ChildItem -Path $buckets -Directory -ErrorAction Stop |
    Select-Object -ExpandProperty FullName
    return $bucketsDirs
  }
  catch {
    Write-Warning "Error getting buckets: $_"
    return @()
  }
}
function scoopSearch {
  param(
    [string]$searchTerm
  )

  $results = @()
  getBuckets | ForEach-Object {
    $bucketPath = $_
    $manifestFiles = Get-ChildItem -Path $bucketPath -Recurse -Filter "*$searchTerm*.json"
    if ($manifestFiles) {
      $results += $manifestFiles | ForEach-Object -ThrottleLimit 8 -Parallel {
        try {
          $packageJson = Get-Content $_.FullName -Raw | ConvertFrom-Json
          $appName = $_.Name.Split(".")[0]
          $bucketName = (Split-Path $_.Directory -Parent).Split("\")[-1]
          [PSCustomObject]@{
            Version = $packageJson.version
            App     = $appName
            Bucket  = $bucketName
          }
        }
        catch {
          Write-Warning "Error processing $($_.FullName): $_"
        }
      }
    }
  }

  $results | Select-Object Bucket, App, Version -Unique | Format-Table -AutoSize
}

function searchRemote {
  param(
    [Parameter(Mandatory = $false, Position = 0)][string]$searchTerm,
    [Parameter(Mandatory = $false, Position = 1)][int]$searchCount = 15
  )
  $APP_URL = "https://scoopsearch.search.windows.net/indexes/apps/docs/search?api-version=2020-06-30";
  $APP_KEY = "DC6D2BBE65FC7313F2C52BBD2B0286ED";
  $request = [System.Net.WebRequest]::Create($APP_URL)

  $request.Method = "POST"
  $request.ContentType = "application/json"
  $request.Headers.Add("api-key", $APP_KEY)
  $request.Headers.Add("origin", "https://scoop.sh")

  $data = @{
    count            = $true
    searchMode       = "all"
    filter           = ""
    skip             = 0
    search           = $searchTerm
    top              = $searchCount
    orderby          = @(
      "search.score() desc",
      "Metadata/OfficialRepositoryNumber desc",
      "NameSortable asc"
    ) -join ","
    select           = @(
      "Id",
      "Name",
      "NamePartial",
      "NameSuffix",
      "Description",
      "Homepage",
      "License",
      "Version",
      "Metadata/Repository",
      "Metadata/FilePath",
      "Metadata/OfficialRepository",
      "Metadata/RepositoryStars",
      "Metadata/Committed",
      "Metadata/Sha"
    ) -join ","
    highlight        = @(
      "Name",
      "NamePartial",
      "NameSuffix",
      "Description",
      "Version",
      "License",
      "Metadata/Repository"
    ) -join ","
    highlightPreTag  = "<mark>"
    highlightPostTag = "</mark>"
  }


  $body = ConvertTo-Json $data


  $requestStream = $request.GetRequestStream()
  $writer = New-Object System.IO.StreamWriter($requestStream)
  $writer.Write($body)
  $writer.Flush()

  $response = $request.GetResponse()

  $stream = $response.GetResponseStream()
  $reader = New-Object System.IO.StreamReader($stream)
  $content = $reader.ReadToEnd()

  $object = ConvertFrom-Json $content

  $response.Close()

  return $object
}

function scoopAdd {
  param(
    [Parameter(Mandatory = $false, Position = 0)][Object]$addAPP,
    [Parameter(Mandatory = $false, Position = 1)][Object]$searchResult
  )


  $bucketPath = Join-Path $root_path "buckets" "remote"

  $remotePath = Join-Path $bucketPath "bucket"


  if (!(Test-Path $remotePath)) {
    Write-Host "Creating remote bucket...$remotePath" -ForegroundColor DarkYellow

    New-Item -ItemType Directory -Path $remotePath
  }


  $bucket = $addAPP.Split("/")[0]
  $app = $addAPP.Split("/")[1]

  Write-Host $bucket
  Write-Host $app

  $Repository = $searchResult.value.Metadata.Repository
  $FilePath = $searchResult.value.Metadata.FilePath

  $filteredBucket = $Repository | Where-Object {
    $RepositoryUrl = $_
    $remoteBucket = $RepositoryUrl.Substring($RepositoryUrl.LastIndexOf("/") + 1)
    $remoteBucket -eq $bucket
  } | Select-Object -First 1
  $filteredApp = $FilePath | Where-Object {
    $appPath = $_
    $remoteApp = $appPath.Substring($appPath.LastIndexOf("/") + 1).Split(".")[0]
    $remoteApp -eq $app
  } | Select-Object -First 1

  $remoteManifestFile = $filteredBucket.replace("github.com", "raw.githubusercontent.com") + "/master" + "/" + $filteredApp

  $outFile = Join-Path $bucketPath $filteredApp

  Write-Host "Remote app ManifestFile is downloading..." -ForegroundColor Cyan
  Write-Host "Url:" $remoteManifestFile -ForegroundColor Green

  Write-Host "Downloading...$outFile" -ForegroundColor Cyan


  Invoke-WebRequest -Uri $remoteManifestFile -OutFile $outFile

  if (Test-Path $outFile) {
    Write-Host "Remote app ManifestFile is add successful...`n" -ForegroundColor Magenta
  }
}

function scoopDir {
  param(
    [Parameter(Mandatory = $false, Position = 0)][string]$inputParam
  )
  if ($inputParam.Length -eq 0) {
    Start-Process $root_path
  }
  else {
    Start-Process $(scoop prefix $inputParam)
  }
}





$Global:searchResult = $null

function scoop {
  param(
    [Parameter(Mandatory = $false, Position = 0)][string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args
  )

  $shims = Join-Path $root_path "shims\scoop.ps1"
  $params = $($Args -join ' ')

  # $aliass = Invoke-Expression "$shims alias list -v"

  # $alias_search = $aliass | where-object { $_.Command -match '^scoop\s+search' }


  $Command = switch ($Command) {
    "s" { "search" }
    "i" { "install" }
    default { $Command }
  }

  switch ($Command) {
    "search" {
      # Call our custom search function instead
      if ($Args -eq $null) {
        Invoke-Expression "$shims search"
      }
      else {

        $searchTerm = $Args[0]

        $searchCount = if ($Args.Count -gt 1) { [int]$Args[1] } else { 15 }

        scoopSearch -searchTerm $searchTerm

        $Global:searchResult = searchRemote -searchTerm $searchTerm -searchCount $searchCount

        $searchResult.value | Format-Table @{
          Label      = "Remote Repository";
          Expression = { $_.Metadata.Repository + ".git" }
        }, @{
          Label      = "App";
          Expression = { $_.Name }
        }, Version -AutoSize
        # $searchResult.value | ForEach-Object {
        #   $remoteUrl = $_.Metadata.Repository.replace("github.com", "raw.githubusercontent.com") + "/master/" + $_.Metadata.FilePath
        #   [PSCustomObject]@{
        #     Url     = $remoteUrl
        #     Name    = $_.Name
        #     Version = $_.Version
        #   }
        # } | Format-List
      }
    }
    "add" {
      # Add the remote package to local
      if ($null -ne $Global:searchResult) {
        scoopAdd $params $Global:searchResult
      }
      else {
        Write-Host "Please execute 'scoop search' command first to get the remote package list." -ForegroundColor Magenta
      }

    }
    "dir" {
      scoopDir -inputParam $params
    }
    "install" {
      foreach ($item in $Args) {
        $commandLine = "$shims $Command $item"
        Invoke-Expression $commandLine
      }
    }
    default {

      $commandLine = "$shims $Command $params"

      Invoke-Expression $commandLine
    }
  }
}
