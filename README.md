# Knobby Platform

Multi-app firmware for GUITION JC3636K518 / JC3636K518C knobs, based on [Knobby](https://github.com/knobby-mtg/knobby-mtg-life-counter).

Boot flow: **Intro → App Select → apps** (Knobby life counter, Demo, and future apps).

This is **not** a drop-in replacement for upstream Knobby releases. Upstream README: [`docs/UPSTREAM_KNOBBY.md`](docs/UPSTREAM_KNOBBY.md). Companion Windows USB notes (docs/scripts only): [willcrawf/knobby-guition-notes](https://github.com/willcrawf/knobby-guition-notes).

## Layout

| Path | Purpose |
|------|---------|
| `knobby/` | Arduino sketch (device firmware) |
| `knobby/src/apps/` | App Select launcher + Demo (+ future apps) |
| `knobby/src/` | Shared UI / life-counter modules (Knobby app) |
| `scripts/` | Windows build / upload / port helpers |
| `hw-test/` | Manufacturer-based dial/touch bring-up sketch |
| `docs/hardware/` | Guition pin evidence, flash mode, comparison notes |
| `recovery/` | Factory restore pointers (no dump binaries in git) |
| `sim/`, `web/` | Upstream simulator / web bits |

## Apps

| Launcher label | Module | Notes |
|----------------|--------|-------|
| Knobby | life-counter UI in `knobby/src/` | Opened via `back_to_main()` |
| Demo | `knobby/src/apps/demo_app.*` | Dial ±1, tap counter, Apps back button |

Add new apps under `knobby/src/apps/`, register them in `app_select.c`, and wire knob input in `knobby/knob.c` when needed.

## Windows build / flash

```powershell
cd C:\Code\knobby-platform

# One-time: ESP32 core + Knobby-pinned libraries
.\scripts\install-deps.ps1

# Compile firmware (App Select + apps)
.\scripts\build-knobby.ps1

# Identify the ESP32-S3 port (not the secondary ESP32)
.\scripts\list-ports.ps1

# Flash (confirms ESP32-S3 unless -SkipChipConfirm)
.\scripts\upload-knobby.ps1 -Port COMx
# or: .\scripts\upload-knobby.ps1 -Port COMx -Build
```

Optional manufacturer HW test:

```powershell
.\scripts\build-hw-test.ps1
```

### Flash timing

Scripts default to `FlashMode=qio120`. If the unit fails to boot after a successful upload:

```powershell
$env:KNOBBY_FLASH_MODE = "qio"   # upstream 80 MHz
.\scripts\build-knobby.ps1
.\scripts\upload-knobby.ps1 -Port COMx
```

Details: [`docs/hardware/FLASH_MODE.md`](docs/hardware/FLASH_MODE.md).

### Tooling

- Prefer `arduino-cli` on `PATH`, or set `$env:ARDUINO_CLI`, or place `tools\arduino-cli.exe` (gitignored).
- Library pins match upstream: `lvgl@8.3.11`, `ESP32_Display_Panel@1.0.0`, `ESP32_IO_Expander@1.0.1`, `esp-lib-utils@0.1.2`.

## Linux / macOS (upstream Makefile)

Upstream `make` / `./compile.sh` / sim targets still live at the repo root. Prefer `scripts\` on Windows for Guition flash workflow.
