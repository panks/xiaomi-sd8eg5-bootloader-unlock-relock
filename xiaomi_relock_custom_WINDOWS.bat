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
fastboot.exe getvar unlocked 2>&1 | find "unlockd: no" 1>nul 2>nul && ECHO.Device is already locked, no need to relock again. Press any key to exit... && pause>nul && EXIT
ECHO.Temporarily setting SELinux to permissive...
fastboot.exe oem set-gpu-preemption-value 0 androidboot.selinux=permissive 1>log1.txt 2>&1 || fastboot.exe reboot && goto FAILED
fastboot.exe continue 1>log2.txt 2>&1 || goto FAILED
ECHO.Waiting for device connection...
:C
adb.exe devices | find /v "List of devices attached" | find "device" 1>nul 2>nul || goto C
ECHO.Device connected
ECHO.Checking SELinux status... & adb.exe shell getenforce>log3.txt || goto FAILED
find "Permissive" "log3.txt" 1>nul 2>nul || goto FAILED
ECHO.Writing relock program...
adb.exe push linuxloader_relock.efi /data/local/tmp/linuxloader_relock.efi 1>nul || goto FAILED
adb.exe shell service call miui.mqsas.IMQSNative 21 i32 1 s16 "dd" i32 1 s16 'if=/data/local/tmp/linuxloader_relock.efi of=/dev/block/by-name/efisp' s16 '/data/mqsas/log.txt' i32 60 1>log4.txt 2>&1 || goto FAILED
ECHO.Rebooting to Fastboot... & adb.exe reboot bootloader || goto FAILED
ECHO.Waiting for device connection...
:D
fastboot.exe devices 2>&1 | find "fastboot" || goto D
ECHO.Device connected
ECHO.Checking lock status...
fastboot.exe getvar unlocked 1>log5.txt 2>&1 || goto FAILED
find "unlocked: no" "log5.txt" 1>nul 2>nul || goto FAILED
ECHO.
ECHO.Congratulations! Relock successful
ECHO.
ECHO.Rebooting...
fastboot.exe reboot || ECHO.Failed
ECHO.
ECHO.All done. Press any key to exit...
ECHO.
pause>nul
EXIT
:FAILED
ECHO. & ECHO.Failed. Press any key to exit... & pause>nul & EXIT

