# Flashing boundary (not executed yet)

This project intentionally **does not** flash, erase, or browser-install firmware.

## Before first flash checklist

1. Power switch ON; data-capable USB-C cable.
2. Run `..\scripts\list-ports.ps1` and identify the ESP32-S3 CDC/JTAG COM port.
3. Confirm chip with a read-only detect (example only — fill COM after identification):

```powershell
# Example AFTER port known — do not run until COM is confirmed as ESP32-S3
# & "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esptool_py\*\esptool.exe" --chip esp32s3 -p COMx chip_id
```

4. Keep manufacturer factory bins readable (see `FACTORY_BINARIES.md`).
5. Copy TF card contents if you care about restoring stock media UI.
6. Prefer flashing `hw-test` before Knobby on first hardware bring-up.

## Upload commands (templates — parameters TBD on device)

```powershell
cd C:\Code\guition-dial
. .\scripts\env.ps1

# After build-knobby.ps1 succeeded and PORT is the S3 port:
# & $ArduinoCli upload --fqbn $KnobbyFqbn -p COMx $FirmwareSketch

# After build-hw-test.ps1:
# & $ArduinoCli upload --fqbn $HwTestFqbn -p COMx $HwTestSketch
```

## Factory restore commands (manufacturer tool)

Prefer the GUI flow documented in the README using the packaged Flash Download Tool and the `*_1.85KNOB.bin` images at `0x0`. A scripted `esptool write_flash 0x0 ...` equivalent is only safe after chip + port confirmation.
