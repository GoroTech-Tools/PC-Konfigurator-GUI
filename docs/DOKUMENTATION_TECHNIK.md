# PC-Konfigurator-GUI â€“ Technische Dokumentation

<!-- release-metadata:start -->
> **Release-Version:** 1.0.4  
> **Stand:** 2026-09-06
<!-- release-metadata:end -->

## Aufbau und Release

Die zentrale Datei `VERSION` enthÃ¤lt die Semantic-Versioning-Angabe im Format
`major.minor.patch`. `build.ps1` und `create-release.ps1` lesen diese Version
automatisch; fÃ¼r die Windows-EXE wird die vierteilige Dateiversion
`major.minor.patch.0` erzeugt.

Die Anwendung ist ein PowerShell-Skript mit einer grafischen BenutzeroberflÃ¤che auf Basis der Windows Presentation Foundation, das mit PS2EXE als GUI-EXE gebaut wird. Die Windows Presentation Foundation stellt Fenster, Steuerelemente und den Assistenten bereit; dadurch werden die Konsoleneingaben des Ursprungsprojekts durch eine gefÃ¼hrte Bedienung ersetzt und Laufzeitprotokolle kÃ¶nnen live angezeigt werden. Ein Release-ZIP enthÃ¤lt:

- `PC-Konfigurator-GUI.exe`
- `README.MD`

Die EXE enthÃ¤lt ein eingebettetes Payload mit `Datei-Vorlagen`, `Fonts`, `docs`
und `src`. Beim ersten Start wird dieses Payload nach
`%LOCALAPPDATA%\PC-Konfigurator-GUI` extrahiert. Die EXE ermittelt danach ihr
eigenes AppData-Verzeichnis als `ScriptRoot`.

WÃ¤hrend der Extraktion zeigt `Show-PreparationWindow` ein eigenes Fenster der
Windows Presentation Foundation. Es informiert mit dem Text â€žZur Vorbereitung
wird der PC-Konfigurator in Ihrem System hinterlegt. Es geht gleich weiter.â€œ
und aktualisiert den sichtbaren Vorbereitungsschritt. Das Laufzeitpaket wird
an die EXE angehÃ¤ngt und erst nach Start des Skripts verarbeitet; dadurch kann
die Anwendung jeden entpackten Eintrag direkt im Fenster protokollieren. Die
PS2EXE-Option `-embedFiles` wird bewusst nicht verwendet, weil sie Dateien
bereits vor dem Skriptstart extrahiert und daher keine eigene Fortschrittsanzeige
ermÃ¶glicht.

Bei jedem Start aus einem Releaseordner werden EXE, `Datei-Vorlagen`, `Fonts`,
`docs` und die Hilfsskripte mit `-Force` nach `%LOCALAPPDATA%\PC-Konfigurator-GUI`
aktualisiert. Dadurch werden auch neuere Vorlagen und Fontdateien in einer
bereits vorhandenen Benutzerinstallation Ã¼bernommen. Die EXE startet danach
aus dem aktualisierten AppData-Verzeichnis.

Wird ausschlieÃŸlich 32-Bit-Office erkannt, startet die EXE das extrahierte
Quellskript mit `SysWOW64\WindowsPowerShell\v1.0\powershell.exe`. Damit kÃ¶nnen
die COM-Aufrufe zum Einbetten des Corporate Designs in Word-, Excel- und
Outlook-Vorlagen mit der passenden Office-Bitness ausgefÃ¼hrt werden.

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

`Invoke-PCKonfiguratorPipeline` lÃ¤uft in einem STA-Runspace. Die GUI empfÃ¤ngt Logzeilen Ã¼ber eine thread-sichere Queue und zeigt sie per DispatcherTimer an.

Die Auswahl fÃ¼r versteckte Elemente steuert `Explorer\Advanced\Hidden`: `1`
zeigt versteckte Dateien und Ordner an, `2` blendet sie aus. Der Standardwert
ist `1`; geschÃ¼tzte Betriebssystemdateien bleiben mit `ShowSuperHidden = 0`
weiterhin ausgeblendet.

Die Standardvorlagen werden ohne COM-Schriftbearbeitung ausgewÃ¤hlt und kopiert:

- `Normal-<Font>-<WordSize>.dotm` â†’ `Normal.dotm`
- `NormalEmail-<Font>-<WordSize>.dotm` â†’ `NormalEmail.dotm`
- `Mappe-<Font>-<ExcelSize>.xltx` â†’ `Mappe.xltx`

Vorhandene Zieldateien werden in `Dokumente\PC-Konfigurator-GUI\Backups\Vorlagen_<Zeitstempel>` gesichert. Erst wenn alle drei Quelldateien vorhanden sind, erfolgt die Ãœbernahme.

Nach der Ãœbernahme wird die gewÃ¤hlte `.thmx`-Datei in `Normal.dotm`,
`Mappe.xltx` und `NormalEmail.dotm` eingebettet. Dadurch verwenden neue Word-,
Excel- und klassische Outlook-Dateien das ausgewÃ¤hlte Corporate Design, nicht
nur eine in den Office-Theme-Ordner kopierte Design-Datei.

Die Einbettung ersetzt `word/theme/theme1.xml` beziehungsweise
`xl/theme/theme1.xml` direkt im Open-XML-Container der Vorlage. Dadurch
erscheinen die gewÃ¤hlten Akzentfarben zuverlÃ¤ssig auch in **FÃ¼llfarbe**,
Rahmenfarbe und vergleichbaren Office-Farbpaletten, unabhÃ¤ngig von der
VerfÃ¼gbarkeit der Office-COM-Automatisierung.

ZusÃ¤tzlich extrahiert die Anwendung das Farbschema aus der gewÃ¤hlten
`.thmx`-Datei und installiert es als `INN-tegrativ.xml`, `DBK.xml` oder
`Careli.xml` unter `%APPDATA%\Microsoft\Templates\Theme Colors`.
Damit steht das Corporate Design auch in den Office-Farbauswahllisten bereit;
Office muss anschlieÃŸend neu gestartet werden.

## Outlook

FÃ¼r klassisches Outlook schreibt `Set-OutlookRegistry` die Werte unter `HKCU\Software\Microsoft\Office\<Version>` und `Common\MailSettings`.

Unter `Common\MailSettings` werden â€“ sofern vorhanden â€“ folgende BinÃ¤rwerte aktualisiert:

- `ComposeFontComplex` / `ComposeFontSimple` fÃ¼r neue Nachrichten
- `ReplyFontComplex` / `ReplyFontSimple` fÃ¼r Antworten
- `TextFontComplex` / `TextFontSimple` fÃ¼r Nur-Text

Die neue Outlook-App wird Ã¼ber AppX/Prozess erkannt. Ihre cloudbasierte Schriftkonfiguration wird nicht fÃ¤lschlich als lokal erfolgreich gemeldet; die GUI protokolliert einen Hinweis auf **Einstellungen â†’ Mail â†’ Verfassen und Antworten**.

## Word-/Excel-XML-Reparatur

`PC-Konfigurator/src/Repair-PreparedOfficeTemplateFonts.ps1` synchronisiert die vorbereiteten Varianten:

- Office-Theme-Major-/Minor-Schriften
- Word `styles.xml` und `document.xml`, einschlieÃŸlich direkter Startabsatzformatierung
- Excel-Schriftlisten und `cellXfs`

Damit Ã¼berschreibt ein Calibri-Startabsatz nicht mehr die gewÃ¤hlte Formatvorlage.

## Logging und Diagnose

Log-Level sind `INFO`, `WARN` und `ERROR`. Die GUI spiegelt Pipeline-Logs zusÃ¤tzlich live im AusfÃ¼hrungsfenster.

Bei Fehlern zuerst prÃ¼fen:

1. Sind alle Office-Prozesse geschlossen?
2. Existieren die drei vorbereiteten Vorlagen fÃ¼r die gewÃ¤hlte Schrift/GrÃ¶ÃŸe?
3. Ist der AppData-Installationsordner vollstÃ¤ndig?
4. Gibt es Hinweise in `Dokumente\PC-Konfigurator-GUI\Logs`?

## Release-Erstellung

Im Projektverzeichnis:

```powershell
.\create-release.ps1
```

Auch `build.ps1` aktualisiert nach einer erfolgreichen Kompilierung die lokale
Release-ZIP unter `release\PC-Konfigurator-GUI-v<Version>.zip`.
`create-release.ps1` Ã¼bergibt die zentrale Versionsnummer an den Build und erstellt
anschlieÃŸend keine zusÃ¤tzliche Release-Struktur mehr.

Im Ordner `release\` bleibt ausschlieÃŸlich das neueste ZIP. Ã„ltere ZIPs werden
automatisch nach `release\Archiv\` verschoben. Auf Zielrechnern wird die EXE
direkt aus dem entpackten Ordner gestartet; sie kopiert sich beim ersten Start
selbststÃ¤ndig nach `%LOCALAPPDATA%\PC-Konfigurator-GUI` und startet sich von dort.
Das Installationsskript bleibt als manueller Fallback enthalten.
