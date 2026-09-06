# Verwendete Registry-Einstellungen

<!-- release-metadata:start -->
> **Release-Version:** 1.0.4  
> **Stand:** 2026-09-06
<!-- release-metadata:end -->

**Quelle:** `src/PC-Konfigurator-GUI.ps1`

Diese Datei fasst die im Projekt verwendeten Registry-Einstellungen fÃ¼r Windows, Word, Excel und Outlook zusammen.
Die meisten Werte werden fÃ¼r den **aktuellen Benutzer** unter `HKCU` gesetzt.

## Windows / Explorer

### `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `HideFileExt` | `DWord` | `0` | Dateiendungen im Explorer anzeigen. |
| `Hidden` | `DWord` | `1` | Versteckte Dateien anzeigen. |
| `ShowSuperHidden` | `DWord` | `1` | GeschÃ¼tzte Systemdateien anzeigen. |
| `ShowRecent` | `DWord` | `0` | **Zuletzt verwendete Dateien** im Schnellzugriff/Explorer deaktivieren. |
| `ShowFrequent` | `DWord` | `0` | **HÃ¤ufig verwendete Ordner** im Schnellzugriff/Explorer deaktivieren. |

### `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `SearchSystemDirs` | `DWord` | `1` | Systemverzeichnisse in die Suche einbeziehen. |
| `SearchCompressedFiles` | `DWord` | `1` | Komprimierte Dateien in die Suche einbeziehen. |
| `SearchAlways` | `DWord` | `1` | Immer Dateinamen und Inhalte suchen. |

## Office-UI-Dateien / Schnellzugriffe

### `%APPDATA%\Microsoft\Office\`

| Datei | Zweck |
| --- | --- |
| `Excel.officeUI` | Definiert die sichtbaren EintrÃ¤ge der Excel-Symbolleiste fÃ¼r den Schnellzugriff. |
| `Word.officeUI` | Definiert die sichtbaren EintrÃ¤ge der Word-Symbolleiste fÃ¼r den Schnellzugriff. |

Diese Dateien werden aus dem Ordner `Datei-Vorlagen\Sonstiges\Symbolleiste Schnellzugriff` Ã¼bernommen, sofern vorhanden. Sie stellen eine benutzerbezogene Standardkonfiguration fÃ¼r die Schnellzugriffsbars bereit.

## Word

### `HKCU:\Software\Microsoft\Office\16.0\Word\Options`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `DeveloperTools` | `DWord` | `1` | Entwicklertools aktivieren. |
| `Ruler` | `DWord` | `1` | Lineal einblenden. |
| `ShowAllFormatting` | `DWord` | `1` | Alle Formatierungszeichen anzeigen. |
| `VisiDrawTableDrs` | `DWord` | `1` | TabellenrÃ¤nder/Zeichenhilfen anzeigen. |
| `DOC-PATH` | `String` / `ExpandString` | `Z:\` oder `$driveRoot` | Standardpfad fÃ¼r Dokumente. |
| `PersonalTemplates` | `String` / `ExpandString` | `$BackupTargetPath` | Pfad fÃ¼r persÃ¶nliche Vorlagen. |
| `DisableBootToOfficeStart` | `DWord` | `1` | Office-Startbildschirm deaktivieren. |
| `DisableBackstageOpenKeyShortcuts` | `DWord` | `1` | TastenkÃ¼rzel im Backstage-Bereich deaktivieren. |
| `DefaultFont` | `String` | z. B. `Aptos` | Standardschrift fÃ¼r neue Dokumente. |
| `DefaultFontSize` | `DWord` | z. B. `11` | StandardschriftgrÃ¶ÃŸe fÃ¼r neue Dokumente. |
| `CorrectCapsLock` | `DWord` | `0` | Korrektur bei Caps Lock deaktivieren. |
| `AutoFormatApplyBulletedLists` | `DWord` | `0` | Automatische AufzÃ¤hlungslisten deaktivieren. |
| `AutoFormatApplyNumberedLists` | `DWord` | `0` | Automatische Nummerierungslisten deaktivieren. |
| `AutoFormatCapitalizeTableCells` | `DWord` | `0` | Automatische GroÃŸschreibung in Tabellenzellen deaktivieren. |
| `CorrectTableCells` | `DWord` | `0` | Tabellenzellenkorrekturen deaktivieren. |
| `PictureInsertLayout` | `DWord` | `1` | Bildlayout beim EinfÃ¼gen steuern. |
| `Font` | `String` | z. B. `Aptos` | Schriftname fÃ¼r die Standardkonfiguration. |
| `Fontsubstitutes` | `String` | leer | Schrift-Ersatzliste leeren. |

### `HKCU:\Software\Microsoft\Office\16.0\Word\Options`, `17.0`, `18.0`

Diese Werte werden zusÃ¤tzlich fÃ¼r mehrere Word-Versionen gesetzt:

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `AutoFormatAsYouTypeApplyNumberedLists` | `DWord` | `0` | Nummerierte Listen wÃ¤hrend der Eingabe deaktivieren. |
| `AutoFormatAsYouTypeApplyBulletedLists` | `DWord` | `0` | AufzÃ¤hlungslisten wÃ¤hrend der Eingabe deaktivieren. |
| `CorrectSentenceCaps` | `DWord` | `1` | Satzanfang automatisch korrigieren. |
| `AutoFormatAsYouTypeReplaceHyperlinks` | `DWord` | `0` | Hyperlink-Ersetzung wÃ¤hrend der Eingabe deaktivieren. |
| `CorrectInitialCaps` | `DWord` | `0` | Automatische GroÃŸschreibung am Wortanfang deaktivieren. |
| `AutoFormatAsYouTypeReplaceQuotes` | `DWord` | `1` | AnfÃ¼hrungszeichen automatisch umwandeln. |
| `AutoFormatAsYouTypeReplaceSymbols` | `DWord` | `1` | Symbole automatisch umwandeln. |
| `PasteFormattingOtherApp` | `DWord` | `2` | EinfÃ¼geverhalten aus anderen Programmen steuern. |
| `PasteFormattingTwoDocumentsNoStyles` | `DWord` | `1` | EinfÃ¼geverhalten zwischen Dokumenten ohne Formatvorlagen. |

### ZusÃ¤tzliche Schrift-Einstellungen fÃ¼r Word

#### `HKCU:\Software\Microsoft\Office\16.0\Word\Options` und `Common\LanguageResources`

#### auÃŸerdem fÃ¼r die Versionen `14.0`, `15.0`, `16.0`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `DefaultFont` | `String` | z. B. `Aptos` | Standardschrift beibehalten/setzen. |
| `DefaultFontSize` | `DWord` | z. B. `11` | StandardschriftgrÃ¶ÃŸe beibehalten/setzen. |

## Excel

### `HKCU:\Software\Microsoft\Office\16.0\Excel\Options`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `DeveloperTools` | `DWord` | `1` | Entwicklertools aktivieren. |
| `DefaultPath` | `String` / `ExpandString` | `Z:\` oder `$driveRoot` | Standardpfad fÃ¼r Arbeitsmappen/Dateien. |
| `PersonalTemplates` | `String` / `ExpandString` | `$BackupTargetPath` | Pfad fÃ¼r persÃ¶nliche Vorlagen. |
| `DisableBootToOfficeStart` | `DWord` | `1` | Office-Startbildschirm deaktivieren. |
| `StandardFont` | `String` | z. B. `Aptos` | Standardschrift fÃ¼r neue Arbeitsmappen. |
| `StandardFontSize` | `DWord` | z. B. `10` | StandardschriftgrÃ¶ÃŸe fÃ¼r neue Arbeitsmappen. |
| `Font` | `String` | z. B. `Aptos,10` | Schrift-/GrÃ¶ÃŸenkombination fÃ¼r die Standardkonfiguration. |
| `AltStartupPath` | `String` / `ExpandString` | `$BackupTargetPath` | ZusÃ¤tzlicher Startpfad fÃ¼r Excel. |
| `AutoSaveInterval` | `DWord` | `5` | AutoSpeichern-Intervall in Minuten. |

### `HKCU:\Software\Microsoft\Office\16.0\Excel\Options`, `15.0`, `14.0`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `StandardFont` | `String` | z. B. `Aptos` | Standardschrift fÃ¼r neue Arbeitsmappen. |
| `StandardFontSize` | `DWord` | z. B. `10` | StandardschriftgrÃ¶ÃŸe fÃ¼r neue Arbeitsmappen. |

### `HKCU:\Software\Microsoft\Office\14.0\Excel\Options`, `15.0\Excel\Options`, `16.0\Excel\Options` â€“ Zusatz fÃ¼r Autokorrektur

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `CorrectSentenceCap` | `DWord` | `0` | Automatische Satzanfangskorrektur in Excel deaktivieren. |

ZusÃ¤tzlich setzt das Skript die dokumentierte Excel-COM-Eigenschaft
`Application.AutoCorrect.CorrectSentenceCap` auf `False` und liest sie danach zur
Verifikation wieder aus. Im Gegensatz zu Word ist dies die primÃ¤re Konfiguration
fÃ¼r Excel; die Registry-Werte bleiben ein Fallback fÃ¼r noch nicht gestartete
Excel-Instanzen.

## Outlook

### `HKCU:\Software\Microsoft\Office\$version\Outlook\Options\Calendar`

> Im Skript werden die Versionen `16.0`, `15.0` und `14.0` durchlaufen.

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `WeekNum` | `DWord` | `1` | Kalender zeigt Kalenderwochen an. |

### `HKCU:\Software\Microsoft\Office\$version\Outlook\Options`

| Wert | Typ | Standard im Skript | Kurzbeschreibung |
| --- | ---: | ---: | --- |
| `NewMailFont` | `String` | z. B. `Aptos` | Standardschrift fÃ¼r neue E-Mails. |
| `NewMailFontSize` | `DWord` | z. B. `11` | SchriftgrÃ¶ÃŸe fÃ¼r neue E-Mails. |
| `ReplyForwardFont` | `String` | z. B. `Aptos` | Standardschrift fÃ¼r Antworten und Weiterleitungen. |
| `ReplyForwardFontSize` | `DWord` | z. B. `11` | SchriftgrÃ¶ÃŸe fÃ¼r Antworten und Weiterleitungen. |
| `DefaultMailFont` | `String` | z. B. `Aptos` | Standard-Mail-Schrift fÃ¼r Outlook. |

## Hinweise

- Die Werte werden Ã¼berwiegend unter `HKCU` gesetzt, also benutzerspezifisch.
- Einige Pfade werden nur gesetzt, wenn sie existieren; andere werden bei Bedarf angelegt.
- Schriftarten und GrÃ¶ÃŸen kÃ¶nnen je nach Auswahl im Skript variieren.
- Die Tabelle bildet den Stand aus `src/PC-Konfigurator-GUI.ps1` ab und kann sich mit kÃ¼nftigen Ã„nderungen im Skript Ã¤ndern.
- Eine fachliche GesamtÃ¼bersicht der zusÃ¤tzlich per COM, Vorlagen und Office-UI-Dateien vorgenommenen Einstellungen enthÃ¤lt `PC-Konfigurator - Einstellungen.pdf`.
- Die PDF wird in Releases aufgenommen. Die zugehÃ¶rige Arbeitsdatei `PC-Konfigurator - Einstellungen.docx` bleibt auÃŸerhalb des Release-Pakets.
