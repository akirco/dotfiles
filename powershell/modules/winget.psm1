function wi {
  param([string]$app)
  winget install $app
}
function ws {
  param([string]$app)
  winget search $app
}
function wu {
  param([string]$app)
  if (-not $app) {
    winget upgrade --all
  }
  else {
    winget upgrade $app
  }
}