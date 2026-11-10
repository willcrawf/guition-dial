# Install Arduino ESP32 core + Knobby library versions used by upstream Makefile.
param(
  [switch]$IncludeManufacturerDemoLibs
)

. "$PSScriptRoot\env.ps1"
Assert-ArduinoCli

Write-Host "==> Updating board index"
Invoke-ArduinoCli core update-index --additional-urls $Esp32IndexUrl

Write-Host "==> Installing esp32 core"
Invoke-ArduinoCli core install "esp32:esp32" --additional-urls $Esp32IndexUrl

Write-Host "==> Installing Knobby library pins (lvgl 8.3.11 + Display Panel 1.0.0 stack)"
Invoke-ArduinoCli lib install "lvgl@8.3.11"
Invoke-ArduinoCli lib install "ESP32_Display_Panel@1.0.0"
Invoke-ArduinoCli lib install "ESP32_IO_Expander@1.0.1"
Invoke-ArduinoCli lib install "esp-lib-utils@0.1.2"

if ($IncludeManufacturerDemoLibs) {
  Write-Host "==> Note: manufacturer demo ships bundled Library\ copies under:"
  Write-Host "    $ManufacturerLibs"
  Write-Host "    Prefer those only if building hw-test against the vendor package tree."
  Write-Host "    Knobby and this project's preferred path use the arduino-cli lib installs above."
}

Write-Host ""
Write-Host "Deps installed. Next:"
Write-Host "  .\scripts\build-knobby.ps1"
Write-Host "  .\scripts\build-hw-test.ps1"
Write-Host "Do NOT flash yet - identify the ESP32-S3 COM port first (see README)."
