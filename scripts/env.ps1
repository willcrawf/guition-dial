# Shared paths for Windows PowerShell builds in this platform repo.
# ASCII-only.
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot

# Prefer a local tools\arduino-cli.exe, else PATH / $env:ARDUINO_CLI.
$ArduinoCliLocal = Join-Path $ProjectRoot "tools\arduino-cli.exe"
if ($env:ARDUINO_CLI -and (Test-Path $env:ARDUINO_CLI)) {
  $ArduinoCli = $env:ARDUINO_CLI
} elseif (Test-Path $ArduinoCliLocal) {
  $ArduinoCli = $ArduinoCliLocal
} else {
  $cmd = Get-Command arduino-cli -ErrorAction SilentlyContinue
  $ArduinoCli = if ($cmd) { $cmd.Source } else { $null }
}

# Platform root. Arduino sketch lives at firmware/knobby/ (Knobby = life-counter app name).
$KnobbyRoot = $ProjectRoot
$FirmwareSketch = Join-Path $ProjectRoot "firmware\knobby"
$HwTestSketch = Join-Path $ProjectRoot "hw-test\ST77916_LVGL_DEMO"
$ManufacturerRoot = "C:\Users\WillCrawford\Downloads\JC3636K518CN_knob_EN\JC3636K518CN_knob_EN"
$ManufacturerLibs = Join-Path $ManufacturerRoot "2-Program Example\Demo_Arduino\Library"

# ESP32 Arduino core 3.3.x encodes external NOR flash clock inside FlashMode.
# This is flash timing, NOT a GPIO / pin-map setting.
#   qio     = QIO 80MHz  - upstream Knobby Makefile/CI; try this if boot fails
#   qio120  = QIO 120MHz - first attempt here (manufacturer Arduino Tools screenshot)
# See docs/hardware/FLASH_MODE.md. Override: $env:KNOBBY_FLASH_MODE = "qio"
if (-not $env:KNOBBY_FLASH_MODE) { $env:KNOBBY_FLASH_MODE = "qio120" }

$KnobbyFqbn = "esp32:esp32:esp32s3:FlashSize=16M,PSRAM=opi,USBMode=hwcdc,CDCOnBoot=cdc,FlashMode=$($env:KNOBBY_FLASH_MODE),PartitionScheme=custom"
$HwTestFqbn = "esp32:esp32:esp32s3:FlashSize=16M,PSRAM=opi,USBMode=hwcdc,CDCOnBoot=cdc,FlashMode=$($env:KNOBBY_FLASH_MODE),PartitionScheme=huge_app"

$Esp32IndexUrl = "https://espressif.github.io/arduino-esp32/package_esp32_index.json"

function Assert-ArduinoCli {
  if (-not $ArduinoCli -or -not (Test-Path $ArduinoCli)) {
    throw "arduino-cli not found. Put it at tools\arduino-cli.exe, add to PATH, or set `$env:ARDUINO_CLI."
  }
  return $ArduinoCli
}

function Invoke-ArduinoCli {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$CliArgs)
  $cli = Assert-ArduinoCli
  & $cli @CliArgs
  if ($LASTEXITCODE -ne 0) { throw "arduino-cli failed ($LASTEXITCODE): $($CliArgs -join ' ')" }
}

function Get-EspToolCommand {
  $cmd = Get-Command esptool -ErrorAction SilentlyContinue
  if ($cmd) { return @{ Exe = $cmd.Source; Prefix = @() } }
  $py = Get-Command python -ErrorAction SilentlyContinue
  if ($py) { return @{ Exe = $py.Source; Prefix = @("-m", "esptool") } }
  $py3 = Get-Command python3 -ErrorAction SilentlyContinue
  if ($py3) { return @{ Exe = $py3.Source; Prefix = @("-m", "esptool") } }
  return $null
}

function Confirm-Esp32S3Port {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Port
  )

  $tool = Get-EspToolCommand
  if (-not $tool) {
    throw "esptool not found (need esptool on PATH or python -m esptool). Cannot confirm chip type."
  }

  Write-Host "Confirming chip on $Port (must be ESP32-S3)..."
  $args = @()
  $args += $tool.Prefix
  $args += @("--port", $Port, "chip-id")

  $output = & $tool.Exe @args 2>&1 | Out-String
  Write-Host $output

  if ($LASTEXITCODE -ne 0) {
    throw "esptool chip-id failed on $Port (exit $LASTEXITCODE). Check cable, power switch ON, and port."
  }

  if ($output -match 'ESP32-S3') {
    Write-Host "Chip confirm OK: ESP32-S3 on $Port"
    return
  }

  if ($output -match 'ESP32') {
    throw @"
Chip on $Port looks like classic ESP32, not ESP32-S3.
Do not flash firmware here. Flip the USB-C cable 180 degrees, re-run scripts\list-ports.ps1,
and confirm chip-id again. COM numbers are not trustworthy on this dual-MCU knob.
"@
  }

  throw "Could not confirm ESP32-S3 on $Port from chip-id output. Aborting upload."
}
