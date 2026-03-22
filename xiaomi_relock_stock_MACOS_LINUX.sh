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

echo ""
echo "=== EXECUTING CLEAN RELOCK ==="
echo ""

echo -n "1. Wiping efisp partition to remove debug text... "
$FASTBOOT flash efisp "$BIN_DIR/efisp_blank.img" || { echo "FAILED to wipe efisp!"; exit 1; }

echo "2. Flashing misc for factory reset on next boot..."
$FASTBOOT flash misc "$BIN_DIR/misc_wipedata_mi.img" || { echo "FAILED to flash misc!"; exit 1; }

echo "3. Sending official lock command..."
echo ">>> PLEASE LOOK AT YOUR PHONE SCREEN <<<"
echo "You may need to confirm the lock using the volume and power buttons."
$FASTBOOT oem lock || { echo "FAILED: Official lock command rejected."; exit 1; }

echo ""
echo "Congratulations! Bootloader relock command sent successfully!"
echo "Your device should wipe data and reboot shortly."
echo ""

echo "All done! Press Enter to exit."
read -r
exit 0

