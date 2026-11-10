# Compile the manufacturer-based minimal dial/touch test (no upload).
. "$PSScriptRoot\env.ps1"
Assert-ArduinoCli

if (-not (Test-Path $HwTestSketch)) {
  throw "HW test sketch missing: $HwTestSketch"
}

$buildDir = Join-Path $ProjectRoot "build\hw-test"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

Write-Host "FQBN: $HwTestFqbn"
Write-Host "Sketch: $HwTestSketch"
Write-Host "Build dir: $buildDir"
Write-Host "Using libraries installed by install-deps.ps1 (Display Panel 1.0.0 stack)."

Invoke-ArduinoCli compile `
  --fqbn $HwTestFqbn `
  --build-path $buildDir `
  $HwTestSketch

Write-Host ""
Write-Host "BUILD OK (compile only - no device was flashed)."
Write-Host "Firmware artifacts under: $buildDir"
