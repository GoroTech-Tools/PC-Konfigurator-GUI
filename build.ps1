<#
.SYNOPSIS
    Kompiliert src\PC-Konfigurator-GUI.ps1 mit ps2exe zu build\PC-Konfigurator-GUI.exe.

.HINWEIS ZU -requireAdmin
    Es wird bewusst KEIN -requireAdmin gesetzt. Wie das Original-Konsolenprojekt
    PC-Konfigurator schreibt auch dieses GUI-Tool ausschließlich in den aktuellen
    Benutzerkontext (HKCU-Registry, %USERPROFILE%\Documents, Benutzer-Schriftarten-
    Ordner). Es sind daher grundsätzlich KEINE Administratorrechte erforderlich.
#>

[CmdletBinding()]
param(
    [string]$SourceScript,
    [string]$OutputExe
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ([string]::IsNullOrWhiteSpace($SourceScript)) {
    $SourceScript = Join-Path $projectRoot 'src\PC-Konfigurator-GUI.ps1'
}
if ([string]::IsNullOrWhiteSpace($OutputExe)) {
    $OutputExe = Join-Path $projectRoot 'build\PC-Konfigurator-GUI.exe'
}

Write-Host "=== PC-Konfigurator-GUI Build ===" -ForegroundColor Cyan

# --- ps2exe-Modul sicherstellen ---
$ps2exeModule = Get-Module -ListAvailable -Name ps2exe | Select-Object -First 1
if (-not $ps2exeModule) {
    Write-Host "ps2exe-Modul nicht gefunden - Installation wird gestartet (Scope: CurrentUser) ..." -ForegroundColor Yellow
    try {
        Install-Module -Name ps2exe -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "ps2exe-Modul erfolgreich installiert." -ForegroundColor Green
    } catch {
        Write-Host "Fehler bei der Installation von ps2exe: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ps2exe-Modul bereits vorhanden (Version $($ps2exeModule.Version))." -ForegroundColor Green
}

Import-Module ps2exe -ErrorAction Stop

if (-not (Test-Path $SourceScript)) {
    Write-Host "Quellskript nicht gefunden: $SourceScript" -ForegroundColor Red
    exit 1
}

$outputDir = Split-Path $OutputExe -Parent
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Alle zur Laufzeit benötigten Projektdateien werden als ein eindeutiges ZIP
# eingebettet. PS2EXE extrahiert dieses ZIP beim EXE-Start nach LocalAppData;
# dadurch bleibt das Release auf eine einzelne EXE reduzierbar.
$payloadStaging = Join-Path $outputDir '_payload-staging'
$payloadZip = Join-Path $outputDir 'PC-Konfigurator-GUI-payload.zip'
if (Test-Path $payloadStaging) { Remove-Item $payloadStaging -Recurse -Force }
if (Test-Path $payloadZip) { Remove-Item $payloadZip -Force }
New-Item -ItemType Directory -Path $payloadStaging -Force | Out-Null
foreach ($directoryName in @('Datei-Vorlagen', 'Fonts', 'docs', 'src')) {
    Copy-Item -LiteralPath (Join-Path $projectRoot $directoryName) -Destination $payloadStaging -Recurse -Force
}
foreach ($fileName in @('README.MD', 'Pin-Desktop-Schnellzugriff.ps1', 'Install-PC-Konfigurator-GUI.ps1')) {
    $sourcePath = Join-Path $projectRoot $fileName
    if (Test-Path $sourcePath) { Copy-Item -LiteralPath $sourcePath -Destination $payloadStaging -Force }
}
Compress-Archive -Path (Join-Path $payloadStaging '*') -DestinationPath $payloadZip -CompressionLevel Optimal -Force
Remove-Item $payloadStaging -Recurse -Force
$embeddedFiles = @{ '%LOCALAPPDATA%\PC-Konfigurator-GUI\_embedded-payload.zip' = $payloadZip }

Write-Host "Kompiliere '$SourceScript' -> '$OutputExe' ..." -ForegroundColor Cyan

try {
    Invoke-ps2exe `
        -inputFile $SourceScript `
        -outputFile $OutputExe `
        -noConsole `
        -title "PC-Konfigurator-GUI" `
        -version "1.0.0.0" `
        -company "Thomas Gorontzy" `
        -product "PC-Konfigurator-GUI" `
        -description "GUI-Assistent zur automatisierten Konfiguration von Windows-/Office-Arbeitsumgebungen (Vorlagen, Schriftarten, Corporate Design, Outlook-Signaturen)." `
        -copyright "(c) Thomas Gorontzy" `
        -embedFiles $embeddedFiles `
        -ErrorAction Stop

    if (Test-Path $OutputExe) {
        $exeInfo = Get-Item $OutputExe
        Write-Host "Build erfolgreich: $($exeInfo.FullName) ($([Math]::Round($exeInfo.Length / 1MB, 2)) MB)" -ForegroundColor Green
        Remove-Item $payloadZip -Force -ErrorAction SilentlyContinue
        exit 0
    } else {
        Write-Host "Build abgeschlossen, aber die erwartete Ausgabedatei wurde nicht gefunden: $OutputExe" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Build fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
