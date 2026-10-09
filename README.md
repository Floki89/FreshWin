# FreshWin

**English** | [Deutsch](README.de.md)

A graphical setup wizard for fresh Windows 11 installations, in a single `.bat` file.
Pick a browser and your programs, clean up Windows, set the computer name and power
options, install all updates, and you're done. No installation, no dependencies.

| | |
|---|---|
| ![Browser selection](docs/browser-en.png) | ![Program selection with profiles](docs/programs-en.png) |
| ![Clean up Windows](docs/cleanup-en.png) | ![Appearance](docs/appearance-en.png) |

## Features

- **Browser**: Firefox, Chrome, Brave, Vivaldi or keep Edge, optionally as the default browser
- **77 programs** in 11 categories, installed silently via [winget](https://learn.microsoft.com/windows/package-manager/winget/)
  (runtimes, office & PDF, communication, media, utilities, security & VPN, system & remote help,
  development, cloud storage, gaming launchers, gaming voice & tools). Programs that are already installed are skipped
- **Gaming**: Steam, Epic, Ubisoft Connect, EA app, Battle.net, GOG, Rockstar, Amazon Games, Xbox app,
  Discord, TeamSpeak, Mumble, NVIDIA App, MSI Afterburner, peripheral software and more.
  Selecting the Xbox app keeps the Xbox components when Windows is cleaned up
- **Profiles**: *Gaming PC* and *Office PC* check suitable programs with one click and preset
  the appearance page (the NVIDIA App is only added if an NVIDIA graphics card is present)
- **Appearance**: dark/light mode, taskbar alignment and search, classic right-click menu,
  show hidden files, hide Copilot button, "End task" in the taskbar, Num Lock at startup,
  mouse acceleration off, Sticky Keys prompt off
- **Clean up Windows**: removes preinstalled consumer apps (Xbox, Bing News, Solitaire, Clipchamp …),
  turns off ads, suggestions, Bing search in Start and widgets, sets telemetry to minimum,
  shows file extensions, disables Fast Startup
- **New user profiles** get the same settings (via the default profile)
- **Basic setup**: rename the computer, display/sleep timeouts for AC and battery
- **Updates**: `winget upgrade --all` and Windows Update, optionally including drivers, in up to 3 rounds
- **Safety net**: creates a restore point before any change, and a summary page shows everything before it starts
- **Made for fresh PCs**: keeps the PC awake during setup, waits for winget, retries when Windows Update
  is busy installing, skips hanging installers after 20 minutes, warns about missing internet, battery
  power or a different admin account, and runs without a console window that could be closed by accident
- **Log file** next to the script (on the desktop when started via the one-line command)
- **German and English**, detected automatically and switchable in the window
- **Test mode**: shows exactly what *would* happen and changes nothing

## Usage

### Option 1: one command, no download (recommended)

1. Right-click the Start button → **Terminal (Admin)**
2. Paste this line and press Enter:

   ```powershell
   irm https://raw.githubusercontent.com/Floki89/FreshWin/main/FreshWin.bat | iex
   ```

No download, no SmartScreen warning. Keep the terminal window open while FreshWin is running.
Test mode: run `$env:SETUP_ARGS = '/test'` first.

### Option 2: download

1. Download [`FreshWin.bat`](https://github.com/Floki89/FreshWin/releases/latest/download/FreshWin.bat) (always the latest release).
2. Double-click it and confirm the administrator prompt.
3. Follow the wizard.

> [!NOTE]
> Edge and Windows SmartScreen may warn about a downloaded `.bat` file. Choose *Keep* in Edge, then
> *More info → Run anyway*. Read the script first if you're unsure: it's plain text.

### Option 3: USB stick

Copy `FreshWin.bat` to a USB stick and double-click it on the new PC. Handy if you set up several PCs.

### Options

| Call | Effect |
|---|---|
| `FreshWin.bat /test` | Test mode, no admin rights needed and nothing is changed |
| `FreshWin.bat /lang:en` / `/lang:de` | Force the language |
| rename to `FreshWin-TEST.bat` | Test mode by double-click |

## Requirements

- Windows 11 (most things also work on Windows 10). **Not in S mode**: leave S mode first
  (Settings → System → Activation), scripts can't run there
- Administrator rights (except in test mode)
- Internet connection. If the Wi-Fi driver is missing, use a LAN cable or a USB tethered phone
- winget (*App Installer*) is preinstalled on Windows 11. Right after the first sign-in FreshWin waits up to
  3 minutes until it is ready and installs a current version if needed

## Customizing

All lists are at the top of the PowerShell part of `FreshWin.bat`:

- `$Browsers` lists the browsers
- `$AppCatalog` lists programs by category. `Id` is the winget ID (find one with `winget search <name>`;
  `Source = 'msstore'` for Microsoft Store apps),
  `Def = $true` pre-checks the program, `De`/`En` hold the short descriptions
- `$Profiles` defines the profiles (winget IDs plus appearance defaults)
- `$AppxRemove` lists the preinstalled apps that get removed
- `$Strings` holds all texts (German and English)

## Notes

- Windows 11 doesn't let scripts set the default browser for the current user. FreshWin
  registers it for new profiles where possible and opens *Settings → Default apps* at the end.
- Telemetry level 1 ("required") is the minimum on Windows Home/Pro.
- Everything FreshWin changes is a normal Windows setting and can be reverted in Settings, or with the restore point.

## Disclaimer

> [!CAUTION]
> **Use at your own risk.** FreshWin changes system settings and removes apps.
> **Run it in test mode first** (`FreshWin.bat /test`) and preferably on freshly installed machines.

## License

[MIT](LICENSE)
