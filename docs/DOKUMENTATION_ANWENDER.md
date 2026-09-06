# PC-Konfigurator-GUI â€“ Anwenderdokumentation

<!-- release-metadata:start -->
> **Release-Version:** 1.0.4  
> **Stand:** 2026-09-06
<!-- release-metadata:end -->

## Version

Die aktuelle Release-Version und das Erstellungsdatum stehen im
Release-Metadatenblock am Anfang dieses Dokuments. Release-Dateien verwenden
das Format `PC-Konfigurator-GUI-v<major.minor.patch>.zip`.

## Zweck

Die PC-Konfigurator-GUI richtet Windows- und Office-Arbeitsumgebungen mit vorbereiteten Vorlagen, Schriftarten, Corporate Design und empfohlenen Einstellungen ein.

## Grafische BenutzeroberflÃ¤che

Die Anwendung verwendet die **Windows Presentation Foundation** fÃ¼r ihre
grafische BenutzeroberflÃ¤che. Sie ersetzt die Eingaben der ursprÃ¼nglichen
Konsolen-Variante durch einen gefÃ¼hrten Assistenten, in dem Auswahlen,
BestÃ¤tigungen, Fortschritt und Protokollmeldungen Ã¼bersichtlich angezeigt
werden.

## Installation und Schnellstart

1. Entpacken Sie das Release-ZIP.
2. Speichern Sie offene Dokumente und schlieÃŸen Sie Word, Excel und Outlook.
3. Starten Sie `PC-Konfigurator-GUI.exe` direkt aus dem entpackten Releaseordner.
4. Folgen Sie dem Windows-Presentation-Foundation-Assistenten.

Die EXE stellt sich beim ersten Start automatisch mit allen Laufzeitdateien im
Benutzerprofil unter `%LOCALAPPDATA%\PC-Konfigurator-GUI` bereit und startet
sich von dort erneut. Ein manueller Installeraufruf ist nicht erforderlich.

WÃ¤hrend die Anwendung vorbereitet wird, erscheint ein eigenes Fenster mit dem
Hinweis â€žZur Vorbereitung wird der PC-Konfigurator in Ihrem System hinterlegt.
Es geht gleich weiter.â€œ Der jeweils aktuelle Vorbereitungsschritt wird darin
angezeigt; eine Konsolenausgabe ist hierfÃ¼r nicht erforderlich.

## GUI-Assistent

Der Assistent fÃ¼hrt durch:

- Office-SchlieÃŸbestÃ¤tigung und SystemprÃ¼fung
- Zielauswahl fÃ¼r Datei-Vorlagen (Laufwerk oder Dokumente)
- Corporate Design (INN-tegrativ, DBK oder Careli)
- Schriftart und SchriftgrÃ¶ÃŸen
- Taskleisten-Ausrichtung: zentriert (Windows-Standard) oder linksbÃ¼ndig
- Versteckte Elemente im Datei-Explorer: anzeigen (Standard) oder nicht anzeigen
- AusfÃ¼hrung mit Live-Log
- optionalen Explorer-Neustart

## Was wird eingerichtet?

| Bereich | Inhalt |
| --- | --- |
| Word | vorbereitete `Normal.dotm`, Formatvorlagen, Schriftart und Schnellzugriff |
| Excel | vorbereitete `Mappe.xltx`, Standardschrift, Autokorrektur und Schnellzugriff |
| Outlook | vorbereitete `NormalEmail.dotm`, klassische MailSettings und Signatur-Synchronisation |
| Schriftarten | Installation mitgelieferter Fonts und Auswahl aus acht Office-Schriftarten |
| Windows | Explorer-Datenschutz, Anzeige versteckter Elemente, Suche, Taskleiste und Desktop-Schnellzugriff |

## Vorbereitete Vorlagen

Die GUI verÃ¤ndert die Standardvorlagen nicht per COM. Sie wÃ¤hlt die passende, bereits vorbereitete Datei nach dem Schema aus:

- `Normal-<Schrift>-<GrÃ¶ÃŸe>.dotm` â†’ `%APPDATA%\Microsoft\Templates\Normal.dotm`
- `NormalEmail-<Schrift>-<GrÃ¶ÃŸe>.dotm` â†’ `%APPDATA%\Microsoft\Templates\NormalEmail.dotm`
- `Mappe-<Schrift>-<GrÃ¶ÃŸe>.xltx` â†’ `%APPDATA%\Microsoft\Excel\XLSTART\Mappe.xltx`

Vorhandene Benutzerdateien werden vor dem Ãœberschreiben unter `Dokumente\PC-Konfigurator-GUI\Backups` gesichert.

Das gewÃ¤hlte Corporate Design wird auÃŸerdem in den Farbauswahllisten von
Office bereitgestellt. SchlieÃŸen und Ã¶ffnen Sie Word, Excel oder klassisches
Outlook nach der Konfiguration erneut, damit die aktualisierte Farbliste
eingelesen wird.

## Schriftartauswahl

Zur Auswahl stehen Aptos, Aptos Narrow, Arial, Calibri, Futura, PT Sans, Roboto und Segoe UI. StandardmÃ¤ÃŸig gelten Aptos, 11 pt fÃ¼r Word/Outlook und 10 pt fÃ¼r Excel.

## Outlook-Hinweis

Die Registrywerte und `NormalEmail.dotm` gelten fÃ¼r **klassisches Outlook**. Die neue Outlook-App verwendet eigene Microsoft-365-Einstellungen. Dort muss die Schrift unter **Einstellungen â†’ Mail â†’ Verfassen und Antworten** gesetzt werden. Die GUI protokolliert, wenn die neue Outlook-App erkannt wird.

## Signaturen und Logs

Eigene Outlook-Signaturen werden in den gewÃ¤hlten Vorlagenzielordner unter `Signaturen` gesichert und bei Bedarf nach `%APPDATA%\Microsoft\Signatures` zurÃ¼ckgespielt.

Logs liegen unter:

- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Logs\`
- `%USERPROFILE%\Documents\PC-Konfigurator-GUI\Robocopy-Logs\`

## Fehlerdiagnose

- Vor dem Lauf alle Office-Programme vollstÃ¤ndig schlieÃŸen.
- PrÃ¼fen, ob `%LOCALAPPDATA%\PC-Konfigurator-GUI\Datei-Vorlagen` und `Fonts` vorhanden sind.
- Bei Vorlagenproblemen das Backup unter `Dokumente\PC-Konfigurator-GUI\Backups` verwenden.
- Bei neuer Outlook-App die Schrift in den Microsoft-365-/Outlook-Einstellungen setzen.

## Verwandte Dokumente

- `DOKUMENTATION_TECHNIK.md`
- `Registry-Einstellungen.md`
- `PC-Konfigurator - Einstellungen.pdf`
- `README.MD`
