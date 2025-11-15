# Console-Style PC Wizard  
**Turn Windows 11 into an Xbox-style console with controller wake, classic sleep, and auto-login.**  
Created by **SoCal IT** — https://github.com/socalit  

---

## Why I Built This
Windows 11 continues stripping away options that made classic sleep easy:

- No clear “S3 Sleep” toggle  
- Modern Standby (S0ix) replacing true deep sleep  
- Login prompts when waking from sleep  
- Hidden/broken USB power settings  
- Xbox controller wake not working consistently  

I built this wizard because I want my PC to behave **exactly like an Xbox console**:

-  Press Xbox button → PC wakes instantly  
-  No login screen  
-  Instant sleep / instant-on behavior  
-  Controller wake via the **official Xbox Wireless Adapter** (dongle) Amazon affiliate link: https://amzn.to/4i0bjEW
-  No Modern Standby nonsense  

Microsoft removed these options from the UI — so this tool brings them back.

---

#  Requirements

To enable console-style controller wake, you **must have**:

###  **Xbox Wireless Adapter for Windows (USB dongle)**  
(Not Bluetooth — Bluetooth controllers cannot reliably wake a PC.)

###  **Xbox One / Series X|S wireless controller**

###  Windows 10/11 PC with **S3 Sleep enabled in BIOS**  
The script will detect if S3 is missing and show clear BIOS instructions.

---

#  Features

##  1. Console-Style Sleep Setup
- Enables or enforces **Classic S3 Sleep**  
- Disables **Modern Standby (S0ix)** via registry override  
- Sets sleep & display timeouts (like a console)  
- Enables **controller wake** using:
  - Name-based device scan  
  - USB VID/PID hardware scan for official Xbox dongle  
- Gives BIOS instructions if S3 is not enabled  

##  2. Controller Wake
Automatically configures your system so you can press **the Xbox button** to wake your PC — just like waking an Xbox console.

##  3. Auto Login (Console-Style Startup)
- Skips Windows login  
- Uses Windows built-in AutoAdminLogon  
- Disables “Require sign-in on wake”  
- **Reversible anytime**

##  4. Full Revert Menu
Restore everything to stock Windows behavior:

- Re-enable Modern Standby  
- Restore timeouts  
- Disable controller wake  
- Disable auto login  
- Re-enable password prompt on wake  

##  5. Intelligent Xbox Wireless Adapter Detection
This wizard uses **two-layer detection**:

###  **1. Name-based detection**  
Finds:
- “Xbox Wireless Adapter for Windows”
- “Xbox Controller”
- “Xbox Wireless Controller”

###  **2. Hardware VID/PID detection**
Detects official dongle hardware:

| Hardware | VID | PID |
|---------|------|------|
| Xbox Wireless Adapter v1 | 045E | 02FE |
| Xbox Wireless Adapter v2 | 045E | 0B05 |

If the dongle is missing, the script explains why and how to fix it.

---

#  How to Use

### 1. Download the script  
`ConsoleStylePCWizard.cmd`

### 2. Right-click → **Run as administrator**

### 3. Choose what you want to configure:
```
[1] Full Setup (Sleep + Auto Login + Wake)
[2] Sleep Only
[3] Auto Login Only
[4] Revert Sleep Tweaks
[5] Disable Auto Login
```

### 4. If S3 is not enabled  
You will get this message:

> “S3 Sleep is not enabled in BIOS.  
> Here is how to turn it on…”

With detailed motherboard-specific BIOS steps.

### 5. Follow the prompts  
Everything is color-coded:

-  Success = Green  
-  Errors / warnings = Red  
-  Information = White  
-  Wizard theme = green on black (console-style)

---

#  Security Notice (Plaintext Password)
If you enable Auto Login:

- Your password is stored as **plaintext** in the Windows registry  
- This is how Microsoft AutoAdminLogon works  
- Do NOT use Auto Login on:
  - Work PCs  
  - Domain PCs  
  - Shared computers  

This tool is intended for **personal gaming rigs only**.

---

#  BIOS Requirements for S3 Sleep
If your PC doesn’t support S3, you’ll be guided to enable it.

Typical BIOS options:

- **ACPI Sleep State → S3**  
- **Legacy S3**  
- **Suspend Mode → S3 Only**  
- **Disable Modern Standby**  
- **Disable S0 Low Power Idle**

Desktop motherboards almost always support S3.

Some laptops permanently disable it.

---

#  License
MIT License — free to use, modify, redistribute.

---

#  Support the Project
If this tool helped you:

###  **Star the GitHub repo**  
###  Share it with other PC gamers  
###  Open issues or feature requests  

I built this because I wanted console behavior back — and I know others do too.
