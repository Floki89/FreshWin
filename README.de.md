# FreshWin

[English](README.md) | **Deutsch**

Ein grafischer Einrichtungsassistent für frisch installierte Windows‑11‑PCs, in einer einzigen `.bat`-Datei.
Browser und Programme auswählen, Windows aufräumen, Computername und Energieoptionen setzen,
alle Updates installieren, fertig. Keine Installation, keine Abhängigkeiten.

![Browserauswahl](docs/browser-de.png)
![Programmauswahl](docs/programs-de.png)
![Darstellung](docs/appearance-de.png)

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
- **Updates**: `winget upgrade --all` und Windows Update (ohne Treiber)
- **Absicherung**: vor allen Änderungen wird ein Wiederherstellungspunkt erstellt, und eine Zusammenfassung zeigt vor dem Start alles an
- **Logdatei** neben dem Skript (oder in `%TEMP%`)
- **Deutsch und Englisch**, automatisch erkannt und im Fenster umschaltbar
- **Testmodus**: zeigt genau, was passieren *würde*, und ändert nichts

## Benutzung

1. [`FreshWin.bat`](FreshWin.bat) herunterladen (auf GitHub: *Raw* → speichern, oder das Repository als ZIP).
2. Doppelklicken und die Adminabfrage bestätigen.
3. Dem Assistenten folgen.

> Windows SmartScreen kann bei einer heruntergeladenen `.bat` warnen. Wähle *Weitere Informationen → Trotzdem ausführen*
> oder Rechtsklick auf die Datei → *Eigenschaften* → *Zulassen*. Im Zweifel das Skript vorher lesen:
> Es ist reiner Text.

### Optionen

| Aufruf | Wirkung |
|---|---|
| `FreshWin.bat /test` | Testmodus, keine Adminrechte nötig, es wird nichts verändert |
| `FreshWin.bat /lang:de` / `/lang:en` | Sprache festlegen |
| Datei in `FreshWin-TEST.bat` umbenennen | Testmodus per Doppelklick |

## Voraussetzungen

- Windows 11 (das meiste funktioniert auch unter Windows 10)
- Administratorrechte (außer im Testmodus)
- Internetverbindung
- winget (*App-Installer*). Auf aktuellen Windows‑11‑Installationen ist es vorhanden. Bei sehr frischen
  Installationen ggf. zuerst den *App-Installer* im Microsoft Store aktualisieren, falls FreshWin ihn als fehlend meldet

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

Benutzung auf eigene Verantwortung. FreshWin ändert Systemeinstellungen und entfernt Apps. Am besten
zuerst im Testmodus ausprobieren und vorzugsweise auf frisch installierten Rechnern einsetzen.

## Lizenz

[MIT](LICENSE)
