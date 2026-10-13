# Changelog

All notable changes to FreshWin. Versions follow [semantic versioning](https://semver.org/).

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

[1.4.1]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.1
[1.4.0]: https://github.com/Floki89/FreshWin/releases/tag/v1.4.0
[1.3.0]: https://github.com/Floki89/FreshWin/releases/tag/v1.3.0
