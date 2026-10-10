<div align="center">

# FreshWin

**Set up a fresh Windows 11 PC in one go – programs, clean-up, appearance and updates, in one friendly wizard.**

[![Latest release](https://img.shields.io/github/v/release/Floki89/FreshWin?label=release&color=005493)](https://github.com/Floki89/FreshWin/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/Floki89/FreshWin/total?color=005493)](https://github.com/Floki89/FreshWin/releases)
[![License: MIT](https://img.shields.io/github/license/Floki89/FreshWin?color=005493)](LICENSE)
![Windows 11](https://img.shields.io/badge/Windows-11-0078D4?logo=windows11&logoColor=white)
![PowerShell 5.1](https://img.shields.io/badge/PowerShell-5.1-5391FE?logo=powershell&logoColor=white)

**English** | [Deutsch](README.de.md)

<img src="docs/programs-en.png" width="720" alt="FreshWin – program selection with profiles, search and installed programs marked">

</div>

## Contents

- [Quick start](#quick-start)
- [Features](#features)
- [Screenshots](#screenshots)
- [Usage](#usage)
- [Set up several PCs](#set-up-several-pcs)
- [Requirements](#requirements)
- [FAQ](#faq)
- [Customizing](#customizing)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)

## Quick start

Right-click the Start button → **Terminal (Admin)**, paste this line and press Enter:

```powershell
irm https://raw.githubusercontent.com/Floki89/FreshWin/main/FreshWin.bat | iex
```

Prefer a file? **[Download FreshWin.bat](https://github.com/Floki89/FreshWin/releases/latest/download/FreshWin.bat)**, double-click it and confirm the admin prompt.

> [!TIP]
> Want to see what would happen first? Start it in **test mode** – nothing is changed: `FreshWin.bat /test`

## Features

**Programs**
- 77 programs in 11 categories, installed silently via [winget](https://learn.microsoft.com/windows/package-manager/winget/) – including Microsoft Store apps
- Profiles **Gaming PC** and **Office PC** select suitable programs with one click
- Search box, live count of selected programs, programs that are already installed are marked
- Browser of your choice (Firefox, Chrome, Brave, Vivaldi or Edge), optionally as the default browser

**Clean up Windows**
- Removes preinstalled consumer apps (Xbox, Bing News, Solitaire, Clipchamp …) – keeps the Store, Photos, Calculator and other useful apps
- Turns off ads, suggestions, Bing search in Start and widgets, sets telemetry to minimum
- Shows file extensions, disables Fast Startup
- Applies the settings to future user profiles as well

**Appearance**
- Dark or light mode, taskbar alignment and search box
- Classic right-click menu, show hidden files, hide the Copilot button, "End task" in the taskbar
- Num Lock at startup, mouse acceleration off, no Sticky Keys prompt

**Basic setup and updates**
- Rename the computer, display and sleep timeouts
- Updates all programs (`winget upgrade --all`) and installs Windows updates, optionally with drivers
- Optional automatic restart at the end – ideal when it runs overnight

**Made for fresh PCs**
- Restore point before any change, summary page before anything starts
- Keeps the PC awake, waits for winget after the first sign-in, retries while Windows Update is busy,
  skips installers that hang
- Warns about missing internet, battery power or a different admin account
- No console window that could be closed by accident; detailed log file
- German and English, detected automatically and switchable at any time

## Screenshots

| | |
|---|---|
| ![Browser](docs/browser-en.png) | ![Programs](docs/programs-en.png) |
| ![Clean up Windows](docs/cleanup-en.png) | ![Appearance](docs/appearance-en.png) |

## Usage

### Option 1: one command, no download (recommended)

1. Right-click the Start button → **Terminal (Admin)**
2. Paste the command from [Quick start](#quick-start) and press Enter
3. Keep the terminal window open while FreshWin is running

No download and no SmartScreen warning. The log file is saved on the desktop.

### Option 2: download

1. [Download FreshWin.bat](https://github.com/Floki89/FreshWin/releases/latest/download/FreshWin.bat) (always the latest version)
2. Double-click it and confirm the admin prompt
3. Follow the wizard

> [!NOTE]
> Edge and Windows SmartScreen may warn about a downloaded `.bat` file: choose *Keep* in Edge, then
> *More info → Run anyway*. FreshWin is a plain text file – you can read every line before running it.

### Option 3: USB stick

Copy `FreshWin.bat` to a USB stick and double-click it on the new PC.

### Command-line options

| Option | Effect |
|---|---|
| `/test` | Test mode: shows what would happen, changes nothing, no admin rights needed |
| `/lang:de`, `/lang:en` | Force the language |
| `/config:file.json` | Load a saved selection |
| `/auto` | Start right away with the saved selection, without any clicks |

Renaming the file to `FreshWin-TEST.bat` also starts test mode. With the one-line command, run
`$env:SETUP_ARGS = '/test'` first.

## Set up several PCs

1. Make your selection once and click **Save selection …** on the summary page
2. Save it as `FreshWin.json` next to `FreshWin.bat` (e.g. on a USB stick)
3. On every new PC FreshWin loads it automatically – check it and click *Start*

Fully unattended: `FreshWin.bat /auto` runs the setup without any clicks. Combined with
*Restart automatically when finished* the PC is ready in the morning.

## Requirements

- Windows 11 (most things also work on Windows 10)
- **Not in S mode** – scripts can't run there. Leave S mode first under *Settings → System → Activation*
- Administrator rights (except in test mode)
- Internet connection. If the Wi-Fi driver is missing, use a LAN cable or USB tethering with a phone
- winget (*App Installer*) is preinstalled on Windows 11. Right after the first sign-in FreshWin waits until it is
  ready and installs a current version if needed

## FAQ

<details>
<summary><b>What exactly does FreshWin change?</b></summary>

Only what you tick. The summary page lists everything before the start, and test mode (`/test`) shows every
single command and registry value without changing anything. All changes are normal Windows settings.
</details>

<details>
<summary><b>How do I undo the changes?</b></summary>

FreshWin creates a restore point before any change (*Control Panel → Recovery → Open System Restore*).
Settings can also be changed back in the Windows settings at any time, programs can be uninstalled as usual.
</details>

<details>
<summary><b>A program could not be installed – why?</b></summary>

The log file (button **Open log** at the end) shows the reason. Common causes: the installer hung and was
stopped after 20 minutes, the program refuses admin rights, or Windows needs a restart first. Install those
programs manually or run FreshWin again after a restart – programs that are already installed are skipped.
</details>

<details>
<summary><b>Why isn't my browser the default yet?</b></summary>

Windows 11 doesn't let any program set the default browser silently. At the end FreshWin opens
*Settings → Default apps* – just select the browser there.
</details>

<details>
<summary><b>Where is the log file?</b></summary>

Next to `FreshWin.bat`, or on the desktop when started with the one-line command
(`FreshWin_<PC name>_<date>.log`).
</details>

<details>
<summary><b>Can I run FreshWin again later?</b></summary>

Yes. Installed programs are skipped, settings are simply applied again. Running it once more after the first
restart is a good way to catch the remaining Windows updates.
</details>

## Customizing

Everything is configured at the top of the PowerShell part of `FreshWin.bat`:

| Variable | Content |
|---|---|
| `$Browsers` | Browsers on the first page |
| `$AppCatalog` | Programs by category. `Id` is the winget ID (`winget search <name>`), `Source = 'msstore'` for Store apps, `Def = $true` pre-checks it, `De`/`En` are the short descriptions |
| `$Profiles` | The profiles: winget IDs plus defaults for the appearance page |
| `$AppxRemove` | Preinstalled apps that get removed |
| `$Strings` | All texts in German and English |

## Contributing

Missing a program or found a bug? [Open an issue](https://github.com/Floki89/FreshWin/issues/new/choose) –
there are templates for both. Pull requests are welcome; please test changes in test mode first.
See the [changelog](CHANGELOG.md) for what changed between versions.

## Disclaimer

> [!CAUTION]
> **Use at your own risk.** FreshWin changes system settings and removes apps.
> **Run it in test mode first** (`FreshWin.bat /test`) and preferably on freshly installed machines.

## License

[MIT](LICENSE) – FreshWin itself. The programs it installs are downloaded from their publishers via winget
and are subject to their own licenses.
