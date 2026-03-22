
  # Xiaomi & Redmi Snapdragon 8 Elite Gen 5 - Bootloader Unlock and Relock
  
  ## macOS + Linux + Windows Support


### COMPATIBLE DEVICES

Theoretically all Xiaomi / Redmi devices with Snapdragon 8 Elite Gen 5
- Xiaomi 17
- Xiaomi 17 Pro
- Xiaomi 17 Pro Max
- Xiaomi 17 Ultra
- Redmi K90 Pro Max

Running Security path < March 2026

### BEFORE YOU START (ALL PLATFORMS)
!! THIS WILL WIPE ALL DATA ON YOUR PHONE — BACK UP FIRST!!

On your phone, before running the script:
  1. Back up all your data to a PC or cloud
  2. Disable "Find My Device" (Mi Cloud > Find My Phone > turn off)
  3. Sign out of your Mi Account (Settings > Mi Account > Sign Out)
  4. Remove all fingerprints (Settings > Fingerprint > delete all)
  5. Remove screen lock password (Settings > Lock Screen > remove)
  6. Enable Developer Options:
       Settings > About Phone > tap "MIUI Version" 7 times
  7. Enable USB Debugging:
       Settings > Additional Settings > Developer Options > USB Debugging ON

## Windows INSTRUCTIONS

### REQUIREMENTS
- Windows 10 or 11
- USB cable

### STEPS
1. Extract this zip folder somewhere on your PC
2. Connect your phone via USB
3. Double-click: xiaomi_unlock_WINDOWS.bat
4. Follow the on-screen prompts
5. When prompted on your phone, tap "Allow USB Debugging"
6. The script will handle everything automatically

## macOS + Linux INSTRUCTIONS

### REQUIREMENTS
- macOS (any recent version) or Linux (Debian/Ubuntu, Fedora, Arch)
- USB cable

### STEP 1 — Install Homebrew (MAC ONLY, skip if on Linux)
Open Terminal (Cmd + Space, type Terminal, press Enter)
Paste this and press Enter:
```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Enter your Mac password when asked (you won't see it typing, that's normal).
When it finishes, run the two "Next steps" commands it shows you, then verify:

```
  brew --version
```

### STEP 2 — Install ADB and Fastboot
In Terminal, run:

- macOS:
```
  brew install android-platform-tools
```
- Linux:
```
  sudo apt install android-tools-adb android-tools-fastboot #Debian/Ubuntu and derivatives
  sudo dnf install android-tools #Fedora
  sudo pacman -S android-tools #Arch
```


### STEP 3 — Run the unlock script
In Terminal, navigate to this folder.

Make the script executable (only needed once):
```
  chmod +x xiaomi_unlock_MACOS_LINUX.sh
```

Run it:
```
  ./xiaomi_unlock_MACOS_LINUX.sh
```

### STEP 4 — Follow the prompts
- Press Enter to confirm the warnings
- Connect your phone via USB when asked
- Tap "Allow USB Debugging" on your phone screen when the popup appears
- The script will do everything automatically from there
- Your phone will reboot and factory reset — this is normal!

### AFTER UNLOCKING
Your phone will go through a first-time setup like a new device.

The bootloader is now unlocked — you can now install custom ROMs,
custom recoveries (like TWRP), or modify system partitions.

### RELOCKING
**IMPORTANT**: Ensure you are on Official Region (CN/Global/EEA/India/Turkey/etc) Factory ROM. Else you will have a bricked device!!

Same process as locking, except use relock scripts.

### DISCLAIMER

- For personal research and learning only
- No guarantee of compatibility beyond listed devices
- Use at your own risk — you accept full responsibility
- Original script by the Xiaomi modding community
- macOS port tested successfully on Xiaomi 17 Pro Max

