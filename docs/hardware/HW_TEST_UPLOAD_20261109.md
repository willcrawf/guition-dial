# HW-test upload session 2026-11-09

## Backup preservation
- File: `recovery\backups\factory-esp32s3-fullflash-20261109-174830.bin`
- Size 16777216, SHA256 `545EFCEA5551422B186159BD091D9820A7E2B1FA0EE76CCCD0994CA481C007C8` — re-verified before upload; not modified.

## Pre-upload chip confirm
- Port COM3 → esptool `chip-id` / `flash-id` → **ESP32-S3** (QFN56 v0.2), 16MB flash, MAC `44:bd:8d:6e:a6:a8`.

## Settings used
FQBN: `esp32:esp32:esp32s3:FlashSize=16M,PSRAM=opi,USBMode=hwcdc,CDCOnBoot=cdc,FlashMode=qio120,PartitionScheme=huge_app`

Upload offsets (arduino-cli / flash_args):
- `0x0` bootloader
- `0x8000` partitions
- `0xe000` boot_app0
- `0x10000` app

## Departures vs manufacturer package
| Item | Manufacturer | This upload |
|------|--------------|-------------|
| Arduino Tools flash | Screenshot: QIO **120 MHz** | FQBN `FlashMode=qio120` (intent). Note: generated `flash_args` still listed `--flash-mode dio --flash-freq 80m` (Espressif Arduino write defaults); ROM boot log also showed `mode:DIO`. |
| Factory download tool | QIO **80 MHz**, single merged bin @ `0x0` | Not used; Arduino multi-image layout instead |
| Partition | Factory = opaque merged image; Arduino screenshot Huge APP | `huge_app` (~3MB app) — matches manufacturer Arduino screenshot, **not** factory layout |
| FlashSize | 16MB claimed | `FlashSize=16M` + detected 16MB |
| PSRAM | 8MB OPI | `PSRAM=opi` |
| Libraries | Package txt/screenshots conflict (Panel 0.1.4 vs 1.0.1, etc.) | Knobby-aligned: lvgl 8.3.11, Display Panel 1.0.0, IO Expander 1.0.1, esp-lib-utils 0.1.2 |
| ESP32 core | Screenshot ~3.1.0 | Installed **3.3.12** |

## Upload
- Target: COM3 ESP32-S3 only. Success, hashes verified by esptool.
- Second ESP32 not touched.

## Serial (115200, ~15s after reset)
- ROM boot OK, `SPI_FAST_FLASH_BOOT`
- Touch CST816S init OK (`IC id: 182`)
- Display ST77916 panel create OK
- No crash / PSRAM error lines in capture

## Pause
Knobby not uploaded. Manual UI checks required on device.
