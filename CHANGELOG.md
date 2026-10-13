# Changelog

All notable changes to FreshWin. Versions follow [semantic versioning](https://semver.org/).

## [1.4.8] – 2026-10-13

First complete run on a freshly installed laptop without problems.

### Changed
- Cleaner log file: no more `#< CLIXML` blocks from child PowerShell processes, no winget tables
  for programs that are already installed

## [1.4.7] – 2026-10-13

### Fixed
- FreshWin froze while renaming the computer. Renaming, the restore point and the App Installer update now run
  in a separate process with a timeout, so the window stays responsive and a hanging Windows command cannot
  block the setup. If renaming hangs, the name is set directly in the registry (PCs without a company domain)

## [1.4.6] – 2026-10-13

### Fixed
- Updating an old winget failed on fresh PCs because the Windows App Runtime was missing
  (`0x80073CF3`). FreshWin now also downloads Microsoft's dependency package (VCLibs, Windows App Runtime)
  from the winget release and installs it first

## [1.4.5] – 2026-10-13

### Fixed
- FreshWin did not start after the admin prompt: Microsoft Defender flagged the hidden start
  (`conhost.exe --headless powershell …`) as *Trojan:Win32/Commando.A!ml* and blocked it. FreshWin now starts
  in a normal, minimized PowerShell window, which Defender does not flag

## [1.4.4] – 2026-10-13

### Fixed
- With older winget versions (e.g. 1.9) every installation failed with `0x8A15005E` (certificate error of the
  Microsoft Store source). FreshWin now always names the source (`winget` or `msstore`), so only Store apps
  depend on the Store source
- winget older than 1.11 is updated automatically before installing; clear message for the certificate error

## [1.4.3] – 2026-10-13

### Fixed
- The display now also stays on during setup (before, only sleep was blocked and the screen turned off)
- FreshWin checks that blocking sleep really worked and warns if not; hint not to close the laptop lid

## [1.4.2] – 2026-10-13

### Added
- eM Client is back in the list (Communication)

## [1.4.1] – 2026-10-13

Fixes from the first real run on a freshly installed laptop.

### Fixed
- Removing preinstalled apps: each step runs on its own with fallbacks (current user, `dism.exe`),
  and the result is checked afterwards – the log now says what is really gone, details go to the log file
- `winget upgrade --all` is started a second time when winget was interrupted (`0x80004004`),
  e.g. because it updated itself
- Error codes are shown in hex (`0x…`) instead of large negative numbers

### Changed
- Timeout per installer raised to 30 minutes for slow connections
- The start button shows *Running …* during setup

## [1.4.0] – 2026-10-10

### Added
- Search box on the programs page, live count of selected programs
- Programs that are already installed are marked (*already installed*)
- Tooltips with the winget ID of every program
- Save and load a selection as JSON; `FreshWin.json` next to the script is loaded automatically
- Command-line options `/config:<file>` and `/auto` for unattended setups
- Optional automatic restart when finished (can be cancelled)
- Status line *(3/18) Installing …*, progress and elapsed time in the window title
- At the end: problems listed by name, **Open log** button, sound and window brought to front
- Notice when a newer version is available, *Help* link in the header

### Changed
- The window fits on small laptop screens
- *All* / *None* only affect the programs currently shown by the search

## [1.3.0] – 2026-10-09

### Added
- Start without download: `irm …/FreshWin.bat | iex`
- Keeps the PC awake during setup
- Warnings before the start: no internet, battery power, different admin account
- Optional driver updates, up to three Windows Update rounds

### Changed
- Runs without a console window
- Waits for winget after the first sign-in and installs a current App Installer if needed
- Installers: 20-minute timeout, retry while another installation is running,
  *restart required* counts as success
- `FreshWin.bat` is stored with Windows line endings so raw downloads work

## [1.2.0] – 2026-10-09

### Added
- Profiles *Gaming PC* and *Office PC*
- Appearance page: dark/light mode, taskbar, classic context menu, mouse acceleration and more

## [1.1.0] – 2026-10-09

### Added
- 77 programs in 11 categories, including gaming launchers, voice chat and Microsoft Store apps
- German and English user interface, switchable at runtime
- Test mode (`/test`)

[1.4.8]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.8
[1.4.7]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.7
[1.4.6]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.6
[1.4.5]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.5
[1.4.4]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.4
[1.4.3]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.3
[1.4.2]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.2
[1.4.1]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.1
[1.4.0]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.0
[1.3.0]: https://github.com/Floki89/FreshWin/releases/tag/v1.3.0
