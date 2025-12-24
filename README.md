![Windows 11 Xbox Controller Wake](assets/banner.png)

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support-%23FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/socal370xs)
[![Windows](https://img.shields.io/badge/Windows-11-blue)](https://www.microsoft.com/windows)
[![Xbox](https://img.shields.io/badge/Xbox-Controller-green)](https://www.xbox.com)
[![PowerShell](https://img.shields.io/badge/Script-PowerShell-blue)](https://learn.microsoft.com/powershell/)
[![License](https://img.shields.io/badge/license-MIT-purple)](/LICENSE)


# Console-Style PC Wizard
**Turn Windows 11 into an Xbox-style console with controller wake, classic S3 sleep, and auto-login.**
Created by **SoCal IT** - https://github.com/socalit

---

## Why I Built This
Windows 11 keeps stripping away options that made classic sleep work reliably:

- No clear S3 Sleep toggle
- Modern Standby (S0ix) replacing true deep sleep
- Login prompts when waking from sleep
- Broken or inconsistent USB power management
- Controller wake not working reliably

I built this project because I want my PC to behave like an Xbox console:

- Press Xbox button -> PC wakes instantly
- No login screen
- Instant sleep / instant-on behavior
- Controller wake via the **official Xbox Wireless Adapter** (best results)
  - Amazon affiliate link: https://amzn.to/4i0bjEW
- No Modern Standby issues

Microsoft removed many of these options from the UI - this wizard brings them back.

---

# Requirements

## Best / Recommended Setup (Xbox-style wake)
To enable console-style controller wake, you should have:

### Xbox Wireless Adapter for Windows (USB dongle)
(Not Bluetooth - Bluetooth cannot reliably wake a PC on many systems.)

### Xbox One / Series X/S Wireless Controller

### Windows 10/11 PC with S3 Sleep enabled in BIOS
If S3 is missing, the script will explain how to enable it.

## Other 2.4 GHz dongles (SCUF / 8BitDo / etc.)
Some third-party 2.4 GHz receivers may NOT support wake-from-sleep at all.
This is usually a driver/firmware limitation, not a script limitation.

Use **Option [6]** in the wizard to check whether Windows reports your receiver as wake-capable.

---

# What's New (v1.0.2)
- Fixes WMIC issues that caused:
  - "Invalid XSL format (or) file name" errors on some systems
  - Missed detection when WMIC output escaped `&` as `&amp;`
- Improves Xbox Wireless Adapter detection by matching PID values (so `&` vs `&amp;` does not break detection)
- Adds **Option [6] Universal Dongle Wake Compatibility Check** to help validate SCUF/8BitDo/other receivers

---

# Features

## 1. Console-Style Sleep Setup
- Enables or enforces Classic S3 Sleep
- Disables Modern Standby (S0ix) via registry override
- Applies console-style sleep & display timeouts
- Helps configure controller wake
- Gives BIOS instructions if S3 is disabled

## 2. Controller Wake (Xbox)
Configures your system so pressing the Xbox button can wake your PC (when the hardware/driver supports it).

## 3. Universal Dongle Wake Compatibility Check (Option [6])
For non-Xbox 2.4 GHz dongles (SCUF / 8BitDo / etc.), this tool checks what Windows can actually arm for wake.

It shows:
- `wake_from_any` (devices Windows can arm for wake)
- `wake_programmable` (devices that may support wake depending on driver/firmware)
- `wake_armed` (devices currently enabled to wake the PC)

Important:
- If your receiver is NOT listed under `wake_from_any` (or at least `wake_programmable`), Windows usually cannot enable wake for it by script.
- If it IS listed, you may be able to enable wake (either via the script or Device Manager power settings).

## 4. Auto Login (Console-Style Startup)
- Skips the Windows login screen
- Uses Windows AutoAdminLogon
- Disables "Require sign-in on wake"
- Fully reversible

## 5. Full Revert Menu
Restore everything back to default Windows behavior:
- Remove Modern Standby override
- Re-enable password prompts
- Restore timeouts
- Disable controller wake (where applicable)
- Disable auto-login settings

## 6. Intelligent Xbox Wireless Adapter Detection (v1.0.2 hardened)
This wizard uses hardware VID/PID detection for official Microsoft adapters:

| Adapter | VID | PID |
|--------|------|------|
| Xbox Wireless Adapter (Model 1790) | 045E | 02FE |
| Xbox Wireless Adapter (Model 1713) | 045E | 0B05 |
| Additional official revisions | 045E | 02E6 / 02F9 / 091E |

Note: v1.0.2 avoids WMIC formatting issues and handles `&amp;` escaping, improving detection reliability.

---

# How to Use

## 1. Download the script
`ConsoleStylePCWizard_1.0.2.cmd`

## 2. Right-click -> Run as administrator

## 3. Choose an option

```bash
[1] Full Setup (Sleep + Auto Login + Wake)
[2] Sleep Only
[3] Auto Login Only
[4] Revert Sleep Tweaks
[5] Disable Auto Login
[6] Universal Dongle Wake Compatibility Check (SCUF/8BitDo/etc.)
[7] Exit
```

## 4. If S3 is not enabled
You will see a message explaining how to turn it on in BIOS/UEFI.

## 5. Follow the prompts
Color-coded interface:
- Green -> Success
- Red   -> Errors / Warnings
- White -> Info
- Theme -> Green text on black background

---

# Security Notice (Plaintext Password)
If you enable Auto Login:
- Your password is stored as plaintext in the registry
- This is Microsoft's built-in AutoAdminLogon behavior
- Only use this on a personal gaming PC you fully control

Do not use Auto Login on:
- Work PCs
- Domain-joined systems
- Shared computers

---

# BIOS Requirements for S3 Sleep
If your PC does not support S3 sleep, the wizard explains how to enable it.

Common BIOS options:
- ACPI Sleep State -> S3
- Legacy S3 Mode
- Suspend Mode -> S3 Only
- Disable S0 Low Power Idle
- Disable Modern Standby

Most desktop motherboards support S3.
Some OEM laptops may permanently remove S3 support.

---

# License
MIT License - free to use, modify, and redistribute.

---

# Support the Project
If this tool helped you:

### ⭐ **Star the GitHub repo**  
### Share it with PC gaming communities  
### Open issues or request features  

If this project saved you time or solved a problem, consider supporting development:

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&slug=socal370xs&button_colour=FFDD00&font_colour=000000&font_family=Arial&outline_colour=000000&coffee_colour=ffffff)](https://buymeacoffee.com/socal370xs)



I built this because I wanted console behavior on Windows, and I know many others do too.
