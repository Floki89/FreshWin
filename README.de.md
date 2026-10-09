# FreshWin

[English](README.md) | **Deutsch**

Ein grafischer Einrichtungsassistent für frisch installierte Windows‑11‑PCs, in einer einzigen `.bat`-Datei.
Browser und Programme auswählen, Windows aufräumen, Computername und Energieoptionen setzen,
alle Updates installieren, fertig. Keine Installation, keine Abhängigkeiten.

| | |
|---|---|
| ![Browserauswahl](docs/browser-de.png) | ![Programmauswahl mit Profilen](docs/programs-de.png) |
| ![Windows aufräumen](docs/cleanup-de.png) | ![Darstellung](docs/appearance-de.png) |

## Funktionen

- **Browser**: Firefox, Chrome, Brave, Vivaldi oder Edge behalten, auf Wunsch als Standardbrowser
- **77 Programme** in 11 Kategorien, still installiert über [winget](https://learn.microsoft.com/de-de/windows/package-manager/winget/)
  (Laufzeitumgebungen, Büro & PDF, Kommunikation, Multimedia, Werkzeuge, Sicherheit & VPN, System & Fernwartung,
  Entwicklung, Cloud, Gaming-Launcher, Gaming-Voice & Tools). Bereits installierte Programme werden übersprungen
- **Gaming**: Steam, Epic, Ubisoft Connect, EA app, Battle.net, GOG, Rockstar, Amazon Games, Xbox-App,
  Discord, TeamSpeak, Mumble, NVIDIA App, MSI Afterburner, Software für Mäuse/Headsets und mehr.
  Wer die Xbox-App auswählt, behält beim Aufräumen die Xbox-Komponenten
- **Profile**: *Gaming-PC* und *Büro-PC* haken mit einem Klick passende Programme an und belegen
  die Darstellungsseite vor (die NVIDIA App nur, wenn eine NVIDIA-Grafikkarte verbaut ist)
- **Darstellung**: Dunkel-/Hellmodus, Ausrichtung und Suche der Taskleiste, klassisches Rechtsklick-Menü,
  versteckte Dateien anzeigen, Copilot-Schaltfläche ausblenden, „Task beenden“ in der Taskleiste,
  NumLock beim Start, Mausbeschleunigung aus, Einrastfunktion-Abfrage aus
- **Windows aufräumen**: entfernt vorinstallierte Consumer-Apps (Xbox, Bing News, Solitaire, Clipchamp …),
  schaltet Werbung, Vorschläge, die Bing-Suche im Startmenü und Widgets ab, setzt die Telemetrie auf Minimum,
  zeigt Dateiendungen an und deaktiviert den Schnellstart
- **Neue Benutzerprofile** erhalten dieselben Einstellungen (über das Standardprofil)
- **Grundeinrichtung**: Computer umbenennen, Zeiten für Bildschirm aus und Energiesparmodus (Netz und Akku)
- **Updates**: `winget upgrade --all` und Windows Update, auf Wunsch mit Treibern, in bis zu 3 Durchgängen
- **Absicherung**: vor allen Änderungen wird ein Wiederherstellungspunkt erstellt, und eine Zusammenfassung zeigt vor dem Start alles an
- **Für frische PCs gemacht**: verhindert den Energiesparmodus während des Setups, wartet auf winget, versucht es
  erneut, wenn Windows Update gerade installiert, überspringt hängende Installer nach 20 Minuten, warnt bei fehlendem
  Internet, Akkubetrieb oder fremdem Adminkonto und läuft ohne Konsolenfenster, das man versehentlich schließen könnte
- **Logdatei** neben dem Skript (auf dem Desktop beim Start per Ein-Zeilen-Befehl)
- **Deutsch und Englisch**, automatisch erkannt und im Fenster umschaltbar
- **Testmodus**: zeigt genau, was passieren *würde*, und ändert nichts

## Benutzung

### Weg 1: ein Befehl, kein Download (empfohlen)

1. Rechtsklick auf den Startknopf → **Terminal (Administrator)**
2. Diese Zeile einfügen und Enter drücken:

   ```powershell
   irm https://raw.githubusercontent.com/Floki89/FreshWin/main/FreshWin.bat | iex
   ```

Kein Download, keine SmartScreen-Warnung. Das Terminal-Fenster offen lassen, solange FreshWin läuft.
Testmodus: vorher `$env:SETUP_ARGS = '/test'` ausführen.

### Weg 2: herunterladen

1. [`FreshWin.bat`](https://github.com/Floki89/FreshWin/releases/latest/download/FreshWin.bat) herunterladen (immer die neueste Version).
2. Doppelklicken und die Adminabfrage bestätigen.
3. Dem Assistenten folgen.

> [!NOTE]
> Edge und Windows SmartScreen können bei einer heruntergeladenen `.bat` warnen. In Edge *Behalten* wählen, dann
> *Weitere Informationen → Trotzdem ausführen*. Im Zweifel das Skript vorher lesen: Es ist reiner Text.

### Weg 3: USB-Stick

`FreshWin.bat` auf einen USB-Stick kopieren und am neuen PC doppelklicken. Praktisch, wenn man mehrere PCs einrichtet.

### Optionen

| Aufruf | Wirkung |
|---|---|
| `FreshWin.bat /test` | Testmodus, keine Adminrechte nötig, es wird nichts verändert |
| `FreshWin.bat /lang:de` / `/lang:en` | Sprache festlegen |
| Datei in `FreshWin-TEST.bat` umbenennen | Testmodus per Doppelklick |

## Voraussetzungen

- Windows 11 (das meiste funktioniert auch unter Windows 10). **Nicht im S-Modus**: den S-Modus vorher verlassen
  (Einstellungen → System → Aktivierung), dort laufen keine Skripte
- Administratorrechte (außer im Testmodus)
- Internetverbindung. Fehlt der WLAN-Treiber, hilft ein LAN-Kabel oder USB-Tethering mit dem Handy
- winget (*App-Installer*) ist bei Windows 11 vorinstalliert. Direkt nach der ersten Anmeldung wartet FreshWin bis zu
  3 Minuten, bis es bereit ist, und installiert bei Bedarf eine aktuelle Version

## Anpassen

Alle Listen stehen oben im PowerShell-Teil von `FreshWin.bat`:

- `$Browsers` enthält die Browser
- `$AppCatalog` enthält die Programme nach Kategorie. `Id` ist die winget-ID (finden mit `winget search <Name>`;
  `Source = 'msstore'` für Apps aus dem Microsoft Store),
  `Def = $true` hakt das Programm beim Start an, `De`/`En` enthalten die Kurzbeschreibungen
- `$Profiles` enthält die Profile (winget-IDs und Vorgaben für die Darstellung)
- `$AppxRemove` enthält die vorinstallierten Apps, die entfernt werden
- `$Strings` enthält alle Texte (Deutsch und Englisch)

## Hinweise

- Windows 11 lässt den Standardbrowser für den aktuellen Benutzer nicht per Skript setzen. FreshWin
  hinterlegt ihn (wo möglich) für neue Profile und öffnet am Ende *Einstellungen → Standard-Apps*.
- Telemetriestufe 1 („Erforderlich“) ist unter Windows Home/Pro das Minimum.
- Alle Änderungen sind normale Windows-Einstellungen und lassen sich in den Einstellungen oder über den Wiederherstellungspunkt zurücknehmen.

## Haftungsausschluss

> [!CAUTION]
> **Benutzung auf eigene Verantwortung.** FreshWin ändert Systemeinstellungen und entfernt Apps.
> **Zuerst im Testmodus ausprobieren** (`FreshWin.bat /test`) und vorzugsweise auf frisch installierten Rechnern einsetzen.

## Lizenz

[MIT](LICENSE)
