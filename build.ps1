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
    [string]$OutputExe,
    [string]$Version
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$versionFile = Join-Path $projectRoot 'VERSION'
if ([string]::IsNullOrWhiteSpace($Version)) {
    if (-not (Test-Path -LiteralPath $versionFile -PathType Leaf)) {
        throw "Versionsdatei fehlt: $versionFile"
    }
    $Version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
}
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    throw "Ungültige Version '$Version'. Erwartet wird Semantic Versioning im Format major.minor.patch."
}
$fileVersion = "$Version.0"
if ([string]::IsNullOrWhiteSpace($SourceScript)) {
    $SourceScript = Join-Path $projectRoot 'src\PC-Konfigurator-GUI.ps1'
}
if ([string]::IsNullOrWhiteSpace($OutputExe)) {
    $OutputExe = Join-Path $projectRoot 'build\PC-Konfigurator-GUI.exe'
}
$iconFile = Join-Path $projectRoot 'src\app_icon.ico'
if (-not (Test-Path -LiteralPath $iconFile -PathType Leaf)) {
    throw "Anwendungssymbol fehlt: $iconFile"
}

Write-Host "=== PC-Konfigurator-GUI Build ===" -ForegroundColor Cyan
Write-Host "Version: $Version (Dateiversion: $fileVersion)" -ForegroundColor Cyan

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
Copy-Item -LiteralPath $versionFile -Destination $payloadStaging -Force
Compress-Archive -Path (Join-Path $payloadStaging '*') -DestinationPath $payloadZip -CompressionLevel Optimal -Force
Remove-Item $payloadStaging -Recurse -Force

function Add-AppendedPayload {
    param(
        [Parameter(Mandatory = $true)][string]$ExecutablePath,
        [Parameter(Mandatory = $true)][string]$PayloadPath
    )

    $marker = [Text.Encoding]::ASCII.GetBytes('PCKGUI-PAYLOAD-1')
    $payloadLength = (Get-Item -LiteralPath $PayloadPath).Length
    $target = [IO.File]::Open($ExecutablePath, [IO.FileMode]::Append, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try {
        $payload = [IO.File]::OpenRead($PayloadPath)
        try {
            $payload.CopyTo($target)
        } finally {
            $payload.Dispose()
        }
        $target.Write([BitConverter]::GetBytes([int64]$payloadLength), 0, 8)
        $target.Write($marker, 0, $marker.Length)
    } finally {
        $target.Dispose()
    }
}

function Update-LocalRelease {
    param(
        [Parameter(Mandatory = $true)][string]$ExecutablePath,
        [Parameter(Mandatory = $true)][string]$ReleaseVersion
    )

    $releaseRoot = Join-Path $projectRoot 'release'
    $releaseZip = Join-Path $releaseRoot "PC-Konfigurator-GUI-v$ReleaseVersion.zip"
    $archiveRoot = Join-Path $releaseRoot 'Archiv'
    $stagingRoot = Join-Path $env:TEMP "PC-Konfigurator-GUI-v$ReleaseVersion-$([guid]::NewGuid())"

    New-Item -ItemType Directory -Path $releaseRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $archiveRoot -Force | Out-Null

    # Nur das aktuelle ZIP bleibt im Release-Ordner. Frühere Pakete werden
    # vollständig und ohne Entpacken ins lokale Archiv verschoben.
    Get-ChildItem -LiteralPath $releaseRoot -File -Filter 'PC-Konfigurator-GUI-v*.zip' | Where-Object { $_.FullName -ne $releaseZip } | ForEach-Object {
            Move-Item -LiteralPath $_.FullName -Destination (Join-Path $archiveRoot $_.Name) -Force
            Write-Host "Älteres Release archiviert: $($_.Name)" -ForegroundColor Cyan
        }

    try {
        New-Item -ItemType Directory -Path $stagingRoot -Force | Out-Null
        Copy-Item -LiteralPath $ExecutablePath -Destination (Join-Path $stagingRoot 'PC-Konfigurator-GUI.exe') -Force
        Copy-Item -LiteralPath (Join-Path $projectRoot 'README.MD') -Destination (Join-Path $stagingRoot 'README.MD') -Force
        if (Test-Path -LiteralPath $releaseZip) {
            Remove-Item -LiteralPath $releaseZip -Force
        }
        Compress-Archive -Path (Join-Path $stagingRoot '*') -DestinationPath $releaseZip -CompressionLevel Optimal -Force
    } finally {
        if (Test-Path -LiteralPath $stagingRoot) {
            Remove-Item -LiteralPath $stagingRoot -Recurse -Force
        }
    }

    Write-Host "Lokales Release aktualisiert: $releaseZip" -ForegroundColor Green
}

Write-Host "Kompiliere '$SourceScript' -> '$OutputExe' ..." -ForegroundColor Cyan

try {
    Invoke-ps2exe `
        -inputFile $SourceScript `
        -outputFile $OutputExe `
        -noConsole `
        -iconFile $iconFile `
        -title "PC-Konfigurator-GUI" `
        -version $fileVersion `
        -company "Thomas Gorontzy" `
        -product "PC-Konfigurator-GUI" `
        -description "GUI-Assistent zur automatisierten Konfiguration von Windows-/Office-Arbeitsumgebungen (Vorlagen, Schriftarten, Corporate Design, Outlook-Signaturen)." `
        -copyright "(c) Thomas Gorontzy" `
        -ErrorAction Stop

    if (Test-Path $OutputExe) {
        Add-AppendedPayload -ExecutablePath $OutputExe -PayloadPath $payloadZip
        $exeInfo = Get-Item $OutputExe
        Write-Host "Build erfolgreich: $($exeInfo.FullName) ($([Math]::Round($exeInfo.Length / 1MB, 2)) MB)" -ForegroundColor Green
        Update-LocalRelease -ExecutablePath $exeInfo.FullName -ReleaseVersion $Version
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
