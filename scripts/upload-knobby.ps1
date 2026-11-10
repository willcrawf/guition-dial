# Upload built (or just-compiled) firmware to a confirmed ESP32-S3 COM port.
# ASCII-only.
param(
  [Parameter(Mandatory = $true)]
  [string]$Port,

  [switch]$SkipChipConfirm,
  [switch]$Build,
  [string]$BuildPath = ""
)

. "$PSScriptRoot\env.ps1"
Assert-ArduinoCli | Out-Null

$sketch = Join-Path $KnobbyRoot "knobby"
if (-not $BuildPath) {
  $BuildPath = Join-Path $ProjectRoot "build\knobby"
}

if ($Port -notmatch '^(?i)COM\d+$') {
  throw "Port must look like COM3 (got '$Port'). Run scripts\list-ports.ps1 first."
}
$Port = $Port.ToUpperInvariant()

Write-Host "FQBN:      $KnobbyFqbn"
Write-Host "FlashMode: $($env:KNOBBY_FLASH_MODE)"
Write-Host "Port:      $Port"
Write-Host "Sketch:    $sketch"
Write-Host ""

if (-not $SkipChipConfirm) {
  Confirm-Esp32S3Port -Port $Port
  Write-Host ""
} else {
  Write-Host "WARNING: -SkipChipConfirm set. Ensure $Port is ESP32-S3."
  Write-Host ""
}

if ($Build) {
  New-Item -ItemType Directory -Force -Path $BuildPath | Out-Null
  Write-Host "Compiling before upload..."
  Invoke-ArduinoCli compile `
    --fqbn $KnobbyFqbn `
    --build-path $BuildPath `
    $sketch
  Write-Host ""
}

Write-Host "Uploading to $Port ..."
$uploadArgs = @(
  "upload",
  "--fqbn", $KnobbyFqbn,
  "-p", $Port
)
if (Test-Path $BuildPath) {
  $uploadArgs += @("--input-dir", $BuildPath)
}
$uploadArgs += $sketch

Invoke-ArduinoCli @uploadArgs

Write-Host ""
Write-Host "UPLOAD OK on $Port"
Write-Host "If boot fails after upload, rebuild with `$env:KNOBBY_FLASH_MODE = 'qio' and re-flash."
Write-Host "See docs\hardware\FLASH_MODE.md"
