#!/bin/bash
# ============================================================
# Xiaomi Snapdragon 8 Elite Gen 5 - One-Click Bootloader Relock
# Converted from Windows .bat to macOS/Linux shell script
# ============================================================

# Use system-installed adb and fastboot (installed via Homebrew)
ADB="adb"
FASTBOOT="fastboot"

# Image files are in the bin/ subfolder next to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"

echo ""
echo "[Compatible Devices]"
echo "- In theory: All Xiaomi / Redmi devices with Snapdragon 8 Elite Gen 5"
echo "- Xiaomi 17"
echo "- Xiaomi 17 Pro"
echo "- Xiaomi 17 Pro Max"
echo "- Xiaomi 17 Ultra"
echo "- Redmi K90 Pro Max"
echo ""
echo "[IMPORTANT WARNINGS]"
echo "- Ensure you are on Official region ROM before relocking! ELSE YOU WILL BRICK THE DEVICE!!"
echo "- Relocking will WIPE ALL user data on the device. Back up everything first!"
echo "- Before relocking: disable Find My Device, sign out of Mi Account,"
echo "  remove fingerprint data, and remove screen lock password."
echo "- No guarantee of compatibility with other devices. Use at your own risk."
echo "- For personal research/learning only. Do not use for illegal purposes."
echo ""
read -rp "If you understand the above, press Enter to continue..."
echo ""

echo "Please connect your phone to the computer and enable USB Debugging..."

# Wait for ADB device
while ! $ADB devices | grep -v "List of devices attached" | grep -q "device"; do
    sleep 1
done
echo "Device connected."
echo ""

echo -n "Device model: " && $ADB shell getprop ro.product.marketname || { echo "FAILED"; exit 1; }
echo -n "System info:  " && $ADB shell getprop ro.build.fingerprint   || { echo "FAILED"; exit 1; }
echo -n "Security patch: " && $ADB shell getprop ro.vendor.build.security_patch || { echo "FAILED"; exit 1; }
echo ""

echo "Rebooting to Fastboot..."
$ADB reboot bootloader || { echo "FAILED"; exit 1; }

echo "Waiting for fastboot device..."
while ! $FASTBOOT devices 2>&1 | grep -q "fastboot"; do
    sleep 1
done
echo "Device connected."

echo "Checking lock status..."
if $FASTBOOT getvar unlocked 2>&1 | grep -q "unlocked: no"; then
    echo "Device is already locked. Nothing to do. Press Enter to exit."
    read -r
    exit 0
fi

echo "Setting SELinux to permissive temporarily..."
$FASTBOOT oem set-gpu-preemption-value 0 androidboot.selinux=permissive > "$SCRIPT_DIR/log1.txt" 2>&1 \
    || { $FASTBOOT reboot; echo "FAILED"; exit 1; }

$FASTBOOT continue > "$SCRIPT_DIR/log2.txt" 2>&1 || { echo "FAILED"; exit 1; }

echo "Waiting for ADB device..."
while ! $ADB devices | grep -v "List of devices attached" | grep -q "device"; do
    sleep 1
done
echo "Device connected."

echo -n "Checking SELinux status... "
$ADB shell getenforce > "$SCRIPT_DIR/log3.txt" || { echo "FAILED"; exit 1; }
grep -q "Permissive" "$SCRIPT_DIR/log3.txt" || { echo "SELinux is NOT permissive — FAILED"; exit 1; }
echo "Permissive. OK."

echo "Pushing relock loader..."
$ADB push "$BIN_DIR/linuxloader_relock.efi" /data/local/tmp/linuxloader_relock.efi \
    || { echo "FAILED"; exit 1; }

$ADB shell "service call miui.mqsas.IMQSNative 21 i32 1 s16 'dd' i32 1 s16 'if=/data/local/tmp/linuxloader_relock.efi of=/dev/block/by-name/efisp' s16 '/data/mqsas/log.txt' i32 60" > "$SCRIPT_DIR/log4.txt" 2>&1 \
    || { echo "FAILED"; exit 1; }

echo "Rebooting to fastboot..."
$ADB reboot bootloader || { echo "FAILED"; exit 1; }

echo "Waiting for fastboot device..."
while ! $FASTBOOT devices 2>&1 | grep -q "fastboot"; do
    sleep 1
done
echo "Device connected."

echo "Verifying lock status..."
$FASTBOOT getvar unlocked > "$SCRIPT_DIR/log5.txt" 2>&1 || { echo "FAILED"; exit 1; }
grep -q "unlocked: no" "$SCRIPT_DIR/log5.txt" || { echo "Relock verification FAILED"; exit 1; }

echo ""
echo "Congratulations! Bootloader relocked successfully!"
echo ""

$FASTBOOT reboot || echo "Warning: Reboot command failed"

echo ""
echo "All done! Press Enter to exit."
read -r
exit 0
