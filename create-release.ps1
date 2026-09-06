<#
.SYNOPSIS
Erzeugt ein vollständiges, auf andere Rechner ausrollbares GUI-Release-ZIP.
#>
[CmdletBinding()]
param(
    [string]$Version,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
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

function Update-ReleaseDocumentation {
    param(
        [Parameter(Mandatory = $true)][string]$ReleaseVersion,
        [Parameter(Mandatory = $true)][datetime]$ReleaseDate
    )

    $metadata = "<!-- release-metadata:start -->`r`n> **Release-Version:** $ReleaseVersion  `r`n> **Stand:** $($ReleaseDate.ToString('yyyy-MM-dd'))`r`n<!-- release-metadata:end -->"
    $documentationFiles = @(
        (Join-Path $projectRoot 'README.md'),
        (Join-Path $projectRoot 'docs\DOKUMENTATION_ANWENDER.md'),
        (Join-Path $projectRoot 'docs\DOKUMENTATION_TECHNIK.md'),
        (Join-Path $projectRoot 'docs\Registry-Einstellungen.md')
    )

    foreach ($documentationFile in $documentationFiles) {
        if (-not (Test-Path -LiteralPath $documentationFile -PathType Leaf)) {
            throw "Dokumentation fehlt: $documentationFile"
        }

        $content = Get-Content -LiteralPath $documentationFile -Raw
        if ($content -match '(?s)<!-- release-metadata:start -->.*?<!-- release-metadata:end -->') {
            $content = [regex]::Replace($content, '(?s)<!-- release-metadata:start -->.*?<!-- release-metadata:end -->', [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $metadata })
        } else {
            $firstLineEnding = $content.IndexOf("`n")
            if ($firstLineEnding -lt 0) {
                throw "Dokumentation enthält keine Überschriftzeile: $documentationFile"
            }
            $content = $content.Insert($firstLineEnding + 1, "`r`n$metadata`r`n")
        }

        [IO.File]::WriteAllText($documentationFile, $content, (New-Object Text.UTF8Encoding($false)))
        Write-Host "Dokumentation aktualisiert: $documentationFile" -ForegroundColor Cyan
    }
}

$releaseRoot = Join-Path $projectRoot 'release'
$zipPath = Join-Path $releaseRoot "PC-Konfigurator-GUI-v$Version.zip"
$buildScript = Join-Path $projectRoot 'build.ps1'
$buildExe = Join-Path $projectRoot 'build\PC-Konfigurator-GUI.exe'

Update-ReleaseDocumentation -ReleaseVersion $Version -ReleaseDate (Get-Date)

if (Get-CimInstance Win32_Process -Filter "Name='PC-Konfigurator-GUI.exe'" -ErrorAction SilentlyContinue) {
    throw 'PC-Konfigurator-GUI läuft noch. Bitte vor dem Release alle GUI-Prozesse schließen.'
}

if (-not $SkipBuild) {
    & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $buildScript -Version $Version
    if ($LASTEXITCODE -ne 0) { throw "Build fehlgeschlagen: $LASTEXITCODE" }
}

foreach ($required in @($buildExe, (Join-Path $projectRoot 'Datei-Vorlagen'), (Join-Path $projectRoot 'Fonts'), (Join-Path $projectRoot 'docs'), (Join-Path $projectRoot 'Install-PC-Konfigurator-GUI.ps1'))) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Release-Quelle fehlt: $required" }
}

if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) {
    throw "Das Release-ZIP wurde nicht erstellt: $zipPath"
}

$files = Get-ChildItem -LiteralPath $zipPath -File
Write-Host "Release erstellt: $zipPath" -ForegroundColor Green
Write-Host "Dateien: $($files.Count); Größe: $([Math]::Round((Get-Item $zipPath).Length / 1MB, 2)) MB"
