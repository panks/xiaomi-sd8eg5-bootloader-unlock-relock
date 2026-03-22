@ECHO OFF
cd /d %~dp0bin
TITLE Xiaomi Snapdragon 8E5 One-Click BL Relock
ECHO.
ECHO.[Supported Devices]
ECHO.- In theory: All Xiaomi/Redmi Snapdragon 8 Elite Gen5 processor devices
ECHO.- Xiaomi 17
ECHO.- Xiaomi 17 Pro
ECHO.- Xiaomi 17 Pro Max
ECHO.- Xiaomi 17 Ultra
ECHO.- Redmi K90 Pro Max
ECHO.
ECHO.[Important Notes]
ECHO.- IMPORTANT: Ensure you are on Official region ROM before relocking ELSE YOU WILL BRICK THE DEVICE.
ECHO.- Relocking will automatically erase all user data on the device. Please back up to a computer or cloud in advance.
ECHO.- Before relocking, disable Find My Phone, sign out of your Xiaomi account, delete fingerprint data, and remove the lock screen password.
ECHO.- Compatibility with other devices is not guaranteed. You assume all risk if your device is bricked.
ECHO.- For personal study and research only. Do not use for illegal purposes, or you bear all consequences.
ECHO.
ECHO.If you understand the above, press any key to continue... & pause>nul
ECHO.
ECHO.Please connect your phone to the computer and enable USB debugging...
:A
adb.exe devices | find /v "List of devices attached" | find "device" 1>nul 2>nul || goto A
ECHO.Device connected
ECHO.
ECHO.Device model: & adb.exe shell getprop ro.product.marketname || goto FAILED
ECHO.System info: & adb.exe shell getprop ro.build.fingerprint || goto FAILED
ECHO.Security patch version: & adb.exe shell getprop ro.vendor.build.security_patch || goto FAILED
ECHO.
ECHO.Rebooting to Fastboot... & adb.exe reboot bootloader || goto FAILED
ECHO.Waiting for device connection...
:B
fastboot.exe devices 2>&1 | find "fastboot" || goto B
ECHO.Device connected
ECHO.Checking relock status...
fastboot.exe getvar unlocked 2>&1 | find "unlocked: no" 1>nul 2>nul && ECHO.Device is already locked, no need to relock again. Press any key to exit... && pause>nul && EXIT

ECHO.
ECHO.=== EXECUTING CLEAN RELOCK ===
ECHO.

ECHO.1. Wiping efisp partition to remove debug text...
fastboot.exe flash efisp efisp_blank.img || goto FAILED

ECHO.2. Flashing misc for factory reset on next boot...
fastboot.exe flash misc misc_wipedata_mi.img || goto FAILED

ECHO.3. Sending official lock command...
ECHO.>>> PLEASE LOOK AT YOUR PHONE SCREEN <<<
ECHO.You may need to confirm the lock using the volume and power buttons.
fastboot.exe oem lock || goto FAILED

ECHO.
ECHO.Congratulations, bootloader relock command sent successfully.
ECHO.Your device should wipe data and reboot shortly.
ECHO.
ECHO.All done. Press any key to exit...
ECHO.
pause>nul
EXIT

:FAILED
ECHO. & ECHO.Failed. Press any key to exit... & pause>nul & EXIT