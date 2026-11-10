# List serial ports and classify likely ESP32-S3 vs ESP32 bridge.
. "$PSScriptRoot\env.ps1"
Assert-ArduinoCli

Write-Host "==> arduino-cli board list"
Invoke-ArduinoCli board list

Write-Host ""
Write-Host "==> Win32_SerialPort / PnP hints"
Get-CimInstance Win32_PnPEntity |
  Where-Object { $_.Name -match 'COM\d+' -or $_.Name -match 'USB Serial|USB JTAG|CH340|CP210|ESP32' } |
  Select-Object Name, DeviceID |
  Format-Table -AutoSize

Write-Host ""
Write-Host "Interpretation (community + manufacturer dual-USB evidence - verify on your unit):"
Write-Host "- ESP32-S3 native USB CDC/JTAG  -> preferred for Knobby / display firmware upload"
Write-Host "- USB-SERIAL / CH340 / CP210x   -> often the secondary ESP32 bridge; do NOT flash Knobby here"
Write-Host ""
Write-Host "On Windows the S3 port is typically a 'USB JTAG/serial debug unit' COM port."
Write-Host "If upload reports 'This chip is ESP32, not ESP32-S3', flip the USB-C cable 180 degrees"
Write-Host "and re-run this script. Power switch on the device bottom must be ON."
