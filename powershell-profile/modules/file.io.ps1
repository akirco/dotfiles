function upload {
  param ([string]$file)
  $siteAddress = "https://file.io/?expires=1w"
  $webClient = New-Object System.Net.WebClient
  $response
  try {
    $response = $webClient.UploadFile($siteAddress, $file)
  }
  catch {
    Write-Host $_
  }
  [System.Text.Encoding]::ASCII.GetString($response) | Format-Table
}

upload -file .\_config.yml