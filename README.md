# PC-Konfigurator-GUI

<!-- release-metadata:start -->
> **Release-Version:** 1.0.4  
> **Stand:** 2026-09-06
<!-- release-metadata:end -->

**PC-Konfigurator-GUI** ist der grafische Nachfolger des konsolenbasierten
Automatisierungs-Tools **PC-Konfigurator**. Die GUI ist als PowerShell-
Anwendung auf Basis der Windows Presentation Foundation umgesetzt und wird
mit PS2EXE als eigenstÃ¤ndige EXE kompiliert.

Die Windows Presentation Foundation stellt die interaktive grafische
BenutzeroberflÃ¤che bereit. Sie fÃ¼hrt durch die Konfiguration, macht Auswahl-
und BestÃ¤tigungsschritte verstÃ¤ndlich zugÃ¤nglich und zeigt den Fortschritt
sowie Protokollmeldungen wÃ¤hrend der AusfÃ¼hrung an.

Autor: Thomas Gorontzy Â· Version 1.0.1
Plattform: Windows 10 (Build 18362+) / Windows 11, Office 2013+

## Herkunft und Einsatzbereich

Das Vorhaben baut auf dem konsolenbasierten Projekt
**PC-Konfigurator** auf. Die GUI bildet dessen KonfigurationsablÃ¤ufe in einem
Windows-Presentation-Foundation-Assistenten ab und ergÃ¤nzt sie um gefÃ¼hrte Auswahl, SystemprÃ¼fung,
Live-Protokollierung und einen automatischen Benutzer-Installationsablauf.

Die Anwendung richtet Arbeitsumgebungen mit vorbereiteten Office-Vorlagen,
Schriftarten und Corporate-Design-Einstellungen ein. Sie konfiguriert Word,
Excel und klassisches Outlook, synchronisiert bei Bedarf Outlook-Signaturen
und nimmt ausgewÃ¤hlte Windows-Explorer-Einstellungen vor. Vor dem Ersetzen
persÃ¶nlicher Vorlagen werden Sicherungskopien angelegt.

## Kernfunktionen

- Synchronisation der Datei-Vorlagen (`Datei-Vorlagen\`) und Schriftarten (`Fonts\`)
- Auswahl von Zielort, Corporate Design, Schriftart und SchriftgrÃ¶ÃŸen
- Vorbereitete Word-, Excel- und Outlook-Vorlagen ohne COM-Schriftbearbeitung
- Outlook-Signatur-Synchronisation und klassische Outlook-MailSettings
- Office-Registry, Themes, Autokorrektur und Schnellzugriffsleisten
- Windows-Explorer-Anpassungen und ausfÃ¼hrliches Live-Logging

## Start

1. Release-ZIP entpacken.
2. Office-Dateien speichern und Word, Excel sowie Outlook schlieÃŸen.
3. `PC-Konfigurator-GUI.exe` direkt aus dem Releaseordner starten.
4. Dem Windows-Presentation-Foundation-Assistenten folgen.

Beim ersten Start kopiert die EXE sich mit allen Laufzeitdateien automatisch nach:

`%LOCALAPPDATA%\PC-Konfigurator-GUI`

WÃ¤hrend dieser Vorbereitung zeigt ein eigenes Fenster den Hinweis
â€žZur Vorbereitung wird der PC-Konfigurator in Ihrem System hinterlegt. Es geht
gleich weiter.â€œ sowie den aktuellen Einrichtungsschritt an.

AnschlieÃŸend startet sie aus diesem Benutzerordner. Ein manuelles
Installationsskript ist nicht erforderlich.

## Build und Release

Die Version wird zentral in `VERSION` nach [Semantic Versioning](https://semver.org/lang/de/) gepflegt:
`major.minor.patch`. Der Build verwendet daraus automatisch eine vierteilige
Windows-Dateiversion (`major.minor.patch.0`) und benennt Release-Ordner sowie
ZIP-Dateien mit der SemVer-Version.

Build:

```powershell
.\build.ps1
```

Jeder erfolgreiche Build aktualisiert die lokale Release-EXE und das
Release-ZIP unter `release\PC-Konfigurator-GUI-v<Version>\`.

VollstÃ¤ndiges Release-ZIP:

```powershell
.\create-release.ps1
```

Das ZIP liegt unter `release\` und enthÃ¤lt die EXE sowie `README.MD`. Die
Datei-Vorlagen, Fonts, Dokumentationen und `src\` sind vollstÃ¤ndig in der EXE
eingebettet und werden beim Start nach LocalAppData extrahiert.

## Voraussetzungen

- Windows 10 (Build 18362+) oder Windows 11
- Windows PowerShell 5.1 oder hÃ¶her
- Microsoft Office 2013 oder hÃ¶her

## Logs

- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Logs\`
- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Robocopy-Logs\`

Weitere Informationen stehen unter `docs\DOKUMENTATION_ANWENDER.md` und
`docs\DOKUMENTATION_TECHNIK.md`.
