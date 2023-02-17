# Windows 11 LTSC
Windows 11 LTSC is an unofficial heavily inspired distro of Windows 10 LTSC that prioritizes security and long-term dependability over frequent feature updates. It provides a user-friendly interface and is ideal for specialized systems and mission-critical applications that require maximum uptime and minimal interruptions. Unlike regular Windows 11 editions, LTSC can be updated only when needed and comes out of the box with a small footprint.

![1_HERO_DESKTOP](https://user-images.githubusercontent.com/96759883/219473489-3f60515a-2590-4c02-a175-75641b9b35e2.png)

**All kinds of contributions will be appreciated. All suggestions, pull 
requests and issues are welcome.**

## Features

- Windows 11 22623.1325 based on Enterprise
- No system requirements
- HEVC/HEIFI codec extension
- No Telemetry/Logging
- Error reporting removed
- Windows Update removed (accessable via debug)
- Short OOBE only asking for your name
- Clean desktop & Start menu experience out of the box
- Most inbox-apps removed
- Simplified settings app menu
- Education themes
- Low OS footprint
- Reduced Services/RAM idle usage
- APP (Install programs, drivers and more)
- Windows AMOLED Dark Mode preset
- Desktop stickers
- New & improved system tray
- Snipping Tool recording feature
- New search bar design
- Improved file explorer search
- Energy recommendations 
- Notepad tabs

## System Requirements
**Technically none but:**
- **Processor:** 64bit Processor
- **Storage:** 15GB
- **RAM:** 2GB
- **USB Drive:** 8GB

## Known issues

- Safe Mode boot displays a **hard error** message which can be ignored.
- Programs installed via **APP** may not uninstall successfully on first login. To resolve this, restart Windows.
  
## Development Roadmap

- [ ] Hosts file blocking thirtd party telemetry/data collection
- [ ] UI/UX for APP

## Building your own LTSC experience

- Download a Windows 11 Enterprise ISO from Microsoft
- Place the autoattend.xml file into the root directory 
- Place the %OEM% folder into sources directory
