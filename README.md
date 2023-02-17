![windows11ltsc](https://user-images.githubusercontent.com/96759883/219713402-be82fdc0-01cd-4ff3-8e10-91dd59e4bf49.png)

Windows 11 LTSC is an unofficial heavily inspired distro of Windows 10 LTSC that prioritizes security and long-term dependability over frequent feature updates. It provides a user-friendly interface and is ideal for specialized systems and mission-critical applications that require maximum uptime and minimal interruptions. Unlike regular Windows 11 editions, LTSC can be updated only when needed and comes out of the box with a small footprint.

![github_hero_systemrequirements](https://user-images.githubusercontent.com/96759883/219724539-0caefe5b-875d-42ba-812a-3fe4bd715b93.png)

![github_hero_knownissues-modified](https://user-images.githubusercontent.com/96759883/219673927-2c6d506b-3e0f-4ab2-8a9f-1e0036e613e0.png)

- Safe Boot displays a **hard error** message which can be ignored.
- Programs installed via **APP** may not uninstall successfully on first login. To resolve this, restart Windows.
  
![github_hero_developmentroadmap-modified](https://user-images.githubusercontent.com/96759883/219674201-a05ff4e3-4204-4da7-a05c-2a3904173605.png)

- [ ] Hosts file blocking thirtd party telemetry/data collection
- [ ] UI/UX for APP

![github_hero_buildingltsc-modified](https://user-images.githubusercontent.com/96759883/219674453-48c91dd6-65e7-493b-81c6-732e8a84d0d5.png)

**If you want to build LTSC yourself, here are the instructions:**

- Download a Windows 11 Enterprise ISO from Microsoft
- Place the autoattend.xml file into the root directory 
- Place the %OEM% folder into sources directory
