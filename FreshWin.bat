<# : ---------- Batch launcher ----------
@echo off
setlocal
title FreshWin
set "SETUP_FILE=%~f0"
set "SETUP_ARGS=%*"
set "SETUP_TEST="
:: Test mode: argument /test or a file name ending in -TEST / _TEST (no admin rights needed)
echo.%*| findstr /i /r /c:"[/-]test\>" >nul && set "SETUP_TEST=1"
echo %~n0| findstr /i /r /c:"[-_]test$" >nul && set "SETUP_TEST=1"
if defined SETUP_TEST goto :start
net session >nul 2>&1
if errorlevel 1 (
    echo Requesting administrator rights - Adminrechte werden angefordert ...
    powershell -NoProfile -Command "if ($env:SETUP_ARGS) { Start-Process -FilePath $env:SETUP_FILE -ArgumentList $env:SETUP_ARGS -Verb RunAs } else { Start-Process -FilePath $env:SETUP_FILE -Verb RunAs }"
    exit /b
)
:start
echo FreshWin is running - please keep this window open.
echo FreshWin laeuft - dieses Fenster bitte nicht schliessen.
powershell -NoProfile -STA -ExecutionPolicy Bypass -Command "iex ([IO.File]::ReadAllText($env:SETUP_FILE))"
exit /b
#>
# ================================================================
#  FreshWin - setup wizard for fresh Windows 11 installations
#
#  Options:   FreshWin.bat /test       test mode (dry run)
#             FreshWin.bat /lang:en    force language (de | en)
#  Test mode: also active if the file name ends in -TEST or _TEST
#             (e.g. FreshWin-TEST.bat). Nothing is installed,
#             removed or written to the registry then.
# ================================================================

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$AppName    = 'FreshWin'
$AppVersion = '1.1.0'
$SetupFile  = $env:SETUP_FILE
$ArgLine    = [string]$env:SETUP_ARGS
$DryRun     = ($ArgLine -match '(^|\s)[/-]test(\s|$)') -or
              ([IO.Path]::GetFileNameWithoutExtension($SetupFile) -match '[-_]test$')
$IsAdmin    = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$script:Lang = 'en'
if ((Get-UICulture).TwoLetterISOLanguageName -eq 'de') { $script:Lang = 'de' }
if ($ArgLine -match '[/-]lang[:=](de|en)\b') { $script:Lang = $Matches[1].ToLower() }

# ================================================================
#  Texts
# ================================================================
$Strings = @{
de = @{
    needAdmin      = 'FreshWin braucht Administratorrechte.'
    testBadge      = '  TESTMODUS – es wird nichts verändert  '
    btnCancel      = 'Abbrechen';      btnBack  = '< Zurück';   btnNext   = 'Weiter >'
    btnStart       = 'Jetzt starten';  btnStartTest = 'Test starten'
    btnClose       = 'Schließen';      btnReboot = 'Neu starten'
    btnAll         = 'Alle';           btnNone   = 'Keine'
    step1          = 'Schritt 1 von 5: Browser'
    step2          = 'Schritt 2 von 5: Programme'
    step3          = 'Schritt 3 von 5: Windows aufräumen'
    step4          = 'Schritt 4 von 5: Grundeinrichtung'
    step5          = 'Schritt 5 von 5: Zusammenfassung'
    stepRun        = 'Ausführung'
    browserQuestion = 'Welcher Browser soll installiert werden?'
    browserEdge    = 'Microsoft Edge (vorinstalliert, nichts ändern)'
    browserDefault = 'Als Standardbrowser festlegen'
    browserHint    = 'Hinweis: Den Standardbrowser muss man bei Windows 11 immer selbst bestätigen. Am Ende öffnet sich dafür automatisch die Seite „Standard-Apps“ – dort einfach den gewählten Browser auswählen.'
    appsQuestion   = 'Welche Programme sollen installiert werden?'
    catRuntimes    = 'Laufzeitumgebungen'
    catOffice      = 'Büro & PDF'
    catComm        = 'Kommunikation'
    catMedia       = 'Multimedia'
    catTools       = 'Werkzeuge'
    catSecurity    = 'Sicherheit & VPN'
    catSystem      = 'System & Fernwartung'
    catDev         = 'Entwicklung'
    catCloud       = 'Cloud-Speicher'
    catGames       = 'Gaming – Launcher'
    catGameTools   = 'Gaming – Voice & Tools'
    optsTitle      = 'Windows aufräumen und einstellen'
    optRestore     = 'Wiederherstellungspunkt erstellen (vor allen Änderungen, dauert einige Minuten)'
    optAppx        = 'Vorinstallierte Consumer-Apps entfernen (Xbox, Bing News, Solitaire, Clipchamp …)'
    optAds         = 'Werbung, App-Vorschläge und Bing-Suche im Startmenü abschalten'
    optTelemetry   = 'Telemetrie auf Minimum, Werbe-ID aus'
    optWidgets     = 'Widgets (News in der Taskleiste) abschalten'
    optExplorer    = 'Dateiendungen anzeigen, Explorer startet in „Dieser PC“'
    optFastBoot    = 'Schnellstart deaktivieren (echtes Herunterfahren)'
    optDefProf     = 'Benutzereinstellungen auch für künftige neue Benutzerprofile setzen'
    optsHint       = 'Bleiben erhalten: Microsoft Store, Fotos, Rechner, Kurznotizen, Remotehilfe, Defender, Media Player. Fahre mit der Maus über die zweite Option, um die komplette Liste zu sehen.'
    baseTitle      = 'Grundeinrichtung'
    rename         = 'Computer umbenennen:'
    renameHint     = 'max. 15 Zeichen: A-Z, 0-9, Bindestrich. Wird nach dem Neustart aktiv.'
    currentName    = 'aktuell: {0}'
    power          = 'Energieeinstellungen setzen'
    monitorOff     = 'Bildschirm aus nach'
    standby        = 'Energiesparmodus nach'
    onAC           = 'Netzbetrieb:'
    onDC           = 'Akku:'
    timeouts       = '5 Minuten|10 Minuten|15 Minuten|30 Minuten|1 Stunde|2 Stunden|Nie'
    upgrade        = 'Alle installierten Programme aktualisieren (winget upgrade --all)'
    wu             = 'Windows Updates suchen und installieren (kann lange dauern)'
    baseHint       = 'Achtung: Mit Updates dauert das Setup deutlich länger – je nach PC und Internet 30 Minuten bis über eine Stunde. Die Updates laufen ganz am Ende, Treiber-Updates sind ausgenommen. Im Testmodus wird nur nach Windows Updates gesucht.'
    summaryTitle   = 'Zusammenfassung'
    runRunning     = 'Setup läuft …'
    runDone        = 'Fertig. Ein Neustart wird empfohlen.'
    runDoneReboot  = 'Fertig. Ein Neustart ist erforderlich.'
    runDoneErrors  = 'Fertig mit {0} Problem(en) – siehe Log.'
    msgConfirm     = 'Setup jetzt mit diesen Einstellungen starten?'
    msgInvalidName = "Ungültiger Computername: '{0}'`n`nErlaubt: 1-15 Zeichen, A-Z, 0-9 und Bindestrich (nicht am Anfang/Ende), nicht nur Ziffern."
    msgTestNoReboot = 'Testmodus: Es wird kein Neustart ausgeführt.'
    msgReboot      = 'PC jetzt neu starten?'
    msgRunning     = 'Das Setup läuft noch. Bitte warten, bis es fertig ist.'
    sumUser        = 'Benutzer:'
    sumComputer    = 'Computer:'
    sumMode        = 'Modus:'
    sumModeTest    = 'TEST (keine Änderungen)'
    sumBrowser     = 'BROWSER'
    sumDefault     = '-> Standardbrowser'
    sumApps        = 'PROGRAMME ({0})'
    sumNone        = '(keine)'
    sumWindows     = 'WINDOWS'
    sumBase        = 'GRUNDEINRICHTUNG'
    sumName        = 'Computername:'
    sumUnchanged   = 'unverändert'
    sumPowerAC     = 'Energie Netz:'
    sumPowerDC     = 'Energie Akku:'
    sumPower       = 'Energie:'
    sumPowerFmt    = 'Bildschirm {0}, Energiesparmodus {1}'
    sumUpgrade     = 'Programme aktualisieren (winget upgrade --all)'
    sumWU          = 'Windows Updates installieren'
    sumNote        = "Die Benutzereinstellungen gelten für das Konto oben. Wenn das nicht der spätere`r`nNutzer ist, die Option `„auch für künftige neue Benutzerprofile`“ aktiviert lassen."
    restoreDesc    = 'Vor FreshWin'
    logTestMode    = 'TESTMODUS'
    logUser        = 'Benutzer: {0}  |  Admin: {1}  |  Log: {2}'
    logWould       = '  [TEST] würde ausführen: {0} {1}'
    logRestore     = 'Wiederherstellungspunkt …'
    logWinget      = 'Prüfe winget …'
    logWingetTest  = '  [TEST] winget fehlt – würde App-Installer registrieren'
    logWingetMissing = '  [!] winget nicht verfügbar – Programminstallation wird übersprungen.'
    logWingetHint  = '      Microsoft Store öffnen, „App-Installer“ aktualisieren und FreshWin erneut starten.'
    errWinget      = 'winget fehlt'
    logInstall     = 'Installiere {0} ({1}) …'
    logSkipInstalled = '  bereits installiert – übersprungen'
    logInstallErr  = '  [!] Fehler (Exitcode {0}) – Details im Log'
    logBrowser     = 'Standardbrowser: {0} …'
    logXmlTest     = '  [TEST] würde {0} schreiben:'
    logAssocOK     = '  Zuordnung für neue Benutzerprofile hinterlegt'
    logNoProgId    = '  Keine automatische Zuordnung für diesen Browser – bitte am Ende in den Einstellungen bestätigen'
    logDism        = '  [!] DISM Exitcode {0}'
    errDism        = 'Standardbrowser (DISM)'
    logStartTest   = '  [TEST] würde starten: {0}'
    logAppx        = 'Entferne vorinstallierte Consumer-Apps …'
    logAppxMissing = '  - {0} : nicht vorhanden'
    logAppxWould   = '  [TEST] - {0} : installiert, würde entfernt'
    logAppxRemoved = '  - {0} : entfernt'
    logReg         = 'Registry-Einstellungen …'
    logDefProf     = 'Standardprofil (neue Benutzer) …'
    logDefProfErr  = '  [!] Standardprofil konnte nicht geladen werden (Exitcode {0})'
    logRename      = 'Computername: {0} -> {1}'
    logRenameOK    = '  OK (aktiv nach Neustart)'
    errRename      = 'Computername'
    errRestore     = 'Wiederherstellungspunkt'
    logPower       = 'Energieeinstellungen …'
    logUpgradeList = 'Verfügbare Programm-Updates (winget upgrade) …'
    logUpgradeTest = '  [TEST] würde ausführen: winget upgrade --all --silent …'
    logUpgrade     = 'Aktualisiere installierte Programme (winget upgrade --all) …'
    logUpgradeErr  = '  [!] Nicht alle Updates erfolgreich (Exitcode {0}) – Details im Log'
    logWUSearch    = 'Suche Windows Updates (nur Suche, kann einige Minuten dauern) …'
    logWUInstall   = 'Windows Updates suchen, herunterladen und installieren (kann lange dauern) …'
    logWUNone      = '  Keine Windows Updates ausstehend'
    logWUTest      = '  [TEST] würde diese Updates herunterladen und installieren'
    logWUErr       = '  [!] Windows Update Exitcode {0}'
    errWU          = 'Windows Update'
    logDone        = '===== Fertig ====='
    logProblems    = 'Probleme bei: {0}'
    logFile        = 'Logdatei: {0}'
    logSettingsTest = '[TEST] würde Einstellungen > Standard-Apps öffnen'
}
en = @{
    needAdmin      = 'FreshWin needs administrator rights.'
    testBadge      = '  TEST MODE – nothing will be changed  '
    btnCancel      = 'Cancel';         btnBack  = '< Back';     btnNext   = 'Next >'
    btnStart       = 'Start now';      btnStartTest = 'Start test'
    btnClose       = 'Close';          btnReboot = 'Restart'
    btnAll         = 'All';            btnNone   = 'None'
    step1          = 'Step 1 of 5: Browser'
    step2          = 'Step 2 of 5: Programs'
    step3          = 'Step 3 of 5: Clean up Windows'
    step4          = 'Step 4 of 5: Basic setup'
    step5          = 'Step 5 of 5: Summary'
    stepRun        = 'Running'
    browserQuestion = 'Which browser should be installed?'
    browserEdge    = 'Microsoft Edge (preinstalled, change nothing)'
    browserDefault = 'Set as default browser'
    browserHint    = 'Note: Windows 11 always asks you to confirm the default browser yourself. At the end, the "Default apps" settings page opens automatically – just pick the chosen browser there.'
    appsQuestion   = 'Which programs should be installed?'
    catRuntimes    = 'Runtimes'
    catOffice      = 'Office & PDF'
    catComm        = 'Communication'
    catMedia       = 'Media'
    catTools       = 'Utilities'
    catSecurity    = 'Security & VPN'
    catSystem      = 'System & remote help'
    catDev         = 'Development'
    catCloud       = 'Cloud storage'
    catGames       = 'Gaming – launchers'
    catGameTools   = 'Gaming – voice & tools'
    optsTitle      = 'Clean up and configure Windows'
    optRestore     = 'Create a restore point (before any changes, takes a few minutes)'
    optAppx        = 'Remove preinstalled consumer apps (Xbox, Bing News, Solitaire, Clipchamp …)'
    optAds         = 'Turn off ads, app suggestions and Bing search in the Start menu'
    optTelemetry   = 'Telemetry to minimum, advertising ID off'
    optWidgets     = 'Turn off widgets (news in the taskbar)'
    optExplorer    = 'Show file extensions, Explorer opens "This PC"'
    optFastBoot    = 'Disable Fast Startup (real shutdown)'
    optDefProf     = 'Apply user settings to future new user profiles as well'
    optsHint       = 'Kept: Microsoft Store, Photos, Calculator, Sticky Notes, Quick Assist, Defender, Media Player. Hover over the second option to see the full list.'
    baseTitle      = 'Basic setup'
    rename         = 'Rename computer:'
    renameHint     = 'max. 15 characters: A-Z, 0-9, hyphen. Takes effect after restart.'
    currentName    = 'current: {0}'
    power          = 'Configure power settings'
    monitorOff     = 'Turn off display after'
    standby        = 'Sleep after'
    onAC           = 'Plugged in:'
    onDC           = 'On battery:'
    timeouts       = '5 minutes|10 minutes|15 minutes|30 minutes|1 hour|2 hours|Never'
    upgrade        = 'Update all installed programs (winget upgrade --all)'
    wu             = 'Search for and install Windows updates (can take a while)'
    baseHint       = 'Warning: with updates the setup takes considerably longer – depending on the PC and connection 30 minutes to over an hour. Updates run at the very end, driver updates are excluded. In test mode Windows updates are only searched.'
    summaryTitle   = 'Summary'
    runRunning     = 'Setup is running …'
    runDone        = 'Done. A restart is recommended.'
    runDoneReboot  = 'Done. A restart is required.'
    runDoneErrors  = 'Done with {0} problem(s) – see log.'
    msgConfirm     = 'Start setup with these settings now?'
    msgInvalidName = "Invalid computer name: '{0}'`n`nAllowed: 1-15 characters, A-Z, 0-9 and hyphen (not at start/end), not digits only."
    msgTestNoReboot = 'Test mode: no restart will be performed.'
    msgReboot      = 'Restart the PC now?'
    msgRunning     = 'Setup is still running. Please wait until it has finished.'
    sumUser        = 'User:'
    sumComputer    = 'Computer:'
    sumMode        = 'Mode:'
    sumModeTest    = 'TEST (no changes)'
    sumBrowser     = 'BROWSER'
    sumDefault     = '-> default browser'
    sumApps        = 'PROGRAMS ({0})'
    sumNone        = '(none)'
    sumWindows     = 'WINDOWS'
    sumBase        = 'BASIC SETUP'
    sumName        = 'Computer name:'
    sumUnchanged   = 'unchanged'
    sumPowerAC     = 'Power (AC):'
    sumPowerDC     = 'Power (DC):'
    sumPower       = 'Power:'
    sumPowerFmt    = 'display {0}, sleep {1}'
    sumUpgrade     = 'Update programs (winget upgrade --all)'
    sumWU          = 'Install Windows updates'
    sumNote        = "User settings apply to the account above. If that is not the future user,`r`nkeep the option 'apply to future new user profiles' enabled."
    restoreDesc    = 'Before FreshWin'
    logTestMode    = 'TEST MODE'
    logUser        = 'User: {0}  |  Admin: {1}  |  Log: {2}'
    logWould       = '  [TEST] would run: {0} {1}'
    logRestore     = 'Restore point …'
    logWinget      = 'Checking winget …'
    logWingetTest  = '  [TEST] winget missing – would register App Installer'
    logWingetMissing = '  [!] winget not available – skipping program installation.'
    logWingetHint  = '      Open the Microsoft Store, update "App Installer" and start FreshWin again.'
    errWinget      = 'winget missing'
    logInstall     = 'Installing {0} ({1}) …'
    logSkipInstalled = '  already installed – skipped'
    logInstallErr  = '  [!] Error (exit code {0}) – see log for details'
    logBrowser     = 'Default browser: {0} …'
    logXmlTest     = '  [TEST] would write {0}:'
    logAssocOK     = '  association registered for new user profiles'
    logNoProgId    = '  No automatic association for this browser – please confirm in Settings at the end'
    logDism        = '  [!] DISM exit code {0}'
    errDism        = 'Default browser (DISM)'
    logStartTest   = '  [TEST] would start: {0}'
    logAppx        = 'Removing preinstalled consumer apps …'
    logAppxMissing = '  - {0} : not present'
    logAppxWould   = '  [TEST] - {0} : installed, would be removed'
    logAppxRemoved = '  - {0} : removed'
    logReg         = 'Registry settings …'
    logDefProf     = 'Default profile (new users) …'
    logDefProfErr  = '  [!] Could not load the default profile (exit code {0})'
    logRename      = 'Computer name: {0} -> {1}'
    logRenameOK    = '  OK (active after restart)'
    errRename      = 'Computer name'
    errRestore     = 'Restore point'
    logPower       = 'Power settings …'
    logUpgradeList = 'Available program updates (winget upgrade) …'
    logUpgradeTest = '  [TEST] would run: winget upgrade --all --silent …'
    logUpgrade     = 'Updating installed programs (winget upgrade --all) …'
    logUpgradeErr  = '  [!] Not all updates succeeded (exit code {0}) – see log for details'
    logWUSearch    = 'Searching for Windows updates (search only, may take a few minutes) …'
    logWUInstall   = 'Searching, downloading and installing Windows updates (can take a while) …'
    logWUNone      = '  No pending Windows updates'
    logWUTest      = '  [TEST] would download and install these updates'
    logWUErr       = '  [!] Windows Update exit code {0}'
    errWU          = 'Windows Update'
    logDone        = '===== Done ====='
    logProblems    = 'Problems with: {0}'
    logFile        = 'Log file: {0}'
    logSettingsTest = '[TEST] would open Settings > Default apps'
}
}

function T([string]$Key) {
    $s = $Strings[$script:Lang][$Key]
    if ($null -eq $s) { $s = $Strings['en'][$Key] }
    if ($null -eq $s) { return $Key }
    if ($args.Count) { return ($s -f $args) }
    return $s
}

if (-not $DryRun -and -not $IsAdmin) {
    [System.Windows.Forms.MessageBox]::Show((T 'needAdmin'), $AppName, 'OK', 'Error') | Out-Null
    return
}

# --- Log file next to the script, otherwise in TEMP ---
$suffix = ''
if ($DryRun) { $suffix = '_TEST' }
$logName = '{0}_{1}_{2:yyyyMMdd_HHmm}{3}.log' -f $AppName, $env:COMPUTERNAME, (Get-Date), $suffix
try {
    $script:LogFile = [IO.Path]::Combine([IO.Path]::GetDirectoryName($SetupFile), $logName)
    Add-Content -LiteralPath $script:LogFile -Value "$AppName $AppVersion - $(Get-Date)" -Encoding UTF8 -ErrorAction Stop }
catch {
    $script:LogFile = Join-Path $env:TEMP $logName
    Add-Content -LiteralPath $script:LogFile -Value "$AppName $AppVersion - $(Get-Date)" -Encoding UTF8 -ErrorAction SilentlyContinue
}

# ================================================================
#  Configuration
# ================================================================
# IdDe = optional German-language package, used when the UI language is German
$Browsers = @(
    [pscustomobject]@{ Name = 'Mozilla Firefox'; Id = 'Mozilla.Firefox'; IdDe = 'Mozilla.Firefox.de'; App = 'Firefox';
                       ProgHtml = 'FirefoxHTML-308046B0AF4A39CB'; ProgUrl = 'FirefoxURL-308046B0AF4A39CB';
                       Exe = "$env:ProgramFiles\Mozilla Firefox\firefox.exe" }
    [pscustomobject]@{ Name = 'Google Chrome'; Id = 'Google.Chrome'; IdDe = $null; App = 'Google Chrome';
                       ProgHtml = 'ChromeHTML'; ProgUrl = 'ChromeHTML'; Exe = $null }
    [pscustomobject]@{ Name = 'Brave'; Id = 'Brave.Brave'; IdDe = $null; App = 'Brave';
                       ProgHtml = 'BraveHTML'; ProgUrl = 'BraveHTML'; Exe = $null }
    [pscustomobject]@{ Name = 'Vivaldi'; Id = 'Vivaldi.Vivaldi'; IdDe = $null; App = 'Vivaldi';
                       ProgHtml = $null; ProgUrl = $null; Exe = $null }
    [pscustomobject]@{ Name = 'browserEdge'; Id = $null; IdDe = $null; App = $null;
                       ProgHtml = $null; ProgUrl = $null; Exe = $null }
)

# Def = checked at start. De / En = short description (keep it short, ~26 characters)
$AppCatalog = [ordered]@{
    catRuntimes = @(
        @{ Name = 'VC++ 2015-2022 x64';  Id = 'Microsoft.VCRedist.2015+.x64';       Def = $true;  De = 'Visual C++ 64-Bit';          En = 'Visual C++ 64-bit' }
        @{ Name = 'VC++ 2015-2022 x86';  Id = 'Microsoft.VCRedist.2015+.x86';       Def = $true;  De = 'Visual C++ 32-Bit';          En = 'Visual C++ 32-bit' }
        @{ Name = '.NET Desktop 8';      Id = 'Microsoft.DotNet.DesktopRuntime.8';  Def = $true;  De = '.NET-Programme (LTS)';       En = '.NET apps (LTS)' }
        @{ Name = '.NET Desktop 10';     Id = 'Microsoft.DotNet.DesktopRuntime.10'; Def = $true;  De = '.NET-Programme (LTS, neu)';  En = '.NET apps (LTS, new)' }
        @{ Name = 'DirectX Runtime';     Id = 'Microsoft.DirectX';                  Def = $false; De = 'für ältere Spiele';          En = 'for older games' }
    )
    catOffice = @(
        @{ Name = 'LibreOffice';         Id = 'TheDocumentFoundation.LibreOffice';  Def = $false; De = 'Office-Paket (kostenlos)';   En = 'office suite (free)' }
        @{ Name = 'ONLYOFFICE';          Id = 'ONLYOFFICE.DesktopEditors';          Def = $false; De = 'Office, MS-kompatibel';      En = 'office, MS compatible' }
        @{ Name = 'Adobe Acrobat Reader'; Id = 'Adobe.Acrobat.Reader.64-bit';       Def = $false; De = 'PDF-Viewer';                 En = 'PDF viewer' }
        @{ Name = 'SumatraPDF';          Id = 'SumatraPDF.SumatraPDF';              Def = $false; De = 'schlanker PDF-Viewer';       En = 'lightweight PDF viewer' }
        @{ Name = 'PDF24 Creator';       Id = 'geeksoftwareGmbH.PDF24Creator';      Def = $false; De = 'PDFs erstellen/bearbeiten';  En = 'create/edit PDFs' }
        @{ Name = 'Obsidian';            Id = 'Obsidian.Obsidian';                  Def = $false; De = 'Notizen (Markdown)';         En = 'notes (Markdown)' }
        @{ Name = 'DeepL';               Id = 'DeepL.DeepL';                        Def = $false; De = 'Übersetzer';                 En = 'translator' }
    )
    catComm = @(
        @{ Name = 'Thunderbird';         Id = 'Mozilla.Thunderbird'; IdDe = 'Mozilla.Thunderbird.de'; Def = $false; De = 'E-Mail-Client'; En = 'email client' }
        @{ Name = 'WhatsApp';            Id = '9NKSQGP7F2NH'; Source = 'msstore';   Def = $false; De = 'Messenger (Store)';          En = 'messenger (Store)' }
        @{ Name = 'Signal';              Id = 'OpenWhisperSystems.Signal';          Def = $false; De = 'Messenger';                  En = 'messenger' }
        @{ Name = 'Telegram';            Id = 'Telegram.TelegramDesktop';           Def = $false; De = 'Messenger';                  En = 'messenger' }
        @{ Name = 'Microsoft Teams';     Id = 'Microsoft.Teams';                    Def = $false; De = 'Chat & Meetings';            En = 'chat & meetings' }
        @{ Name = 'Zoom';                Id = 'Zoom.Zoom';                          Def = $false; De = 'Videokonferenz';             En = 'video meetings' }
        @{ Name = 'Slack';               Id = 'SlackTechnologies.Slack';            Def = $false; De = 'Team-Chat';                  En = 'team chat' }
    )
    catMedia = @(
        @{ Name = 'VLC';                 Id = 'VideoLAN.VLC';                       Def = $true;  De = 'Mediaplayer';                En = 'media player' }
        @{ Name = 'Audacity';            Id = 'Audacity.Audacity';                  Def = $false; De = 'Audio bearbeiten';           En = 'audio editor' }
        @{ Name = 'GIMP';                Id = 'GIMP.GIMP.3';                        Def = $false; De = 'Bildbearbeitung';            En = 'image editor' }
        @{ Name = 'Paint.NET';           Id = 'dotPDN.PaintDotNet';                 Def = $false; De = 'einfache Bildbearbeitung';   En = 'simple image editor' }
        @{ Name = 'IrfanView';           Id = 'IrfanSkiljan.IrfanView';             Def = $false; De = 'Bildbetrachter';             En = 'image viewer' }
        @{ Name = 'OBS Studio';          Id = 'OBSProject.OBSStudio';               Def = $false; De = 'Aufnahme & Streaming';       En = 'recording & streaming' }
        @{ Name = 'HandBrake';           Id = 'HandBrake.HandBrake';                Def = $false; De = 'Videos umwandeln';           En = 'video converter' }
    )
    catTools = @(
        @{ Name = '7-Zip';               Id = '7zip.7zip';                          Def = $true;  De = 'Packer (zip, 7z, rar)';      En = 'archiver (zip, 7z, rar)' }
        @{ Name = 'Notepad++';           Id = 'Notepad++.Notepad++';                Def = $true;  De = 'Texteditor';                 En = 'text editor' }
        @{ Name = 'Everything';          Id = 'voidtools.Everything';               Def = $false; De = 'blitzschnelle Dateisuche';   En = 'instant file search' }
        @{ Name = 'PowerToys';           Id = 'Microsoft.PowerToys';                Def = $false; De = 'Windows-Zusatzwerkzeuge';    En = 'Windows power tools' }
        @{ Name = 'ShareX';              Id = 'ShareX.ShareX';                      Def = $false; De = 'Screenshots & Aufnahmen';    En = 'screenshots & capture' }
        @{ Name = 'Greenshot';           Id = 'Greenshot.Greenshot';                Def = $false; De = 'Screenshots mit Markierung'; En = 'annotated screenshots' }
        @{ Name = 'WinDirStat';          Id = 'WinDirStat.WinDirStat';              Def = $false; De = 'Speicherbelegung';           En = 'disk usage' }
        @{ Name = 'TreeSize Free';       Id = 'JAMSoftware.TreeSize.Free';          Def = $false; De = 'Ordnergrößen';               En = 'folder sizes' }
    )
    catSecurity = @(
        @{ Name = 'Bitwarden';           Id = 'Bitwarden.Bitwarden';                Def = $false; De = 'Passwort-Manager (Cloud)';   En = 'password manager (cloud)' }
        @{ Name = 'KeePassXC';           Id = 'KeePassXCTeam.KeePassXC';            Def = $false; De = 'Passwort-Manager (lokal)';   En = 'password manager (local)' }
        @{ Name = 'Proton VPN';          Id = 'Proton.ProtonVPN';                   Def = $false; De = 'VPN';                        En = 'VPN' }
        @{ Name = 'Tailscale';           Id = 'Tailscale.Tailscale';                Def = $false; De = 'VPN / Mesh-Netz';            En = 'VPN / mesh network' }
        @{ Name = 'WireGuard';           Id = 'WireGuard.WireGuard';                Def = $false; De = 'VPN-Client';                 En = 'VPN client' }
    )
    catSystem = @(
        @{ Name = 'CrystalDiskInfo';     Id = 'CrystalDewWorld.CrystalDiskInfo';    Def = $false; De = 'Zustand der Laufwerke';      En = 'drive health' }
        @{ Name = 'HWiNFO';              Id = 'REALiX.HWiNFO';                      Def = $false; De = 'Hardware & Sensoren';        En = 'hardware & sensors' }
        @{ Name = 'CPU-Z';               Id = 'CPUID.CPU-Z';                        Def = $false; De = 'CPU-/RAM-Infos';             En = 'CPU/RAM info' }
        @{ Name = 'Rufus';               Id = 'Rufus.Rufus';                        Def = $false; De = 'bootfähige USB-Sticks';      En = 'bootable USB drives' }
        @{ Name = 'TeamViewer';          Id = 'TeamViewer.TeamViewer';              Def = $false; De = 'Fernwartung';                En = 'remote support' }
        @{ Name = 'AnyDesk';             Id = 'AnyDesk.AnyDesk';                    Def = $false; De = 'Fernwartung';                En = 'remote support' }
    )
    catDev = @(
        @{ Name = 'Visual Studio Code';  Id = 'Microsoft.VisualStudioCode';         Def = $false; De = 'Code-Editor';                En = 'code editor' }
        @{ Name = 'Git';                 Id = 'Git.Git';                            Def = $false; De = 'Versionsverwaltung';         En = 'version control' }
        @{ Name = 'PowerShell 7';        Id = 'Microsoft.PowerShell';               Def = $false; De = 'aktuelle PowerShell';        En = 'modern PowerShell' }
        @{ Name = 'Windows Terminal';    Id = 'Microsoft.WindowsTerminal';          Def = $false; De = 'Terminal mit Tabs';          En = 'tabbed terminal' }
        @{ Name = 'Python 3.14';         Id = 'Python.Python.3.14';                 Def = $false; De = 'Programmiersprache';         En = 'programming language' }
    )
    catCloud = @(
        @{ Name = 'Google Drive';        Id = 'Google.GoogleDrive';                 Def = $false; De = 'Cloud-Speicher';             En = 'cloud storage' }
        @{ Name = 'Dropbox';             Id = 'Dropbox.Dropbox';                    Def = $false; De = 'Cloud-Speicher';             En = 'cloud storage' }
        @{ Name = 'Nextcloud';           Id = 'Nextcloud.NextcloudDesktop';         Def = $false; De = 'eigene Cloud synchronisieren'; En = 'sync your own cloud' }
    )
    # Keep = preinstalled apps that must not be removed when this entry is selected
    catGames = @(
        @{ Name = 'Steam';               Id = 'Valve.Steam';                        Def = $false; De = 'Valve';                      En = 'Valve' }
        @{ Name = 'Epic Games Launcher'; Id = 'EpicGames.EpicGamesLauncher';        Def = $false; De = 'Epic Games Store';           En = 'Epic Games Store' }
        @{ Name = 'Ubisoft Connect';     Id = 'Ubisoft.Connect';                    Def = $false; De = 'Ubisoft';                    En = 'Ubisoft' }
        @{ Name = 'EA app';              Id = 'ElectronicArts.EADesktop';           Def = $false; De = 'Electronic Arts';            En = 'Electronic Arts' }
        @{ Name = 'Battle.net';          Id = 'Blizzard.BattleNet';                 Def = $false; De = 'Blizzard';                   En = 'Blizzard' }
        @{ Name = 'GOG Galaxy';          Id = 'GOG.Galaxy';                         Def = $false; De = 'GOG';                        En = 'GOG' }
        @{ Name = 'Rockstar Launcher';   Id = 'RockstarGames.Launcher';             Def = $false; De = 'Rockstar Games';             En = 'Rockstar Games' }
        @{ Name = 'Amazon Games';        Id = 'Amazon.Games';                       Def = $false; De = 'Prime Gaming';               En = 'Prime Gaming' }
        @{ Name = 'Xbox App';            Id = '9MV0B5HZVK9Z'; Source = 'msstore';   Def = $false; De = 'Game Pass (Store)';          En = 'Game Pass (Store)';
           Keep = @('Microsoft.GamingApp', 'Microsoft.XboxGamingOverlay', 'Microsoft.XboxGameOverlay',
                    'Microsoft.XboxSpeechToTextOverlay', 'Microsoft.Xbox.TCUI') }
        @{ Name = 'Minecraft Launcher';  Id = 'Mojang.MinecraftLauncher';           Def = $false; De = 'Minecraft';                  En = 'Minecraft' }
        @{ Name = 'Playnite';            Id = 'Playnite.Playnite';                  Def = $false; De = 'alle Spiele in einer Liste'; En = 'all games in one library' }
    )
    catGameTools = @(
        @{ Name = 'Discord';             Id = 'Discord.Discord';                    Def = $false; De = 'Chat / Voice';               En = 'chat / voice' }
        @{ Name = 'TeamSpeak 6';         Id = 'XPDCJ80KGNRVSS'; Source = 'msstore'; Def = $false; De = 'Voice-Chat (Store)';         En = 'voice chat (Store)' }
        @{ Name = 'TeamSpeak 3';         Id = 'TeamSpeakSystems.TeamSpeakClient';   Def = $false; De = 'Voice-Chat (klassisch)';     En = 'voice chat (classic)' }
        @{ Name = 'Mumble';              Id = 'Mumble.Mumble.Client';               Def = $false; De = 'Voice-Chat (Open Source)';   En = 'voice chat (open source)' }
        @{ Name = 'NVIDIA App';          Id = 'XP8CLZL93F5Z4P'; Source = 'msstore'; Def = $false; De = 'Treiber & Overlay (Store)';  En = 'drivers & overlay (Store)' }
        @{ Name = 'MSI Afterburner';     Id = 'Guru3D.Afterburner';                 Def = $false; De = 'GPU-Tuning & FPS-Anzeige';   En = 'GPU tuning & FPS overlay' }
        @{ Name = 'GeForce NOW';         Id = 'Nvidia.GeForceNow';                  Def = $false; De = 'Cloud-Gaming';               En = 'cloud gaming' }
        @{ Name = 'Parsec';              Id = 'Parsec.Parsec';                      Def = $false; De = 'Remote-Gaming';              En = 'remote gaming' }
        @{ Name = 'Moonlight';           Id = 'MoonlightGameStreamingProject.Moonlight'; Def = $false; De = 'Game-Streaming';         En = 'game streaming' }
        @{ Name = 'Logitech G HUB';      Id = 'Logitech.GHUB';                      Def = $false; De = 'Logitech-Zubehör';           En = 'Logitech peripherals' }
        @{ Name = 'SteelSeries GG';      Id = 'SteelSeries.GG';                     Def = $false; De = 'SteelSeries-Zubehör';        En = 'SteelSeries peripherals' }
        @{ Name = 'Corsair iCUE';        Id = 'Corsair.iCUE.5';                     Def = $false; De = 'Corsair-Zubehör & RGB';      En = 'Corsair peripherals & RGB' }
        @{ Name = 'CurseForge';          Id = 'Overwolf.CurseForge';                Def = $false; De = 'Mods (Minecraft u. a.)';     En = 'mods (Minecraft etc.)' }
    )
}

$AppxRemove = @(
    'Microsoft.BingNews', 'Microsoft.BingWeather', 'Microsoft.BingSearch', 'Microsoft.GetHelp',
    'Microsoft.Getstarted', 'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.MicrosoftOfficeHub',
    'Microsoft.People', 'Microsoft.PowerAutomateDesktop', 'Microsoft.Todos', 'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps', 'Microsoft.ZuneVideo', 'Microsoft.GamingApp', 'Microsoft.XboxGamingOverlay',
    'Microsoft.XboxGameOverlay', 'Microsoft.XboxSpeechToTextOverlay', 'Microsoft.Xbox.TCUI',
    'Microsoft.YourPhone', 'Microsoft.549981C3F5F10', 'Microsoft.MixedReality.Portal', 'Microsoft.SkypeApp',
    'Microsoft.Windows.DevHome', 'Microsoft.windowscommunicationsapps', 'Microsoft.OutlookForWindows',
    'MicrosoftCorporationII.MicrosoftFamily', 'MicrosoftTeams', 'Clipchamp.Clipchamp'
)

$Options = @(
    [pscustomobject]@{ Key = 'Restore';   Default = $true }
    [pscustomobject]@{ Key = 'Appx';      Default = $true }
    [pscustomobject]@{ Key = 'Ads';       Default = $true }
    [pscustomobject]@{ Key = 'Telemetry'; Default = $true }
    [pscustomobject]@{ Key = 'Widgets';   Default = $true }
    [pscustomobject]@{ Key = 'Explorer';  Default = $true }
    [pscustomobject]@{ Key = 'FastBoot';  Default = $true }
    [pscustomobject]@{ Key = 'DefProf';   Default = $true }
)

$TimeoutMinutes = @(5, 10, 15, 30, 60, 120, 0)

# ================================================================
#  Helpers
# ================================================================
$script:txtLog  = $null
$script:Running = $false
$script:OemCp   = 850
try { $script:OemCp = [int](Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage' -ErrorAction Stop).OEMCP } catch {}
$script:Errors = New-Object System.Collections.ArrayList

function Log([string]$msg) {
    $line = '{0:HH:mm:ss}  {1}' -f (Get-Date), $msg
    try { Add-Content -LiteralPath $script:LogFile -Value $line -Encoding UTF8 } catch {}
    if ($script:txtLog) {
        $script:txtLog.AppendText($line + "`r`n")
        [System.Windows.Forms.Application]::DoEvents()
    }
}

function Get-AppId($a) {
    if ($script:Lang -eq 'de' -and $a.IdDe) { return $a.IdDe }
    return $a.Id
}

# Start an external program without freezing the UI.
# -Always: run in test mode as well (read-only commands only).
function Run-Proc([string]$File, [string]$Arguments, [switch]$Always) {
    if ($DryRun -and -not $Always) {
        Log (T 'logWould' $File $Arguments)
        Start-Sleep -Milliseconds 120
        return 0
    }
    $script:LastOutput = ''
    $tmp = [IO.Path]::GetTempFileName()
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName        = 'cmd.exe'
    $psi.Arguments       = "/c `"$File $Arguments > `"$tmp`" 2>&1`""
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow  = $true
    $p = [System.Diagnostics.Process]::Start($psi)
    while (-not $p.HasExited) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 100
    }
    try {
        # Output is UTF-8 (winget) or OEM code page (dism, reg, powershell), depending on the program
        $bytes = [IO.File]::ReadAllBytes($tmp)
        try   { $out = (New-Object System.Text.UTF8Encoding($false, $true)).GetString($bytes) }
        catch { $out = [Text.Encoding]::GetEncoding($script:OemCp).GetString($bytes) }
        $script:LastOutput = $out
        if ($out) { Add-Content -LiteralPath $script:LogFile -Value $out -Encoding UTF8 }
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    } catch {}
    return $p.ExitCode
}

function Set-Reg([string]$Path, [string]$Name, [int]$Value) {
    if ($DryRun) { Log "  [TEST] REG $($Path -replace '^Registry::','')\$Name = $Value"; return }
    try {
        if (-not (Test-Path -LiteralPath $Path)) { New-Item -Path $Path -Force | Out-Null }
        New-ItemProperty -LiteralPath $Path -Name $Name -Value $Value -PropertyType DWord -Force | Out-Null
    } catch {
        Log "  [!] $Path\$Name : $($_.Exception.Message)"
    }
}

function Set-UserTweaks([string]$Root, $Opt) {
    $cdm = "$Root\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $adv = "$Root\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    if ($Opt.Ads) {
        foreach ($v in 'ContentDeliveryAllowed','OemPreInstalledAppsEnabled','PreInstalledAppsEnabled',
                       'PreInstalledAppsEverEnabled','SilentInstalledAppsEnabled','SoftLandingEnabled',
                       'SystemPaneSuggestionsEnabled','RotatingLockScreenOverlayEnabled',
                       'SubscribedContent-310093Enabled','SubscribedContent-338387Enabled',
                       'SubscribedContent-338388Enabled','SubscribedContent-338389Enabled',
                       'SubscribedContent-338393Enabled','SubscribedContent-353694Enabled',
                       'SubscribedContent-353696Enabled') {
            Set-Reg $cdm $v 0
        }
        Set-Reg "$Root\Software\Policies\Microsoft\Windows\Explorer" 'DisableSearchBoxSuggestions' 1
        Set-Reg $adv 'Start_IrisRecommendations' 0
        Set-Reg $adv 'ShowSyncProviderNotifications' 0
    }
    if ($Opt.Telemetry) {
        Set-Reg "$Root\Software\Microsoft\Windows\CurrentVersion\Privacy" 'TailoredExperiencesWithDiagnosticDataEnabled' 0
        Set-Reg "$Root\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" 'Enabled' 0
    }
    if ($Opt.Explorer) {
        Set-Reg $adv 'HideFileExt' 0
        Set-Reg $adv 'LaunchTo' 1
        Set-Reg $adv 'ShowTaskViewButton' 0
    }
}

# ================================================================
#  User interface
# ================================================================
# Every control with a translatable text is registered here so the
# language can be switched at runtime (see Apply-Language).
$script:LocCtl = New-Object System.Collections.ArrayList
# '&' marks a keyboard shortcut in WinForms - double it to show it literally
function Set-Text($ctl, [string]$text) { $ctl.Text = $text.Replace('&', '&&') }
function L($ctl, [string]$key) {
    [void]$script:LocCtl.Add(@{ Ctl = $ctl; Key = $key })
    Set-Text $ctl (T $key)
    return $ctl
}

$fontMain  = New-Object System.Drawing.Font('Segoe UI', 10)
$fontBold  = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
$fontTitle = New-Object System.Drawing.Font('Segoe UI Semibold', 16)
$fontSmall = New-Object System.Drawing.Font('Segoe UI', 8.5)
$fontMono  = New-Object System.Drawing.Font('Consolas', 9)
$accent    = [System.Drawing.Color]::FromArgb(0, 84, 147)

$form = New-Object System.Windows.Forms.Form
$form.Text            = "$AppName $AppVersion"
$form.Size            = New-Object System.Drawing.Size(820, 640)
$form.StartPosition   = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox     = $false
$form.Font            = $fontMain
$form.BackColor       = [System.Drawing.Color]::White

# --- Header ---
$header = New-Object System.Windows.Forms.Panel
$header.Dock = 'Top'; $header.Height = 78; $header.BackColor = $accent
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = $AppName; $lblTitle.Font = $fontTitle; $lblTitle.ForeColor = 'White'
$lblTitle.Location = New-Object System.Drawing.Point(20, 10); $lblTitle.AutoSize = $true
$lblStep = New-Object System.Windows.Forms.Label
$lblStep.ForeColor = [System.Drawing.Color]::FromArgb(210, 225, 240)
$lblStep.Location = New-Object System.Drawing.Point(22, 46); $lblStep.AutoSize = $true
$cbLang = New-Object System.Windows.Forms.ComboBox
$cbLang.DropDownStyle = 'DropDownList'; $cbLang.Width = 110
$cbLang.Location = New-Object System.Drawing.Point(670, 24)
[void]$cbLang.Items.AddRange(@('Deutsch', 'English'))
if ($script:Lang -eq 'de') { $cbLang.SelectedIndex = 0 } else { $cbLang.SelectedIndex = 1 }
$header.Controls.AddRange(@($lblTitle, $lblStep, $cbLang))
if ($DryRun) {
    $lblTest = L (New-Object System.Windows.Forms.Label) 'testBadge'
    $lblTest.Font = $fontBold; $lblTest.AutoSize = $true
    $lblTest.BackColor = [System.Drawing.Color]::FromArgb(200, 40, 40); $lblTest.ForeColor = 'White'
    $lblTest.Location = New-Object System.Drawing.Point(300, 26)
    $header.Controls.Add($lblTest)
}

# --- Footer ---
$footer = New-Object System.Windows.Forms.Panel
$footer.Dock = 'Bottom'; $footer.Height = 58
$footer.BackColor = [System.Drawing.Color]::FromArgb(243, 243, 243)
function New-Btn($x) {
    $b = New-Object System.Windows.Forms.Button
    $b.Size = New-Object System.Drawing.Size(150, 34)
    $b.Location = New-Object System.Drawing.Point($x, 12)
    return $b
}
$btnCancel = L (New-Btn 20)  'btnCancel'
$btnBack   = L (New-Btn 466) 'btnBack'
$btnNext   = New-Btn 632
$btnNext.BackColor = $accent; $btnNext.ForeColor = 'White'; $btnNext.FlatStyle = 'Flat'
$footer.Controls.AddRange(@($btnCancel, $btnBack, $btnNext))

$body = New-Object System.Windows.Forms.Panel
$body.Dock = 'Fill'; $body.Padding = New-Object System.Windows.Forms.Padding(24, 16, 24, 8)

function New-Page {
    $p = New-Object System.Windows.Forms.Panel
    $p.Dock = 'Fill'; $p.Visible = $false; $p.AutoScroll = $true
    $body.Controls.Add($p)
    return $p
}
function New-Label($parent, $key, $y, [switch]$Bold) {
    $l = New-Object System.Windows.Forms.Label
    $l.AutoSize = $true; $l.MaximumSize = New-Object System.Drawing.Size(740, 0)
    $l.Location = New-Object System.Drawing.Point(0, $y)
    if ($Bold) { $l.Font = $fontBold }
    $parent.Controls.Add($l)
    return (L $l $key)
}

# --- Page 1: browser ---
$pBrowser = New-Page
New-Label $pBrowser 'browserQuestion' 0 -Bold | Out-Null
$browserRadios = @()
$y = 36
foreach ($b in $Browsers) {
    $r = New-Object System.Windows.Forms.RadioButton
    $r.Tag = $b; $r.AutoSize = $true
    $r.Location = New-Object System.Drawing.Point(12, $y)
    if ($b.Id) { $r.Text = $b.Name } else { L $r $b.Name | Out-Null }
    $pBrowser.Controls.Add($r); $browserRadios += $r
    $y += 32
}
$browserRadios[0].Checked = $true
$chkDefaultBrowser = L (New-Object System.Windows.Forms.CheckBox) 'browserDefault'
$chkDefaultBrowser.Checked = $true
$chkDefaultBrowser.AutoSize = $true; $chkDefaultBrowser.Location = New-Object System.Drawing.Point(12, ($y + 14))
$pBrowser.Controls.Add($chkDefaultBrowser)
New-Label $pBrowser 'browserHint' ($y + 56) | Out-Null
foreach ($r in $browserRadios) {
    $r.Add_CheckedChanged({ $chkDefaultBrowser.Enabled = [bool](($browserRadios | Where-Object Checked | Select-Object -First 1).Tag.Id) })
}

# --- Page 2: programs ---
$pApps = New-Page
New-Label $pApps 'appsQuestion' 0 -Bold | Out-Null
$appChecks = @()
$infoLabels = @()
# Two columns; each group goes into the column that is currently shorter
$colY = @(34, 34)
foreach ($cat in $AppCatalog.Keys) {
    $col = 0; if ($colY[1] -lt $colY[0]) { $col = 1 }
    $gb = L (New-Object System.Windows.Forms.GroupBox) $cat
    $gb.Location = New-Object System.Drawing.Point(($col * 378), $colY[$col]); $gb.Width = 366
    $iy = 24
    foreach ($a in $AppCatalog[$cat]) {
        $c = New-Object System.Windows.Forms.CheckBox
        $c.Text = $a.Name; $c.Tag = $a; $c.Checked = $a.Def
        $c.Location = New-Object System.Drawing.Point(12, $iy); $c.Width = 170
        $info = New-Object System.Windows.Forms.Label
        $info.Tag = $a; $info.ForeColor = 'Gray'; $info.AutoSize = $true; $info.Font = $fontSmall
        $info.Location = New-Object System.Drawing.Point(184, ($iy + 4))
        $gb.Controls.AddRange(@($c, $info)); $appChecks += $c; $infoLabels += $info
        $iy += 28
    }
    $gb.Height = $iy + 8
    $pApps.Controls.Add($gb)
    $colY[$col] += $gb.Height + 12
}
$btnAll  = L (New-Object System.Windows.Forms.Button) 'btnAll'
$btnAll.Size  = New-Object System.Drawing.Size(90, 28); $btnAll.Location  = New-Object System.Drawing.Point(540, 0)
$btnNone = L (New-Object System.Windows.Forms.Button) 'btnNone'
$btnNone.Size = New-Object System.Drawing.Size(90, 28); $btnNone.Location = New-Object System.Drawing.Point(640, 0)
$btnAll.Add_Click({  foreach ($c in $appChecks) { $c.Checked = $true } })
$btnNone.Add_Click({ foreach ($c in $appChecks) { $c.Checked = $false } })
$pApps.Controls.AddRange(@($btnAll, $btnNone))

# --- Page 3: options / debloat ---
$pOpts = New-Page
New-Label $pOpts 'optsTitle' 0 -Bold | Out-Null
$optChecks = @{}
$y = 36
$tip = New-Object System.Windows.Forms.ToolTip
foreach ($o in $Options) {
    $c = L (New-Object System.Windows.Forms.CheckBox) ('opt' + $o.Key)
    $c.Checked = $o.Default; $c.AutoSize = $true
    $c.Location = New-Object System.Drawing.Point(12, $y)
    $pOpts.Controls.Add($c); $optChecks[$o.Key] = $c
    $y += 32
}
$tip.SetToolTip($optChecks['Appx'], ($AppxRemove -join "`n"))
New-Label $pOpts 'optsHint' ($y + 10) | Out-Null

# --- Page 4: basic setup ---
$pBase = New-Page
New-Label $pBase 'baseTitle' 0 -Bold | Out-Null

$chkRename = L (New-Object System.Windows.Forms.CheckBox) 'rename'
$chkRename.AutoSize = $true
$chkRename.Location = New-Object System.Drawing.Point(12, 40)
$txtName = New-Object System.Windows.Forms.TextBox
$txtName.Text = $env:COMPUTERNAME; $txtName.MaxLength = 15; $txtName.Width = 200; $txtName.Enabled = $false
$txtName.CharacterCasing = 'Upper'
$txtName.Location = New-Object System.Drawing.Point(210, 38)
$chkRename.Add_CheckedChanged({ $txtName.Enabled = $chkRename.Checked })
$pBase.Controls.AddRange(@($chkRename, $txtName))
$lblNameHint = New-Label $pBase 'renameHint' 68
$lblNameHint.ForeColor = 'Gray'; $lblNameHint.Left = 30
$lblCurName = New-Object System.Windows.Forms.Label
$lblCurName.AutoSize = $true; $lblCurName.ForeColor = 'Gray'
$lblCurName.Location = New-Object System.Drawing.Point(420, 41)
$pBase.Controls.Add($lblCurName)

$chkPower = L (New-Object System.Windows.Forms.CheckBox) 'power'
$chkPower.Checked = $true; $chkPower.AutoSize = $true
$chkPower.Location = New-Object System.Drawing.Point(12, 106)
$pBase.Controls.Add($chkPower)

function Fill-TimeoutBox($cb) {
    $idx = $cb.SelectedIndex
    $cb.Items.Clear()
    [void]$cb.Items.AddRange((T 'timeouts') -split '\|')
    $cb.SelectedIndex = $idx
}
function New-TimeoutBox($x, $y, [int]$minutes) {
    $cb = New-Object System.Windows.Forms.ComboBox
    $cb.DropDownStyle = 'DropDownList'; $cb.Width = 150
    $cb.Location = New-Object System.Drawing.Point($x, $y)
    [void]$cb.Items.AddRange((T 'timeouts') -split '\|')
    $cb.SelectedIndex = [array]::IndexOf($TimeoutMinutes, $minutes)
    $pBase.Controls.Add($cb)
    return $cb
}
(New-Label $pBase 'monitorOff' 140).Left = 180
(New-Label $pBase 'standby'    140).Left = 350
(New-Label $pBase 'onAC'       168).Left = 30
(New-Label $pBase 'onDC'       202).Left = 30
$cbMonAC = New-TimeoutBox 180 165 15
$cbSlpAC = New-TimeoutBox 350 165 60
$cbMonDC = New-TimeoutBox 180 199 5
$cbSlpDC = New-TimeoutBox 350 199 15
$timeoutBoxes = @($cbMonAC, $cbSlpAC, $cbMonDC, $cbSlpDC)
$chkPower.Add_CheckedChanged({ foreach ($cb in $timeoutBoxes) { $cb.Enabled = $chkPower.Checked } })

$chkUpgrade = L (New-Object System.Windows.Forms.CheckBox) 'upgrade'
$chkUpgrade.Checked = $true; $chkUpgrade.AutoSize = $true
$chkUpgrade.Location = New-Object System.Drawing.Point(12, 250)
$chkWU = L (New-Object System.Windows.Forms.CheckBox) 'wu'
$chkWU.Checked = $true; $chkWU.AutoSize = $true
$chkWU.Location = New-Object System.Drawing.Point(12, 282)
$pBase.Controls.AddRange(@($chkUpgrade, $chkWU))
$lblBaseHint = New-Label $pBase 'baseHint' 320
$lblBaseHint.ForeColor = [System.Drawing.Color]::FromArgb(200, 40, 40)

# --- Page 5: summary ---
$pSummary = New-Page
New-Label $pSummary 'summaryTitle' 0 -Bold | Out-Null
$txtSummary = New-Object System.Windows.Forms.TextBox
$txtSummary.Multiline = $true; $txtSummary.ReadOnly = $true; $txtSummary.ScrollBars = 'Vertical'
$txtSummary.Font = $fontMono; $txtSummary.BackColor = 'White'
$txtSummary.Location = New-Object System.Drawing.Point(0, 30); $txtSummary.Size = New-Object System.Drawing.Size(745, 380)
$pSummary.Controls.Add($txtSummary)

# --- Page 6: run ---
$pRun = New-Page
$lblRun = New-Label $pRun 'runRunning' 0 -Bold
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(0, 30); $progress.Size = New-Object System.Drawing.Size(745, 22)
$script:txtLog = New-Object System.Windows.Forms.TextBox
$script:txtLog.Multiline = $true; $script:txtLog.ReadOnly = $true; $script:txtLog.ScrollBars = 'Vertical'
$script:txtLog.Font = $fontMono; $script:txtLog.BackColor = 'White'
$script:txtLog.Location = New-Object System.Drawing.Point(0, 62); $script:txtLog.Size = New-Object System.Drawing.Size(745, 350)
$pRun.Controls.AddRange(@($progress, $script:txtLog))

$form.Controls.AddRange(@($body, $header, $footer))

# ================================================================
#  Flow / navigation
# ================================================================
$pages  = @($pBrowser, $pApps, $pOpts, $pBase, $pSummary, $pRun)
$titles = @('step1', 'step2', 'step3', 'step4', 'step5', 'stepRun')
$script:page = 0

function Get-Selection {
    $sel = [ordered]@{}
    $sel.Browser    = ($browserRadios | Where-Object Checked | Select-Object -First 1).Tag
    $sel.SetDefault = ($chkDefaultBrowser.Enabled -and $chkDefaultBrowser.Checked)
    $sel.Apps       = @($appChecks | Where-Object Checked | ForEach-Object { $_.Tag })
    $sel.Opt        = @{}
    foreach ($k in $optChecks.Keys) { $sel.Opt[$k] = $optChecks[$k].Checked }
    $sel.NewName  = $null
    if ($chkRename.Checked -and $txtName.Text.Trim() -ne $env:COMPUTERNAME) { $sel.NewName = $txtName.Text.Trim() }
    $sel.Power    = $null
    if ($chkPower.Checked) {
        $sel.Power = [ordered]@{
            'monitor-timeout-ac' = $TimeoutMinutes[$cbMonAC.SelectedIndex]; 'standby-timeout-ac' = $TimeoutMinutes[$cbSlpAC.SelectedIndex]
            'monitor-timeout-dc' = $TimeoutMinutes[$cbMonDC.SelectedIndex]; 'standby-timeout-dc' = $TimeoutMinutes[$cbSlpDC.SelectedIndex]
        }
    }
    $sel.Upgrade  = $chkUpgrade.Checked
    $sel.WU       = $chkWU.Checked
    return $sel
}

function Build-Summary {
    $s = Get-Selection
    $nl = "`r`n"
    $t  = '{0,-15} {1}\{2}' -f (T 'sumUser'), $env:USERDOMAIN, $env:USERNAME + $nl
    $t += '{0,-15} {1}' -f (T 'sumComputer'), $env:COMPUTERNAME + $nl
    if ($DryRun) { $t += '{0,-15} {1}' -f (T 'sumMode'), (T 'sumModeTest') + $nl }
    $bName = $s.Browser.Name
    if (-not $s.Browser.Id) { $bName = T $bName }
    $t += $nl + (T 'sumBrowser') + $nl + "  $bName"
    if ($s.Browser.Id) { $t += "  ($(Get-AppId $s.Browser))" }
    if ($s.SetDefault) { $t += '  ' + (T 'sumDefault') }
    $t += $nl + $nl + (T 'sumApps' $s.Apps.Count) + $nl
    if ($s.Apps.Count -eq 0) { $t += '  ' + (T 'sumNone') + $nl }
    foreach ($a in $s.Apps) { $t += '  - {0,-24} {1}' -f $a.Name, (Get-AppId $a); $t += $nl }
    $t += $nl + (T 'sumWindows') + $nl
    foreach ($o in $Options) {
        $mark = '[ ]'; if ($s.Opt[$o.Key]) { $mark = '[x]' }
        $t += "  $mark $(T ('opt' + $o.Key))" + $nl
    }
    $t += $nl + (T 'sumBase') + $nl
    if ($s.NewName) { $t += '  {0,-15} {1} -> {2}' -f (T 'sumName'), $env:COMPUTERNAME, $s.NewName + $nl }
    else            { $t += '  {0,-15} {1} ({2})' -f (T 'sumName'), (T 'sumUnchanged'), $env:COMPUTERNAME + $nl }
    if ($s.Power) {
        $t += '  {0,-15} {1}' -f (T 'sumPowerAC'), (T 'sumPowerFmt' $cbMonAC.SelectedItem $cbSlpAC.SelectedItem) + $nl
        $t += '  {0,-15} {1}' -f (T 'sumPowerDC'), (T 'sumPowerFmt' $cbMonDC.SelectedItem $cbSlpDC.SelectedItem) + $nl
    } else { $t += '  {0,-15} {1}' -f (T 'sumPower'), (T 'sumUnchanged') + $nl }
    $mark = '[ ]'; if ($s.Upgrade) { $mark = '[x]' }; $t += "  $mark $(T 'sumUpgrade')" + $nl
    $mark = '[ ]'; if ($s.WU)      { $mark = '[x]' }; $t += "  $mark $(T 'sumWU')" + $nl
    $t += $nl + (T 'sumNote')
    return $t
}

function Show-Page([int]$i) {
    for ($j = 0; $j -lt $pages.Count; $j++) { $pages[$j].Visible = ($j -eq $i) }
    $lblStep.Text     = T $titles[[Math]::Min($i, 5)]
    $btnBack.Enabled  = ($i -gt 0 -and $i -lt 5)
    $btnBack.Visible  = ($i -lt 5)
    if ($i -eq 4) {
        $txtSummary.Text = Build-Summary
        if ($DryRun) { $btnNext.Text = T 'btnStartTest' } else { $btnNext.Text = T 'btnStart' }
    } elseif ($i -lt 4) {
        $btnNext.Text = T 'btnNext'
    }
    $script:page = $i
}

function Apply-Language {
    foreach ($e in $script:LocCtl) { Set-Text $e.Ctl (T $e.Key) }
    foreach ($l in $infoLabels) { if ($script:Lang -eq 'de') { Set-Text $l $l.Tag.De } else { Set-Text $l $l.Tag.En } }
    foreach ($cb in $timeoutBoxes) { Fill-TimeoutBox $cb }
    $lblCurName.Text = T 'currentName' $env:COMPUTERNAME
    if ($script:page -lt 5) { Show-Page $script:page }
}

function Invoke-Setup {
    $s = Get-Selection
    $o = $s.Opt
    $script:Running = $true
    $btnNext.Enabled = $false; $btnCancel.Enabled = $false; $cbLang.Enabled = $false

    $total = 8 + $s.Apps.Count
    if ($s.Browser.Id) { $total++ }
    $progress.Maximum = $total; $progress.Value = 0
    function Step { if ($progress.Value -lt $progress.Maximum) { $progress.Value++ } }

    $mode = ''; if ($DryRun) { $mode = T 'logTestMode' }
    Log "===== $AppName $AppVersion $mode ====="
    Log (T 'logUser' "$env:USERDOMAIN\$env:USERNAME" $IsAdmin $script:LogFile)

    # 1) Restore point
    if ($o.Restore) {
        Log (T 'logRestore')
        if ($DryRun) { Log "  [TEST] Checkpoint-Computer `"$(T 'restoreDesc')`"" }
        else {
            # Windows creates at most one restore point per 24 h by default - lift the limit temporarily
            $srKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
            try {
                Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction Stop
                New-ItemProperty -Path $srKey -Name 'SystemRestorePointCreationFrequency' -Value 0 -PropertyType DWord -Force | Out-Null
                Checkpoint-Computer -Description (T 'restoreDesc') -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
                Log '  OK'
            } catch { Log "  [!] $($_.Exception.Message)"; [void]$script:Errors.Add((T 'errRestore')) }
            finally { Remove-ItemProperty -Path $srKey -Name 'SystemRestorePointCreationFrequency' -ErrorAction SilentlyContinue }
        }
    }
    Step

    # 2) winget
    $allApps = @()
    if ($s.Browser.Id) { $allApps += $s.Browser }
    $allApps += $s.Apps
    $wingetOk = $true
    if ($allApps.Count -gt 0) {
        Log (T 'logWinget')
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            if ($DryRun) { Log (T 'logWingetTest') }
            else {
                try { Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction Stop } catch {}
                Start-Sleep 3
            }
        }
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            Log '  OK'
            Run-Proc 'winget' 'source update' | Out-Null
        } else {
            $wingetOk = $false
            Log (T 'logWingetMissing')
            Log (T 'logWingetHint')
            [void]$script:Errors.Add((T 'errWinget'))
        }
    }
    Step

    # 3) Programs
    foreach ($a in $allApps) {
        if ($wingetOk) {
            $id = Get-AppId $a
            Log (T 'logInstall' $a.Name $id)
            $chk = Run-Proc 'winget' "list --id $id -e --accept-source-agreements" -Always
            if ($chk -eq 0) {
                Log (T 'logSkipInstalled')
            } else {
                $src = ''; if ($a.Source) { $src = " --source $($a.Source)" }
                $rc = Run-Proc 'winget' "install --id $id -e$src --silent --accept-package-agreements --accept-source-agreements --disable-interactivity"
                if ($rc -eq 0) { if (-not $DryRun) { Log '  OK' } }
                else { Log (T 'logInstallErr' $rc); [void]$script:Errors.Add($a.Name) }
            }
        }
        Step
    }

    # 4) Default browser
    if ($s.SetDefault) {
        $b = $s.Browser
        Log (T 'logBrowser' $b.Name)
        if ($b.ProgHtml) {
            $dir = Join-Path $env:ProgramData $AppName
            $xmlPath = Join-Path $dir 'DefaultAssoc.xml'
            $xml  = '<?xml version="1.0" encoding="UTF-8"?>' + "`r`n<DefaultAssociations>`r`n"
            foreach ($ext in '.htm', '.html', '.shtml', '.xht', '.xhtml') {
                $xml += "  <Association Identifier=`"$ext`" ProgId=`"$($b.ProgHtml)`" ApplicationName=`"$($b.App)`" />`r`n"
            }
            foreach ($proto in 'http', 'https') {
                $xml += "  <Association Identifier=`"$proto`" ProgId=`"$($b.ProgUrl)`" ApplicationName=`"$($b.App)`" />`r`n"
            }
            $xml += '</DefaultAssociations>'
            if ($DryRun) {
                Log (T 'logXmlTest' $xmlPath)
                foreach ($l in ($xml -split "`r`n")) { Log "         $l" }
            } else {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
                Set-Content -LiteralPath $xmlPath -Value $xml -Encoding UTF8
            }
            $rc = Run-Proc 'dism.exe' "/Online /Import-DefaultAppAssociations:`"$xmlPath`""
            if ($DryRun) { }
            elseif ($rc -eq 0) { Log (T 'logAssocOK') }
            else { Log (T 'logDism' $rc); [void]$script:Errors.Add((T 'errDism')) }
        } else {
            Log (T 'logNoProgId')
        }
        if ($b.Exe) {
            if ($DryRun) { Log (T 'logStartTest' "`"$($b.Exe)`" -setDefaultBrowser") }
            elseif (Test-Path -LiteralPath $b.Exe) { Start-Process -FilePath $b.Exe -ArgumentList '-setDefaultBrowser' }
        }
    }

    # 5) Remove consumer apps
    if ($o.Appx) {
        Log (T 'logAppx')
        $prov = @()
        if ($IsAdmin) { $prov = @(Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue) }
        $keep = @($s.Apps | ForEach-Object { $_.Keep })
        foreach ($n in $AppxRemove) {
            if ($keep -contains $n) { continue }
            if ($IsAdmin) { $pkg = @(Get-AppxPackage -AllUsers -Name $n -ErrorAction SilentlyContinue) }
            else          { $pkg = @(Get-AppxPackage -Name $n -ErrorAction SilentlyContinue) }
            $pp = @($prov | Where-Object DisplayName -eq $n)
            if ($pkg.Count -eq 0 -and $pp.Count -eq 0) {
                if ($DryRun) { Log (T 'logAppxMissing' $n) }
                continue
            }
            if ($DryRun) { Log (T 'logAppxWould' $n); continue }
            try {
                $pkg | Remove-AppxPackage -AllUsers -ErrorAction Stop
                $pp  | Remove-AppxProvisionedPackage -Online -ErrorAction Stop | Out-Null
                Log (T 'logAppxRemoved' $n)
            } catch { Log "  [!] $n : $($_.Exception.Message)" }
            [System.Windows.Forms.Application]::DoEvents()
        }
    }
    Step

    # 6) Registry
    Log (T 'logReg')
    $hklm = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft'
    if ($o.Ads) {
        Set-Reg "$hklm\Windows\CloudContent" 'DisableWindowsConsumerFeatures' 1
        Set-Reg "$hklm\Windows\CloudContent" 'DisableConsumerAccountStateContent' 1
    }
    if ($o.Telemetry) {
        Set-Reg "$hklm\Windows\DataCollection" 'AllowTelemetry' 1
        Set-Reg "$hklm\Windows\AdvertisingInfo" 'DisabledByGroupPolicy' 1
    }
    if ($o.Widgets)  { Set-Reg "$hklm\Dsh" 'AllowNewsAndInterests' 0 }
    if ($o.FastBoot) { Set-Reg 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled' 0 }

    Set-UserTweaks 'Registry::HKEY_CURRENT_USER' $o

    if ($o.DefProf -and ($o.Ads -or $o.Telemetry -or $o.Explorer)) {
        Log (T 'logDefProf')
        $rc = Run-Proc 'reg.exe' "load HKU\DefUser `"$env:SystemDrive\Users\Default\NTUSER.DAT`""
        if ($rc -eq 0) {
            Set-UserTweaks 'Registry::HKEY_USERS\DefUser' $o
            [gc]::Collect(); [gc]::WaitForPendingFinalizers(); Start-Sleep -Milliseconds 500
            Run-Proc 'reg.exe' 'unload HKU\DefUser' | Out-Null
        } else { Log (T 'logDefProfErr' $rc) }
    }
    if (-not $DryRun) { Log '  OK' }
    Step

    # 7) Computer name
    if ($s.NewName) {
        Log (T 'logRename' $env:COMPUTERNAME $s.NewName)
        if ($DryRun) { Log "  [TEST] Rename-Computer -NewName $($s.NewName)" }
        else {
            try { Rename-Computer -NewName $s.NewName -Force -ErrorAction Stop; Log (T 'logRenameOK') }
            catch { Log "  [!] $($_.Exception.Message)"; [void]$script:Errors.Add((T 'errRename')) }
        }
    }
    Step

    # 8) Power settings
    if ($s.Power) {
        Log (T 'logPower')
        foreach ($k in $s.Power.Keys) {
            $rc = Run-Proc 'powercfg.exe' "/change $k $($s.Power[$k])"
            if ($rc -ne 0) { Log "  [!] powercfg $k (exit code $rc)" }
        }
        if (-not $DryRun) { Log '  OK' }
    }
    Step

    # 9) Update programs
    if ($s.Upgrade -and $wingetOk) {
        if ($DryRun) {
            Log (T 'logUpgradeList')
            Run-Proc 'winget' 'upgrade --accept-source-agreements' -Always | Out-Null
            foreach ($l in ($script:LastOutput -split "`r?`n")) {
                $l = ($l -split "`r")[-1].TrimEnd()
                if ($l -and $l -notmatch '^[\s\-\\|/]*$' -and $l -notmatch '[█▒]') { Log "    $l" }
            }
            Log (T 'logUpgradeTest')
        } else {
            Log (T 'logUpgrade')
            $rc = Run-Proc 'winget' 'upgrade --all --silent --accept-package-agreements --accept-source-agreements --disable-interactivity'
            if ($rc -eq 0) { Log '  OK' } else { Log (T 'logUpgradeErr' $rc) }
        }
    }
    Step

    # 10) Windows Update
    $script:RebootNeeded = $false
    if ($s.WU) {
        $searchOnly = '$false'; if ($DryRun) { $searchOnly = '$true' }
        $wu = @"
`$ErrorActionPreference = 'Stop'
try {
    `$ses = New-Object -ComObject Microsoft.Update.Session
    `$ses.ClientApplicationID = '$AppName'
    `$res = `$ses.CreateUpdateSearcher().Search("IsInstalled=0 and Type='Software' and IsHidden=0")
    "UPDATES=" + `$res.Updates.Count
    foreach (`$u in `$res.Updates) { "  - " + `$u.Title }
    if (`$res.Updates.Count -eq 0 -or $searchOnly) { exit 0 }
    `$col = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach (`$u in `$res.Updates) { if (-not `$u.EulaAccepted) { `$u.AcceptEula() }; [void]`$col.Add(`$u) }
    `$dl = `$ses.CreateUpdateDownloader(); `$dl.Updates = `$col; [void]`$dl.Download()
    `$ins = `$ses.CreateUpdateInstaller(); `$ins.Updates = `$col; `$r = `$ins.Install()
    "RESULT=" + `$r.ResultCode + " REBOOT=" + `$r.RebootRequired
    if (`$r.ResultCode -in 2,3) { exit 0 } else { exit 2 }
} catch { "ERROR: " + `$_.Exception.Message; exit 1 }
"@
        $b64 = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($wu))
        if ($DryRun) { Log (T 'logWUSearch') } else { Log (T 'logWUInstall') }
        $rc = Run-Proc 'powershell.exe' "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $b64" -Always
        foreach ($l in ($script:LastOutput -split "`r?`n")) {
            if ($l -match '^(UPDATES=|  - |RESULT=|ERROR)') { Log "  $l" }
            if ($l -match 'REBOOT=True') { $script:RebootNeeded = $true }
        }
        if ($rc -eq 0 -and $script:LastOutput -match 'UPDATES=0') { Log (T 'logWUNone') }
        elseif ($DryRun -and $rc -eq 0) { Log (T 'logWUTest') }
        elseif ($rc -ne 0) { Log (T 'logWUErr' $rc); [void]$script:Errors.Add((T 'errWU')) }
    }
    Step

    # Finish
    $progress.Value = $progress.Maximum
    Log (T 'logDone')
    if ($script:Errors.Count -gt 0) {
        Log (T 'logProblems' ($script:Errors -join ', '))
        $lblRun.Text = T 'runDoneErrors' $script:Errors.Count
        $lblRun.ForeColor = [System.Drawing.Color]::FromArgb(180, 60, 0)
    } else {
        $lblRun.Text = T 'runDone'
        if ($script:RebootNeeded -or $s.NewName) { $lblRun.Text = T 'runDoneReboot' }
        $lblRun.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 60)
    }
    Log (T 'logFile' $script:LogFile)

    if ($s.SetDefault) {
        if ($DryRun) { Log (T 'logSettingsTest') }
        else { Start-Process 'ms-settings:defaultapps' }
    }

    $script:Running = $false
    $btnCancel.Text = T 'btnClose'; $btnCancel.Enabled = $true
    $btnNext.Text = T 'btnReboot'; $btnNext.Enabled = $true
    $script:page = 6
}

$cbLang.Add_SelectedIndexChanged({
    if ($cbLang.SelectedIndex -eq 0) { $script:Lang = 'de' } else { $script:Lang = 'en' }
    Apply-Language
})
$form.Add_FormClosing({
    if ($script:Running) {
        $_.Cancel = $true
        [System.Windows.Forms.MessageBox]::Show((T 'msgRunning'), $AppName, 'OK', 'Information') | Out-Null
    }
})
$btnBack.Add_Click({ if ($script:page -gt 0) { Show-Page ($script:page - 1) } })
$btnCancel.Add_Click({ $form.Close() })
$btnNext.Add_Click({
    switch ($script:page) {
        3 {
            if ($chkRename.Checked) {
                $n = $txtName.Text.Trim()
                if ($n -notmatch '^[A-Za-z0-9-]{1,15}$' -or $n -match '^[0-9]+$' -or $n.StartsWith('-') -or $n.EndsWith('-')) {
                    [System.Windows.Forms.MessageBox]::Show((T 'msgInvalidName' $n), $AppName, 'OK', 'Warning') | Out-Null
                    return
                }
            }
            Show-Page 4
        }
        4 {
            if (-not $DryRun) {
                $r = [System.Windows.Forms.MessageBox]::Show((T 'msgConfirm'), $AppName, 'YesNo', 'Question')
                if ($r -ne 'Yes') { return }
            }
            Show-Page 5
            Invoke-Setup
        }
        6 {
            if ($DryRun) {
                [System.Windows.Forms.MessageBox]::Show((T 'msgTestNoReboot'), $AppName) | Out-Null
            } else {
                $r = [System.Windows.Forms.MessageBox]::Show((T 'msgReboot'), $AppName, 'YesNo', 'Question')
                if ($r -eq 'Yes') { shutdown.exe /r /t 5; $form.Close() }
            }
        }
        default { Show-Page ($script:page + 1) }
    }
})

Apply-Language
Show-Page 0
[void]$form.ShowDialog()
