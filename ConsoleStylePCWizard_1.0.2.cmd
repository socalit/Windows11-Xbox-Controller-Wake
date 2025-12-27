```bat
@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Console-Style PC Wizard (Windows 11) v1.0.2
call :ColorNormal

:: ===========================================================
::  CONSOLE-STYLE PC SLEEP + LOGIN WIZARD
::  Version: v1.0.2 + Universal Dongle Wake Check
::  Open Source: https://github.com/socalit
::
::  Primary target:
::   - Official Xbox Wireless Adapter + Xbox Wireless Controller (best results)
::
::  Added:
::   - Universal dongle wake compatibility check (SCUF/8BitDo/etc.)
::
::  v1.0.2 Fix:
::   - Robust Xbox Wireless Adapter detection (avoids WMIC /format:list XSL errors)
::   - Works when WMIC output escapes "&" as "&amp;" by matching PID values
:: ===========================================================

::---------------------------
:: ADMIN CHECK
::---------------------------
net session >nul 2>&1
if errorlevel 1 goto NOT_ADMIN

set "CUR_USER=%USERNAME%"
set "CUR_PC=%COMPUTERNAME%"

:MAIN_MENU
call :ColorNormal
cls
echo ============================================================
echo              CONSOLE-STYLE PC CONFIGURATION WIZARD
echo ------------------------------------------------------------
echo                    Windows 11 Edition v1.0.2
echo ------------------------------------------------------------
echo         Open Source Project  ^|  https://github.com/socalit
echo ============================================================
echo.
echo NOTE:
echo   - Best results: Official Xbox Wireless Adapter + Xbox controller.
echo   - Other 2.4 GHz dongles (SCUF/8BitDo/etc.) may NOT support wake.
echo   - Use option [6] to check if your dongle is wake-capable in Windows.
echo.
echo Current user: %CUR_USER%
echo Machine    : %CUR_PC%
echo.
echo   [1] Full Setup:
echo       - Console-style sleep (S3, timeouts, controller wake)
echo       - Auto login
echo       - Disable "require sign-in on wake"
echo.
echo   [2] Setup console-style sleep only
echo   [3] Setup console-style auto login only
echo   [4] Revert sleep tweaks
echo   [5] Disable auto login and restore sign-in on wake
echo   [6] Universal dongle wake compatibility check (SCUF/8BitDo/etc.)
echo   [7] Exit
echo.
echo ------------------------------------------------------------
echo   Source Code: https://github.com/socalit
echo ------------------------------------------------------------
echo.
set "choice="
set /p choice="Select an option [1-7]: "

if "%choice%"=="1" (
    set "SLEEP_NEXT=AUTO"
    goto SLEEP_S3_CHECK
)
if "%choice%"=="2" (
    set "SLEEP_NEXT=MAIN"
    goto SLEEP_S3_CHECK
)
if "%choice%"=="3" goto ENABLE_AUTOLOGIN
if "%choice%"=="4" goto UNINSTALL_SLEEP
if "%choice%"=="5" goto DISABLE_AUTOLOGIN
if "%choice%"=="6" goto UNIVERSAL_WAKE_CHECK
if "%choice%"=="7" goto END

call :ColorError
echo.
echo [X] Invalid choice. Please type 1, 2, 3, 4, 5, 6, or 7.
call :ColorNormal
echo.
pause
goto MAIN_MENU


::============================================================
::  SLEEP SETUP (S3 + WAKE + TIMEOUTS)
::============================================================

:SLEEP_S3_CHECK
call :ColorNormal
cls
echo ============================================================
echo                    SYSTEM SLEEP CAPABILITY CHECK
echo ============================================================
echo.
echo Checking for Standby (S3) support...
echo.

powercfg /a | findstr /I "Standby (S3)" >nul
if errorlevel 1 goto NO_S3

call :ColorInfo
echo [OK] Standby (S3) detected.
call :ColorNormal
echo.
echo Press any key to continue to Modern Standby override...
pause >nul
goto SLEEP_MS_OVERRIDE


:SLEEP_MS_OVERRIDE
call :ColorNormal
cls
echo ============================================================
echo           DISABLING MODERN STANDBY (PREFER S3 SLEEP)
echo ============================================================
echo.
echo Applying PlatformAoAcOverride = 0 ...
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" ^
 /v PlatformAoAcOverride /t REG_DWORD /d 0 /f >nul

if errorlevel 1 (
    call :ColorError
    echo [WARN] Could not modify Modern Standby override.
    call :ColorNormal
) else (
    call :ColorInfo
    echo [OK] Modern Standby override applied.
    call :ColorNormal
)

echo.
echo Press any key to choose power mode...
pause >nul
goto SLEEP_MODE_CHOICE


:SLEEP_MODE_CHOICE
set "XBOX_INSTANT_ON="

:SLEEP_MODE_LOOP
call :ColorNormal
cls
echo ============================================================
echo                POWER MODE SELECTION
echo ============================================================
echo.
echo  [1] Console Instant-On  (Hibernate OFF)
echo  [2] Standard Sleep      (Hibernate ON)
echo.
set "modeChoice="
set /p modeChoice="Select [1/2]: "

if "%modeChoice%"=="1" set "XBOX_INSTANT_ON=1"
if "%modeChoice%"=="2" set "XBOX_INSTANT_ON=0"

if not defined XBOX_INSTANT_ON (
    call :ColorError
    echo.
    echo [X] Invalid choice. Please type 1 or 2.
    call :ColorNormal
    echo.
    pause
    goto SLEEP_MODE_LOOP
)

call :ColorNormal
cls
echo ============================================================
echo                POWER MODE SELECTION
echo ============================================================
echo.
echo Selected mode:
echo.
if "%XBOX_INSTANT_ON%"=="1" (
    call :ColorInfo
    echo   Console Instant-On (Hibernate OFF)
    call :ColorNormal
) else (
    call :ColorInfo
    echo   Standard Sleep (Hibernate ON)
    call :ColorNormal
)
echo.
echo Press any key to continue to Hibernate settings...
pause >nul
goto SLEEP_HIBERNATE


:SLEEP_HIBERNATE
call :ColorNormal
cls
echo ============================================================
echo                HIBERNATE CONFIGURATION
echo ============================================================
echo.

if "%XBOX_INSTANT_ON%"=="1" (
    echo Disabling Hibernate...
    powercfg -hibernate off >nul
    if errorlevel 1 (
        call :ColorError
        echo [WARN] Could not disable Hibernate.
        call :ColorNormal
    ) else (
        call :ColorInfo
        echo [OK] Hibernate disabled.
        call :ColorNormal
    )
) else (
    call :ColorInfo
    echo Hibernate left enabled.
    call :ColorNormal
)

echo.
echo NEXT: USB selective suspend instructions (manual steps).
echo.
echo Press any key to continue...
pause >nul
goto SLEEP_USB_NOTE


:SLEEP_USB_NOTE
call :ColorNormal
cls
echo ============================================================
echo         USB SELECTIVE SUSPEND (MANUAL RECOMMENDATION)
echo ============================================================
echo.
call :ColorInfo
echo Automatic USB selective suspend changes can fail on some
echo systems, so this wizard does not change it by script.
call :ColorNormal
echo.
echo To help keep your wireless dongle powered and responsive,
echo disable USB selective suspend manually:
echo.
echo   1) Control Panel -> Power Options
echo   2) "Change plan settings" on your active plan
echo   3) "Change advanced power settings"
echo   4) Expand "USB settings"
echo   5) Expand "USB selective suspend setting"
echo   6) Set all options to: Disabled
echo.
echo Press any key to continue to sleep timeouts...
pause >nul
goto SLEEP_TIMEOUTS


:SLEEP_TIMEOUTS
call :ColorNormal
cls
echo ============================================================
echo                 SLEEP TIMEOUTS (AC POWER)
echo ============================================================
echo.
echo Applying:
echo   Display off (AC) = 15 minutes
echo   Sleep      (AC)  = 30 minutes
echo.

powercfg /change monitor-timeout-ac 15 >nul
powercfg /change standby-timeout-ac 30 >nul

if errorlevel 1 (
    call :ColorError
    echo [WARN] Timeout change failed.
    call :ColorNormal
) else (
    call :ColorInfo
    echo [OK] Timeouts applied.
    call :ColorNormal
)

echo.
echo Press any key to continue to controller wake setup...
pause >nul
goto SLEEP_XBOX_WAKE


:SLEEP_XBOX_WAKE
call :ColorNormal
cls
echo ============================================================
echo              CONTROLLER WAKE CONFIGURATION
echo ============================================================
echo.
echo Step 1: Detecting Xbox Wireless Adapter (USB dongle)...
echo.

call :DetectXboxDongle

if "%DongleFound%"=="1" (
    call :ColorInfo
    echo [OK] Xbox Wireless Adapter detected via USB VID/PID.
    call :ColorNormal
    echo.
) else (
    call :ColorError
    echo [WARN] No Xbox Wireless Adapter detected via USB scan.
    call :ColorNormal
    echo.
    echo Make sure:
    echo   - You are using the official Xbox Wireless Adapter
    echo   - The dongle is plugged in directly or via a powered hub
    echo   - Windows has installed the Xbox accessories driver
    echo.
)

echo Step 2: Looking for Xbox / wireless controller devices that can
echo         wake the PC (name-based check)...
echo.

set "foundXbox=0"

for /f "tokens=* delims=" %%D in ('
    powercfg -devicequery wake_from_any ^| findstr /I "Xbox"
') do (
    echo Enabling wake on: %%D
    powercfg -deviceenablewake "%%D" >nul
    set "foundXbox=1"
)

echo.
if "%foundXbox%"=="0" (
    call :ColorError
    echo [WARN] No Xbox-related wake-capable devices were found.
    call :ColorNormal
    echo.
    echo If your dongle is not listed, open Device Manager and:
    echo   - Find the Xbox Wireless Adapter / controller
    echo   - Properties -> Power Management
    echo   - Check "Allow this device to wake the computer"
    echo.
    echo TIP: Option [6] can verify whether Windows sees any dongle
    echo      that is wake-capable (universal check).
) else (
    call :ColorInfo
    echo [OK] Wake enabled on listed Xbox / controller devices.
    call :ColorNormal
)

echo.
echo Reminder:
echo   - You need an Xbox controller paired to the Xbox dongle
echo     for wake to behave like a console.
echo.
echo Press any key for final sleep summary...
pause >nul
goto SLEEP_SUMMARY


:SLEEP_SUMMARY
call :ColorNormal
cls
echo ============================================================
echo                 SLEEP SETUP COMPLETE
echo ============================================================
echo.
echo Available sleep states:
echo ------------------------------------------------------------
powercfg /a
echo ------------------------------------------------------------
echo.
echo Mode applied:
if "%XBOX_INSTANT_ON%"=="1" (
    call :ColorInfo
    echo   Console Instant-On (Hibernate OFF)
    call :ColorNormal
)
if "%XBOX_INSTANT_ON%"=="0" (
    call :ColorInfo
    echo   Standard Sleep (Hibernate ON)
    call :ColorNormal
)
echo.
echo Remember:
echo   - USB selective suspend should be disabled manually.
echo   - You need an Xbox Wireless Adapter + controller for
echo     wake to behave like an actual console.
echo.
if /I "%SLEEP_NEXT%"=="AUTO" (
    echo Next: console-style auto login wizard.
    echo.
    echo Press any key to continue to auto login setup...
    pause >nul
    goto ENABLE_AUTOLOGIN
) else (
    echo Press any key to return to main menu...
    pause >nul
    goto MAIN_MENU
)


::============================================================
::  REVERT SLEEP TWEAKS
::============================================================

:UNINSTALL_SLEEP
call :ColorNormal
cls
echo ============================================================
echo           REVERT SLEEP CONFIGURATION
echo ============================================================
echo.
echo This will attempt to revert:
echo   - Modern Standby override
echo   - Hibernate state
echo   - Sleep timeouts
echo   - Controller/Xbox wake permissions
echo.
set "confirmSleep="
set /p confirmSleep="Continue and revert sleep tweaks? [Y/N]: "
if /I "%confirmSleep%" NEQ "Y" (
    echo.
    echo Sleep tweaks not changed.
    pause
    goto MAIN_MENU
)

cls
echo Removing Modern Standby override (PlatformAoAcOverride)...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v PlatformAoAcOverride /f >nul 2>&1

echo Re-enabling Hibernate...
powercfg -hibernate on >nul

echo Resetting AC timeouts (Display 20m, Sleep 60m)...
powercfg /change monitor-timeout-ac 20 >nul
powercfg /change standby-timeout-ac 60 >nul

echo.
echo Disabling wake on Xbox devices (if armed)...
set "foundWake=0"

for /f "tokens=* delims=" %%D in ('
    powercfg -devicequery wake_armed ^| findstr /I "Xbox"
') do (
    echo Disabling wake for: %%D
    powercfg -devicedisablewake "%%D" >nul
    set "foundWake=1"
)

if "%foundWake%"=="0" (
    call :ColorInfo
    echo No wake-armed Xbox devices were found.
    call :ColorNormal
)

call :ColorInfo
echo.
echo [OK] Sleep tweaks reverted.
call :ColorNormal
echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU


::============================================================
::  AUTO LOGIN (+ SIGN-IN ON WAKE)
::============================================================

:ENABLE_AUTOLOGIN
call :ColorNormal
cls
echo ============================================================
echo             ENABLE AUTO LOGIN (CONSOLE-STYLE)
echo ============================================================
echo.
call :ColorInfo
echo WARNING:
echo   - Windows will automatically sign in user "%CUR_USER%" at boot.
echo   - Your password will be stored in the registry in PLAIN TEXT
echo     (Windows AutoAdminLogon behavior).
echo   - Only use this on a personal console-style PC you fully
echo     control (no shared or domain PCs).
call :ColorNormal
echo.
echo PC Name: %CUR_PC%
echo User   : %CUR_USER%
echo.
set "confirm="
set /p confirm="Enable auto login for this user? [Y/N]: "
if /I "%confirm%" NEQ "Y" (
    echo.
    echo Auto login not enabled.
    pause
    goto MAIN_MENU
)

call :ColorNormal
cls
echo ============================================================
echo          ENTER WINDOWS PASSWORD FOR AUTO LOGIN
echo ============================================================
echo.
echo Type the password for user "%CUR_USER%".
call :ColorInfo
echo NOTE:
echo   - Characters WILL be visible as you type.
echo   - This password will be saved in the registry.
call :ColorNormal
echo.
set "USER_PWD="
set /p USER_PWD="Password: "

if "%USER_PWD%"=="" (
    call :ColorError
    echo.
    echo [X] Empty password. Aborting auto login setup.
    call :ColorNormal
    echo.
    pause
    goto MAIN_MENU
)

call :ColorNormal
cls
echo ============================================================
echo       APPLYING AUTO LOGIN SETTINGS
echo ============================================================
echo.

set "WINLOGON_KEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

reg add "%WINLOGON_KEY%" /v AutoAdminLogon      /t REG_SZ /d 1 /f >nul
reg add "%WINLOGON_KEY%" /v DefaultUserName     /t REG_SZ /d "%CUR_USER%" /f >nul
reg add "%WINLOGON_KEY%" /v DefaultDomainName   /t REG_SZ /d . /f >nul
reg add "%WINLOGON_KEY%" /v DefaultPassword     /t REG_SZ /d "%USER_PWD%" /f >nul

call :ColorInfo
echo [OK] Auto login configured for: %CUR_USER%
call :ColorNormal
echo.

echo Adjusting wake behavior: disabling sign-in requirement...
echo.

set "CUR_SCHEME="

for /f "tokens=3" %%G in ('powercfg /getactivescheme') do (
    set "CUR_SCHEME=%%G"
)

if not defined CUR_SCHEME (
    call :ColorError
    echo [WARN] Could not read active power scheme. Skipping wake sign-in tweak.
    call :ColorNormal
) else (
    powercfg /SETACVALUEINDEX %CUR_SCHEME% SUB_NONE CONSOLELOCK 0 >nul
    powercfg /SETDCVALUEINDEX %CUR_SCHEME% SUB_NONE CONSOLELOCK 0 >nul
    powercfg /SETACTIVE %CUR_SCHEME% >nul

    if errorlevel 1 (
        call :ColorError
        echo [WARN] powercfg could not change sign-in on wake.
        call :ColorNormal
        echo        You may need to set it manually:
        echo        Settings -> Accounts -> Sign-in options ->
        echo        "If you have been away..." -> Never.
    ) else (
        call :ColorInfo
        echo [OK] "Require sign-in on wake" disabled for active power plan.
        call :ColorNormal
    )
)

echo.
echo On next boot, Windows should:
echo   - Skip the login screen (auto login)
echo   - Resume from sleep without asking for a password
echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU


:DISABLE_AUTOLOGIN
call :ColorNormal
cls
echo ============================================================
echo        DISABLE AUTO LOGIN / RESTORE SIGN-IN ON WAKE
echo ============================================================
echo.
echo This will:
echo   - Turn off AutoAdminLogon
echo   - Remove the stored DefaultPassword value
echo   - Re-enable "require sign-in on wake" for the active plan
echo.
set "confirm2="
set /p confirm2="Disable auto login and restore sign-in on wake? [Y/N]: "
if /I "%confirm2%" NEQ "Y" (
    echo.
    echo Auto login not changed.
    pause
    goto MAIN_MENU
)

set "WINLOGON_KEY=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

reg add "%WINLOGON_KEY%" /v AutoAdminLogon /t REG_SZ /d 0 /f >nul
reg delete "%WINLOGON_KEY%" /v DefaultPassword /f >nul 2>&1

call :ColorInfo
echo [OK] Auto login disabled and password entry removed.
call :ColorNormal
echo.

echo Restoring sign-in requirement on wake (sleep / hibernate)...
echo.

set "CUR_SCHEME="

for /f "tokens=3" %%G in ('powercfg /getactivescheme') do (
    set "CUR_SCHEME=%%G"
)

if not defined CUR_SCHEME (
    call :ColorError
    echo [WARN] Could not read active power scheme. Skipping wake sign-in restore.
    call :ColorNormal
) else (
    powercfg /SETACVALUEINDEX %CUR_SCHEME% SUB_NONE CONSOLELOCK 1 >nul
    powercfg /SETDCVALUEINDEX %CUR_SCHEME% SUB_NONE CONSOLELOCK 1 >nul
    powercfg /SETACTIVE %CUR_SCHEME% >nul

    if errorlevel 1 (
        call :ColorError
        echo [WARN] powercfg could not restore sign-in on wake.
        call :ColorNormal
        echo        You can re-enable it manually in Settings.
    ) else (
        call :ColorInfo
        echo [OK] "Require sign-in on wake" restored for active power plan.
        call :ColorNormal
    )
)

echo.
echo You will be prompted to sign in again after reboot and on wake.
echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU


::============================================================
::  UNIVERSAL DONGLE WAKE COMPATIBILITY CHECK
::  - Shows what Windows can arm for wake (wake_from_any / wake_programmable)
::  - Resolves devices to InstanceId/DeviceID and flags likely USB dongles
::  - Writes a report file: wake-report.txt (same folder as this .bat)
::============================================================

:UNIVERSAL_WAKE_CHECK
call :ColorNormal
cls
echo ============================================================
echo        UNIVERSAL DONGLE WAKE COMPATIBILITY CHECK
echo ============================================================
echo.
echo This checks what Windows can actually arm for wake.
echo If your 2.4 GHz dongle is NOT in wake_from_any / wake_programmable,
echo Windows cannot enable wake for it by script.
echo.
echo A report will be saved as: wake-report.txt
echo.
echo Press any key to run the scan...
pause >nul

where powershell >nul 2>&1
if errorlevel 1 (
    call :ColorError
    echo.
    echo [X] PowerShell not found. Cannot run universal wake scan.
    call :ColorNormal
    echo.
    pause
    goto MAIN_MENU
)

set "PS_TMP=%temp%\wake_check_%random%%random%.ps1"
set "LOG=%~dp0wake-report.txt"

> "%PS_TMP%" (
echo param([string]$LogPath^)
echo $ErrorActionPreference = 'SilentlyContinue'
echo.
echo function Get-WakeList([string]$which^) {
echo   $out = ^& powercfg -devicequery $which 2^>$null
echo   if(-not $out^) { return @(^) }
echo   return $out ^| Where-Object { $_ -and $_.Trim(^) -ne "" }
echo }
echo.
echo function Get-DeviceByName([string]$name^) {
echo   # Prefer Get-PnpDevice (best on Win10/11^), fallback to CIM.
echo   $d = Get-PnpDevice -FriendlyName $name -ErrorAction SilentlyContinue ^| Select-Object -First 1
echo   if($d^) { return $d }
echo.
echo   $safe = $name.Replace("'","''"^)
echo   $d2 = Get-CimInstance Win32_PnPEntity -Filter ("Name='{0}'" -f $safe^) -ErrorAction SilentlyContinue ^| Select-Object -First 1
echo   return $d2
echo }
echo.
echo $wakeFromAny = Get-WakeList "wake_from_any"
echo $wakeProgrammable = Get-WakeList "wake_programmable"
echo $wakeArmed = Get-WakeList "wake_armed"
echo.
echo if($LogPath^) {
echo   "wake_from_any:" ^| Out-File -FilePath $LogPath -Encoding UTF8
echo   $wakeFromAny ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   "" ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   "wake_programmable:" ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   $wakeProgrammable ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   "" ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   "wake_armed:" ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo   $wakeArmed ^| Out-File -FilePath $LogPath -Append -Encoding UTF8
echo }
echo.
echo Write-Host "============================================================"
echo Write-Host "                UNIVERSAL WAKE REPORT"
echo Write-Host "============================================================"
echo Write-Host ""
echo Write-Host ("Report saved to: {0}" -f $LogPath^)
echo Write-Host ""
echo.
echo Write-Host "Wake-from-any devices (can be armed):"
echo if($wakeFromAny.Count -eq 0^) { Write-Host "  (none reported)" } else { $wakeFromAny ^| ForEach-Object { Write-Host ("  - " + $_^) } }
echo Write-Host ""
echo Write-Host "Wake-programmable devices (driver/firmware may allow):"
echo if($wakeProgrammable.Count -eq 0^) { Write-Host "  (none reported)" } else { $wakeProgrammable ^| ForEach-Object { Write-Host ("  - " + $_^) } }
echo Write-Host ""
echo Write-Host "Wake-armed devices (currently enabled):"
echo if($wakeArmed.Count -eq 0^) { Write-Host "  (none armed)" } else { $wakeArmed ^| ForEach-Object { Write-Host ("  - " + $_^) } }
echo.
echo Write-Host ""
echo Write-Host "Resolved device IDs (flags likely USB dongles):"
echo Write-Host "  [USB-WAKE-OK] = USB device that Windows says can wake the PC"
echo Write-Host "  [BT/RADIO]    = Bluetooth stack/radio (wake behavior varies)"
echo Write-Host "  [OTHER]       = other bus/class device"
echo Write-Host ""
echo.
echo foreach($n in $wakeFromAny^) {
echo   $d = Get-DeviceByName $n
echo   if($null -eq $d^) {
echo     Write-Host ("[UNRESOLVED] " + $n^)
echo     continue
echo   }
echo.
echo   $id = $d.InstanceId
echo   if(-not $id^) { $id = $d.DeviceID }
echo.
echo   $cls = $d.Class
echo   if(-not $cls^) { $cls = $d.PNPClass }
echo.
echo   $tag = "OTHER"
echo   if($id -like "USB\VID_*"^) { $tag = "USB-WAKE-OK" }
echo   elseif($id -like "BTH*" -or $id -like "Bluetooth*"^) { $tag = "BT/RADIO" }
echo.
echo   Write-Host ("[{0}] {1}" -f $tag, $n^)
echo   if($id^)  { Write-Host ("     ID:    {0}" -f $id^) }
echo   if($cls^) { Write-Host ("     Class: {0}" -f $cls^) }
echo }
echo.
echo Write-Host ""
echo Write-Host "------------------------------------------------------------"
echo Write-Host "Interpretation:"
echo Write-Host " - If your wireless dongle/receiver does NOT show up under"
echo Write-Host "   wake_from_any, Windows cannot arm it for wake by script."
echo Write-Host " - If it DOES show up (especially flagged USB-WAKE-OK), you can"
echo Write-Host "   enable wake using powercfg -deviceenablewake ""<device name>"""
echo Write-Host "------------------------------------------------------------"
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_TMP%" -LogPath "%LOG%"
del "%PS_TMP%" >nul 2>&1

echo.
call :ColorInfo
echo [OK] Report saved to: %LOG%
call :ColorNormal
echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU


::============================================================
::  ERROR HANDLERS
::============================================================

:NOT_ADMIN
call :ColorError
cls
echo ============================================================
echo                    ERROR: NOT RUN AS ADMIN
echo ============================================================
echo.
echo This wizard must be run as Administrator.
echo.
echo Right-click the .BAT file and choose:
echo     "Run as administrator"
echo.
pause >nul
goto END


:NO_S3
call :ColorError
cls
echo ============================================================
echo             S3 SLEEP NOT ENABLED IN BIOS/UEFI
echo ============================================================
echo.
call :ColorInfo
echo Your PC does not currently report support for Classic Sleep (S3).
call :ColorNormal
echo.
echo Console-style sleep works best when S3 is enabled in BIOS/UEFI.
echo Modern Standby-only systems will not behave like an Xbox.
echo.
echo To enable S3 sleep on most systems:
echo ------------------------------------------------------------
echo  1. Reboot your PC
echo  2. Enter BIOS/UEFI Setup:
echo       - ASUS:     Press DEL or F2
echo       - MSI:      Press DEL
echo       - Gigabyte: Press DEL
echo       - ASRock:   Press F2 or DEL
echo.
echo  3. Look for one of these options:
echo       - "ACPI Sleep State"
echo       - "Sleep State"
echo       - "Suspend Mode"
echo       - "S3 Only"
echo       - "Legacy S3"
echo       - "Disable Modern Standby"
echo       - "S0 Low Power Idle" (disable this if possible)
echo.
echo  4. Set ACPI Sleep State to:  S3 / Legacy S3
echo  5. Save changes and reboot back into Windows
echo  6. Re-run this wizard
echo ------------------------------------------------------------
echo.
call :ColorInfo
echo NOTE: Some OEM laptops permanently remove S3 support.
echo Desktop motherboards almost always support it.
call :ColorNormal
echo.
echo Press any key to return to main menu...
pause >nul
goto MAIN_MENU


::============================================================
::  XBOX DONGLE DETECTION (v1.0.2 FIX)
::  - Avoids WMIC /format:list to prevent "Invalid XSL format"
::  - Matches PID values so "&" vs "&amp;" output does not matter
::============================================================

:DetectXboxDongle
set "DongleFound=0"

where wmic >nul 2>&1
if errorlevel 1 goto :EOF

for /f "usebackq tokens=* delims=" %%L in (`
  wmic path Win32_PnPEntity where "DeviceID like 'USB\\VID_045E%%'" get DeviceID /value 2^>nul
`) do (
    echo %%L | findstr /I /C:"PID_02E6" /C:"PID_02F9" /C:"PID_02FE" /C:"PID_091E" /C:"PID_0B05" >nul
    if not errorlevel 1 set "DongleFound=1"
)

goto :EOF


::============================================================
::  COLOR HELPERS
::============================================================

:ColorNormal
color 0A
exit /b

:ColorInfo
color 0F
exit /b

:ColorError
color 0C
exit /b


::============================================================
::  SAFE EXIT
::============================================================

:END
call :ColorNormal
echo.
echo ============================================================
echo        Thank you for using Console-Style PC Wizard!
echo ============================================================
echo.
echo   This project is open-source:
echo     https://github.com/socalit
echo.
echo   If this helped you, consider starring the repo.
echo   Your support helps more people find and use the tool.
echo.
echo Press any key to close this window...
pause >nul
endlocal
exit /b 0
```

