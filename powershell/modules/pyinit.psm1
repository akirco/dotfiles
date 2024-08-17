function pyinit {
    conda config --set env_prompt ''
    $condaPath = Invoke-Expression "where.exe conda.exe"
    if (Test-Path $condaPath) {
        (& "$condaPath" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
    }
}