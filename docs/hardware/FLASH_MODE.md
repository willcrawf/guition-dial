# Flash mode / timing (`qio` vs `qio120`)

## What this setting actually changes

On ESP32 Arduino core **3.3.x**, board option `FlashMode` encodes both SPI I/O width and **external NOR flash clock**:

| FQBN value | Meaning |
|------------|---------|
| `FlashMode=qio` | Quad I/O, **80 MHz** flash clock (board-details default for `esp32s3`) |
| `FlashMode=qio120` | Quad I/O, **120 MHz** flash clock |

This is **CPU ↔ onboard flash chip** timing (the W25Q128 next to the S3), not the ST77916 display QSPI bus, and **not** a GPIO pin assignment.

Pin agreement between manufacturer `pincfg.h` and Knobby `board_k518` says nothing about which flash clock the board needs. Those are independent configuration axes.

## Why this repo’s scripts first try `qio120`

**Preference only — not proven on a physical YR1 unit.**

| Source | Setting | Strength |
|--------|---------|----------|
| Manufacturer `Arduino configuration.png` (Tools menu for the demo) | **QIO 120MHz** highlighted | Strongest *Arduino-build* hint in the package |
| Community PromptKnob docs for JC3636K518C | Claims **80 MHz leaves the panel dark**; forces 120 MHz in PlatformIO | Second-hand / different toolchain; treat as a lead |
| Upstream Knobby `Makefile` / CI FQBN | `FlashMode=qio` only (→ **80 MHz** on core 3.3.x) | Known-working for their shipped builds; no `qio120` |
| Manufacturer Flash Download Tool screenshots for factory S3 bin | SPI SPEED **80 MHz**, mode **QIO** | About *programming* the factory image, not Arduino runtime FQBN; still shows 80 MHz is not “wrong” for this hardware family |

So `qio120` is the first compile default because the vendor’s own Arduino Tools screenshot calls for it, **not** because pins matched.

## If booting fails after a successful upload

Symptoms that often implicate flash timing / image config (among other causes): boot loop, brownout, silent brick after upload, serial garbage, or “upload OK” then blank/dead UI.

**Fall back to upstream Knobby’s flash setting:**

```powershell
cd C:\Code\knobby-platform
$env:KNOBBY_FLASH_MODE = "qio"   # QIO 80 MHz — matches Knobby Makefile/CI
.\scripts\build-knobby.ps1
# then upload to the confirmed ESP32-S3 port (when you are ready to flash)
```

Also re-check:

1. Correct MCU port (S3 CDC/JTAG, not the secondary ESP32 bridge).
2. Factory restore with the packaged `ESP32_S3_1.85KNOB.bin` @ `0x0` if the unit no longer boots at all.
3. Only after a known-good flash clock path works, chase display-init / game-logic issues.

## Recommended A/B order on first hardware

1. **`qio120`** — match manufacturer Arduino screenshot (this repo default).
2. If unstable or won’t boot: **`qio`** — match upstream Knobby.
3. If still blank UI but serial shows life: treat as display/backlight bring-up (`hw-test`), not flash-clock first.

Do not treat either frequency as “verified for YR1” until a connected unit passes the factory → hw-test → Knobby sequence.
