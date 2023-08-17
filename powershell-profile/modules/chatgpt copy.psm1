function ChatGpt() {
    $prompts = @()
    while ($true) {
        $sessionResponse = ""
        Write-Host "Q: " -BackgroundColor DarkCyan -NoNewline
        $prompt = Read-Host
        if ($prompt -eq "q") {
            break
        }
        if ($prompt -eq "cls") {
            Clear-Host
            continue
        }
        if ($prompt -eq "" -or $prompt -eq "help") {
            Write-Host "
              _________ .__            __                 __   
              \_   ___ \|  |__ _____ _/  |_  ____ _______/  |_ 
              /    \  \/|  |  \\__  \\   __\/ ___\\____ \   __\
              \     \___|   Y  \/ __ \|  | / /_/  >  |_> >  |  
               \______  /___|  (____  /__| \___  /|   __/|__|  
                      \/     \/     \/    /_____/ |__|         
              " -ForegroundColor DarkRed
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
                $API_URL = "https://openai.extrameta.cn/v1/chat/completions"
                $API_KEY = ""
                Write-Host "A: " -NoNewline -BackgroundColor DarkYellow
                $request = [System.Net.WebRequest]::Create($API_URL)
                $request.Method = "POST"
                $request.ContentType = "application/json"
                $request.Headers.Add("Authorization", "Bearer $API_KEY")
                $data = @{
                    model       = "gpt-3.5-turbo";
                    messages    = $prompts;
                    temperature = 0.7;
                    max_tokens  = 3000;
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