# Hardware evidence (Phase 1)

Manufacturer package root (unmodified):

`C:\Users\WillCrawford\Downloads\JC3636K518CN_knob_EN\JC3636K518CN_knob_EN`

## 1. Board / model / revision

| Claim | Status | Evidence |
|-------|--------|----------|
| Package covers **JC3636K518** knob family | Confirmed | Zip / folder name `JC3636K518CN_knob_EN` |
| PDF SKU **JC3636K518C_I_W** | Confirmed | `1-Instructions\JC3636K518 Instructions-EN.pdf` p.1,4 (extracted: `pdf_extract\JC3636K518 Instructions-EN.txt`) |
| AliExpress / Guition listing **JC3636K518C-I-YR1** / `JC3636K518C_I_YR1` | Listing / site claim | Guition product page; **not printed as YR1 inside this package** |
| Schematic revisions **V1.0** and **V2.0** both present | Confirmed | `6-Schematic diagram\V1.0\`, `...\V2.0\` |
| Exact PCB silk revision of a purchased YR1 unit | Missing | No device on hand |

**Contradiction / naming:** package PDF uses `_I_W`; listing uses `-I-YR1`. Same base model string `JC3636K518C`, different suffix. Treat as same product family until a physical unit is checked.

**Listing contradiction (size/resolution):** AliExpress title “1.85 inch” / table “320×320” vs manufacturer PDF “1.8 inch” / **360×360**. Package burn screenshots and TF assets use **1.85KNOB** and **360** assets. Prefer manufacturer PDF + example code (**360×360**) over the AliExpress table.

## 2. MCU / memory

| Item | Value | Evidence |
|------|-------|----------|
| Main MCU | ESP32-S3R8 | PDF p.3; schematic `V2.0\2_ESP32S3-R8.png`; burn tool ChipType ESP32-S3 |
| Second MCU | ESP32-U4WDH (audio / UART bridge roles) | schematic `V2.0\3_ESP32-CHIP.png`; separate factory bin `ESP32_1.85KNOB.bin` |
| Flash | 16 MB external W25Q128 on S3 | schematic `V2.0\2_ESP32S3-R8.png`; Arduino screenshot Flash Size 16MB |
| PSRAM | 8 MB (OPI) | PDF p.3 (“8MB PSRAM”); Arduino screenshot PSRAM = OPI PSRAM |
| Dual USB data pairs on USB-C | Confirmed in schematic | `V1.0\JC3636K518_Power.png` USB_DP/DN and USB_DP2/DN2; `V2.0\1_LCD&POWER.png` USB vs USB_ESP32 nets |

**Community lead (verify on unit):** USB-C orientation selects which MCU appears on the host — [prompt-knob usb-flashing.md](https://github.com/andrew-malitchuk/prompt-knob-firmware/blob/main/docs/hardware/usb-flashing.md). Schematic dual D+/D− pairs support this as a plausible mechanism; not a factory-written procedure in the EN PDF text.

## 3. Display

| Item | Value | Evidence |
|------|-------|----------|
| Resolution | 360×360 | PDF p.4; demo `SCREEN_RES_HOR/VER` in `scr_st77916.h` |
| Controller | ST77916 | PDF p.4; demo `ESP_PanelLcd_ST77916` |
| Interface | QSPI | schematic LCD_QSPI_*; demo `ESP_PanelBusQSPI` |
| CS | GPIO 14 | `pincfg.h` L7; schematic LCD_QSPI_CS |
| CLK | GPIO 13 | `pincfg.h` L8; schematic LCD_QSPI_SCL |
| D0–D3 | GPIO 15,16,17,18 | `pincfg.h` L9–L12 |
| RST | GPIO 21 | `pincfg.h` L6 |
| TE | GPIO 0 labeled LCD_TE on S3 schematic | `V2.0\2_ESP32S3-R8.png` (also BOOT strap — careful) |

Init sequence: large vendor command table in manufacturer `scr_st77916.h` and Knobby `scr_st77916.h` (same ST77916 family sequence pattern).

## 4. Touch

| Item | Value | Evidence |
|------|-------|----------|
| Controller | CST816 / CST816S | PDF p.4; demo `ESP_PanelTouch_CST816S` |
| I²C address | 0x15 (library default; commented override) | demo `scr_st77916.h` around `configI2C_Address(0x15)` comment |
| SDA | GPIO 11 | `pincfg.h` L19 |
| SCL | GPIO 12 | `pincfg.h` L18 |
| INT | GPIO 9 | `pincfg.h` L20 |
| RST | GPIO 10 | `pincfg.h` L21 |

## 5. Encoder / button

| Item | Value | Evidence |
|------|-------|----------|
| Encoder A | GPIO 8 | `pincfg.h` L23 `ROTARY_ENC_PIN_A` |
| Encoder B | GPIO 7 | `pincfg.h` L24 `ROTARY_ENC_PIN_B` |
| Pull-ups | 10k to 3V3 on EC1_A/B | `V2.0\1_LCD&POWER.png` |
| Second encoder EC2 | on ESP32 IO19/IO22 | `V2.0\3_ESP32-CHIP.png` — not used by S3 demo |
| `BTN_PIN` | GPIO 0 | `pincfg.h` L13/L16 — this is the **BOOT** strap / boot button path, **not** confirmed as a knob-press switch in the S3 demo |

## 6. Backlight / power enables

| Item | Value | Evidence |
|------|-------|----------|
| Backlight PWM | GPIO 47 `TFT_BLK` / `LCD_BLK` | `pincfg.h` L4; MOSFET AO3400A on `V2.0\1_LCD&POWER.png` |
| Separate LCD/touch power-enable GPIO | Not found as a dedicated enable pin in S3 `pincfg.h` | Display powered from 3V3 rail in schematic |

## 7. Battery / charging / sleep

| Item | Value | Evidence |
|------|-------|----------|
| Charger | TP4055 | `V1.0\JC3636K518_Power.png` |
| Power slide switch | Present | same schematic SW2 |
| Battery connector | 2-pin WAFER | same schematic CN3 |
| Battery ADC | GPIO 1 `BATT_ADC` | S3 schematic; demo/Knobby use pin 1 |
| Divider | Two equal 10k resistors (1:2) on `V2.0\4_OTHER.png` | Community docs claim `V_adc = V_bat / 2`; **confirm net source (VBAT vs 5V) on physical board / clearer PDF before trusting calibration** |
| Sleep API support | Software-side only in Knobby | Not a manufacturer feature claim in the EN PDF |

## 8. Upload / recovery

| Item | Value | Evidence |
|------|-------|----------|
| S3 factory image | `9-Burn\...\ESP32_S3_1.85KNOB.bin` @ **0x0**, QIO, 80 MHz in tool UI | burn screenshots |
| ESP32 factory image | `ESP32_1.85KNOB.bin` @ **0x0**, DIO, 80 MHz | burn screenshots |
| Tool | `flash_download_tool_3.9.3` | `9-Burn\` |
| Arduino board | ESP32S3 Dev Module | Getting started PDF; Arduino configuration.png |
| Flash mode (Arduino Tools screenshot) | QIO **120 MHz**, 16MB, OPI PSRAM, Huge APP | Arduino configuration.png — **build preference only**; pins do not prove clock rate. Factory S3 download UI shows **80 MHz QIO**. See `FLASH_MODE.md`. |
| TF card content for factory UI | `TF Card\` tree | package |

**Partition layout of factory merged bin:** not documented as a CSV in the package; recovery guidance is “reflash merged bin at 0x0”, not a piecemeal partition restore.

## 9. Toolchain (manufacturer)

| Item | Package claim | Notes |
|------|---------------|-------|
| Arduino | ≥ 3.0.1 | `Compilation instructions.txt`; Getting started also shows 1.8.19 install path (stale text) |
| ESP32 core | screenshot shows 3.1.0 installed | `esp32 Version.png` |
| LVGL | ≤ 8.4.0 | Compilation instructions |
| ESP32_Display_Panel | 0.1.4 (txt) **or** 1.0.1 (screenshot / Getting started) | **Internal contradiction** |
| ESP32_IO_Expander | 0.0.2 (txt) **or** 1.1.0 (screenshot) | **Internal contradiction** |

Knobby upstream pins: `lvgl@8.3.11`, `ESP32_Display_Panel@1.0.0`, `ESP32_IO_Expander@1.0.1`, `esp-lib-utils@0.1.2` (`Makefile`).
