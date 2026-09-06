# PC-Konfigurator-GUI

**PC-Konfigurator-GUI** ist der grafische Nachfolger des konsolenbasierten
Automatisierungs-Tools **PC-Konfigurator**. Die GUI ist als PowerShell/WPF-
Anwendung umgesetzt und wird mit PS2EXE als eigenständige EXE kompiliert.

Autor: Thomas Gorontzy · Version 1.0.0.0
Plattform: Windows 10 (Build 18362+) / Windows 11, Office 2013+

## Herkunft und Einsatzbereich

Das Vorhaben baut auf dem konsolenbasierten Projekt
**PC-Konfigurator** auf. Die GUI bildet dessen Konfigurationsabläufe in einem
WPF-Assistenten ab und ergänzt sie um geführte Auswahl, Systemprüfung,
Live-Protokollierung und einen automatischen Benutzer-Installationsablauf.

Die Anwendung richtet Arbeitsumgebungen mit vorbereiteten Office-Vorlagen,
Schriftarten und Corporate-Design-Einstellungen ein. Sie konfiguriert Word,
Excel und klassisches Outlook, synchronisiert bei Bedarf Outlook-Signaturen
und nimmt ausgewählte Windows-Explorer-Einstellungen vor. Vor dem Ersetzen
persönlicher Vorlagen werden Sicherungskopien angelegt.

## Kernfunktionen

- Synchronisation der Datei-Vorlagen (`Datei-Vorlagen\`) und Schriftarten (`Fonts\`)
- Auswahl von Zielort, Corporate Design, Schriftart und Schriftgrößen
- Vorbereitete Word-, Excel- und Outlook-Vorlagen ohne COM-Schriftbearbeitung
- Outlook-Signatur-Synchronisation und klassische Outlook-MailSettings
- Office-Registry, Themes, Autokorrektur und Schnellzugriffsleisten
- Windows-Explorer-Anpassungen und ausführliches Live-Logging

## Start

1. Release-ZIP entpacken.
2. Office-Dateien speichern und Word, Excel sowie Outlook schließen.
3. `PC-Konfigurator-GUI.exe` direkt aus dem Releaseordner starten.
4. Dem WPF-Assistenten folgen.

Beim ersten Start kopiert die EXE sich mit allen Laufzeitdateien automatisch nach:

`%LOCALAPPDATA%\PC-Konfigurator-GUI`

Anschließend startet sie aus diesem Benutzerordner. Ein manuelles
Installationsskript ist nicht erforderlich.

## Build und Release

Build:

```powershell
.\build.ps1
```

Vollständiges Release-ZIP:

```powershell
.\create-release.ps1
```

Das ZIP liegt unter `release\` und enthält die EXE sowie `README.MD`. Die
Datei-Vorlagen, Fonts, Dokumentationen und `src\` sind vollständig in der EXE
eingebettet und werden beim Start nach LocalAppData extrahiert.

## Voraussetzungen

- Windows 10 (Build 18362+) oder Windows 11
- Windows PowerShell 5.1 oder höher
- Microsoft Office 2013 oder höher

## Logs

- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Logs\`
- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Robocopy-Logs\`

Weitere Informationen stehen unter `docs\DOKUMENTATION_ANWENDER.md` und
`docs\DOKUMENTATION_TECHNIK.md`.
