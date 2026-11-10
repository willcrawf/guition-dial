# Knobby vs manufacturer evidence (Phase 2)

Firmware tree used: `C:\Code\guition-dial` (Arduino sketch at `firmware/knobby/`).

## Comparison table

| Area | Manufacturer package | Knobby (`board_k518`) | Match? |
|------|----------------------|------------------------|--------|
| Main MCU | ESP32-S3R8 | ESP32-S3 FQBN | Yes (expected) |
| Flash size / PSRAM | 16 MB / 8 MB OPI | `FlashSize=16M,PSRAM=opi` | Yes |
| Display IC / res | ST77916 360×360 QSPI | ST77916 360×360 QSPI | Yes |
| Display pins | 14/13/15–18/21, BL 47 | identical in `board_pins.c` | Yes |
| Touch | CST816S I2C 11/12/9/10 | identical | Yes |
| Encoder | A=8 B=7 | identical | Yes |
| Backlight | GPIO 47 LEDC | GPIO 47 LEDC (10-bit) | Yes |
| Battery ADC | GPIO 1 | GPIO 1 | Yes (calibration WIP both sides) |
| Boot button | GPIO 0 | GPIO 0 | Yes |
| Second ESP32 | Present (audio/UART) | Unused by Knobby | N/A (leave alone) |
| Flash **clock** | Arduino screenshot QIO **120 MHz**; factory tool UI **80 MHz** QIO | Upstream FQBN `FlashMode=qio` (= **80 MHz** on core 3.3.x) | **Unresolved by pins** — see `FLASH_MODE.md` |
| Partition scheme | Huge APP in manufacturer Arduino UI; factory = merged @0x0 | Custom dual-OTA `partitions.csv` | Different by design |
| Init / libs | Display Panel + LVGL 8.x | Same stack, pinned versions | Compatible expected |
| Board detect | Fixed pins in demo | Probes K518 then K718 | K518 first — good |

Pin source: manufacturer `2-Program Example\Demo_Arduino\ST77916_LVGL_DEMO\pincfg.h` vs Knobby `knobby\board_pins.c` `board_k518`.

## Conclusion

**Needs specific configuration choices (expected pin compatibility high; flash timing and device rev not verified).**

1. Prefer flashing the **ESP32-S3** USB port (flip cable if host sees classic ESP32).
2. **Pins alone do not pick flash frequency.** This repo’s scripts first try `FlashMode=qio120` from the manufacturer Arduino screenshot; if boot fails, use upstream **`FlashMode=qio`** (80 MHz). Full rationale: [`FLASH_MODE.md`](FLASH_MODE.md).
3. Keep Knobby’s custom partition scheme for Knobby builds; do not assume factory partition CSV.
4. No pin-map fork needed for K518-class hardware based on source comparison.

Do **not** call this verified until a physical unit boots Knobby successfully.

If Knobby fails after the correct S3 port and a flash-mode A/B (`qio120` then `qio`), fall back to `hw-test` (manufacturer init path) before chasing game-logic bugs.
