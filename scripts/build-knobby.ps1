# Compile platform firmware (App Select + apps) with arduino-cli. No upload.
. "$PSScriptRoot\env.ps1"
Assert-ArduinoCli | Out-Null

$sketch = $FirmwareSketch
if (-not (Test-Path $sketch)) {
  throw "Sketch missing: $sketch"
}

$buildDir = Join-Path $ProjectRoot "build\knobby"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

Write-Host "FQBN:      $KnobbyFqbn"
Write-Host "FlashMode: $($env:KNOBBY_FLASH_MODE)"
Write-Host "Sketch:    $sketch"
Write-Host "Build dir: $buildDir"

Invoke-ArduinoCli compile `
  --fqbn $KnobbyFqbn `
  --build-path $buildDir `
  $sketch

Write-Host ""
Write-Host "BUILD OK (compile only - no device was flashed)."
Write-Host "Firmware artifacts under: $buildDir"
Write-Host "Upload: .\scripts\upload-knobby.ps1 -Port COMx"
