$config_path = Join-Path $env:USERPROFILE ".config\scoop\config.json"

if (!(Test-Path $config_path)) {
  Write-Host "Please notice: $env:USERPROFILE\.config\scoop\config.json is available!" -ForegroundColor DarkYellow
  return
}

$JSON = Get-Content $config_path | ConvertFrom-Json

$APIKey = $JSON.sd_apikey
$APISecret = $JSON.sd_apisecret
$API_URL = "https://spark-api-open.xf-yun.com/v1/chat/completions"


function sd {
    $prompts = @()
    while ($true) {
        $sessionResponse = ""
        Write-Host "🐼: " -NoNewline
        $prompt = Read-Host
        if ($prompt -eq "q") {
            break
        }
        if ($prompt -eq "cls") {
            Clear-Host
            continue
        }
        if ($prompt -eq "" -or $prompt -eq "help") {
            Write-Host "sparkdesk" -ForegroundColor DarkRed
            Write-Host "`t Special Prompt: " -ForegroundColor Red
            Write-Host "`t ● q  = quit prompt`n`t ● cls = clear host`n`t ● n = new conversation" -ForegroundColor DarkBlue
        }
        elseif ($prompt -eq "n") {
            $prompts = @()
        }
        else {
            $prompts += @{
                role    = "user";
                content = $prompt
            }
            if ($prompts -ne @()) {
                Write-Host "🤖: " -NoNewline
                $request = [System.Net.WebRequest]::Create($API_URL)
                $request.Method = "POST"
                $request.ContentType = "application/json"
                $request.Headers.Add("Authorization", "Bearer"+$APIKey+":"+$APISecret)
                $data = @{
                    model       = "generalv3.5";
                    messages    = $prompts;
                    temperature = 0;
                    max_tokens  = 4096;
                    stream      = $true;
                }
                $body = ConvertTo-Json $data
                $requestStream = $request.GetRequestStream()
                $writer = New-Object System.IO.StreamWriter($requestStream)
                $writer.Write($body)
                $writer.Flush()
                $response = $request.GetResponse()
                $stream = $response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                while (!$reader.EndOfStream) {
                    $line = $reader.ReadLine()
                    if (![string]::IsNullOrWhiteSpace($line)) {
                        if ($line -match '^data: (.+)$') {
                            $eventData = $Matches[1]
                            if ($eventData -ne "[DONE]") {
                                $content = ConvertFrom-Json $eventData
                                $sessionResponse += $content.choices[0].delta.content
                                Write-Host $content.choices[0].delta.content -NoNewline -ForegroundColor Magenta
                            }
                        }
                    }
                }
                $prompts += @{
                    role    = "assistant";
                    content = $sessionResponse
                }
                $reader.Close()
                $stream.Close()
                Write-Host "`n"
            }
        }
    }
}