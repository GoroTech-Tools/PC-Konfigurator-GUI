# PC-Konfigurator-GUI – Technische Dokumentation

## Aufbau und Release

Die Anwendung ist ein PowerShell/WPF-Skript, das mit PS2EXE als GUI-EXE gebaut wird. Ein Release-ZIP enthält:

- `PC-Konfigurator-GUI.exe`
- `README.MD`

Die EXE enthält ein eingebettetes Payload mit `Datei-Vorlagen`, `Fonts`, `docs`
und `src`. Beim ersten Start wird dieses Payload nach
`%LOCALAPPDATA%\PC-Konfigurator-GUI` extrahiert. Die EXE ermittelt danach ihr
eigenes AppData-Verzeichnis als `ScriptRoot`.

Bei jedem Start aus einem Releaseordner werden EXE, `Datei-Vorlagen`, `Fonts`,
`docs` und die Hilfsskripte mit `-Force` nach `%LOCALAPPDATA%\PC-Konfigurator-GUI`
aktualisiert. Dadurch werden auch neuere Vorlagen und Fontdateien in einer
bereits vorhandenen Benutzerinstallation übernommen. Die EXE startet danach
aus dem aktualisierten AppData-Verzeichnis.

## Laufzeitpfade

| Quelle | Verwendung |
| --- | --- |
| `<AppData-Install>\Datei-Vorlagen` | Robocopy-Synchronisation und vorbereitete Office-Dateien |
| `<AppData-Install>\Datei-Vorlagen\Sonstiges\Standards` | Auswahl der nach Schrift benannten Word-/Excel-/Outlook-Vorlagen |
| `<AppData-Install>\Fonts` | Benutzer-Fonts |
| `<AppData-Install>\Pin-Desktop-Schnellzugriff.ps1` | Desktop-Pin im Explorer |
| `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Logs` | Hauptlogs |
| `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Robocopy-Logs` | Robocopy-Logs |

## Pipeline

`Invoke-PCKonfiguratorPipeline` läuft in einem STA-Runspace. Die GUI empfängt Logzeilen über eine thread-sichere Queue und zeigt sie per DispatcherTimer an.

Die Standardvorlagen werden ohne COM-Schriftbearbeitung ausgewählt und kopiert:

- `Normal-<Font>-<WordSize>.dotm` → `Normal.dotm`
- `NormalEmail-<Font>-<WordSize>.dotm` → `NormalEmail.dotm`
- `Mappe-<Font>-<ExcelSize>.xltx` → `Mappe.xltx`

Vorhandene Zieldateien werden in `Dokumente\PC-Konfigurator-GUI\Backups\Vorlagen_<Zeitstempel>` gesichert. Erst wenn alle drei Quelldateien vorhanden sind, erfolgt die Übernahme.

## Outlook

Für klassisches Outlook schreibt `Set-OutlookRegistry` die Werte unter `HKCU\Software\Microsoft\Office\<Version>` und `Common\MailSettings`.

Unter `Common\MailSettings` werden – sofern vorhanden – folgende Binärwerte aktualisiert:

- `ComposeFontComplex` / `ComposeFontSimple` für neue Nachrichten
- `ReplyFontComplex` / `ReplyFontSimple` für Antworten
- `TextFontComplex` / `TextFontSimple` für Nur-Text

Die neue Outlook-App wird über AppX/Prozess erkannt. Ihre cloudbasierte Schriftkonfiguration wird nicht fälschlich als lokal erfolgreich gemeldet; die GUI protokolliert einen Hinweis auf **Einstellungen → Mail → Verfassen und Antworten**.

## Word-/Excel-XML-Reparatur

`PC-Konfigurator/src/Repair-PreparedOfficeTemplateFonts.ps1` synchronisiert die vorbereiteten Varianten:

- Office-Theme-Major-/Minor-Schriften
- Word `styles.xml` und `document.xml`, einschließlich direkter Startabsatzformatierung
- Excel-Schriftlisten und `cellXfs`

Damit überschreibt ein Calibri-Startabsatz nicht mehr die gewählte Formatvorlage.

## Logging und Diagnose

Log-Level sind `INFO`, `WARN` und `ERROR`. Die GUI spiegelt Pipeline-Logs zusätzlich live im Ausführungsfenster.

Bei Fehlern zuerst prüfen:

1. Sind alle Office-Prozesse geschlossen?
2. Existieren die drei vorbereiteten Vorlagen für die gewählte Schrift/Größe?
3. Ist der AppData-Installationsordner vollständig?
4. Gibt es Hinweise in `Dokumente\PC-Konfigurator-GUI\Logs`?

## Release-Erstellung

Im Projektverzeichnis:

```powershell
.\create-release.ps1
```

Das ZIP-Release wird unter `release\` erzeugt. Auf Zielrechnern wird die EXE
direkt aus dem entpackten Ordner gestartet; sie kopiert sich beim ersten Start
selbstständig nach `%LOCALAPPDATA%\PC-Konfigurator-GUI` und startet sich von dort.
Das Installationsskript bleibt als manueller Fallback enthalten.
