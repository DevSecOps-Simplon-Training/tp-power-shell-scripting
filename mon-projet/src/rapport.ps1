# rapport.ps1 — Génère un rapport complet avec des fonctions

param([string]$LogFile = "ressources/server.log")

$timestamp   = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

# ── Fonctions ──────────────────────────────────────────────────────────

function Write-Titre {
    param([string]$Titre)
    $separateur = "=" * 45
    Write-Output $separateur
    Write-Output "  $Titre"
    Write-Output $separateur
}

function Get-Niveau {
    param([string]$Niveau, [string]$Fichier)
    return (Select-String $Niveau $Fichier).Count
}

function Write-Rapport {
    param([string]$Section, [string]$Contenu, [string]$Fichier)
    Add-Content -Path $Fichier -Value ""
    Add-Content -Path $Fichier -Value "--- $Section ---"
    Add-Content -Path $Fichier -Value $Contenu
}

# ── Script principal ────────────────────────────────────────────────────

if (-not (Test-Path $LogFile)) {
    Write-Error "Fichier introuvable : $LogFile"
    exit 1
}

Write-Titre "RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"

$info     = Get-Niveau "INFO"     $LogFile
$warning  = Get-Niveau "WARNING"  $LogFile
$erreurs  = Get-Niveau "ERROR"    $LogFile
$critical = Get-Niveau "CRITICAL" $LogFile

Write-Output "  INFO     : $info"
Write-Output "  WARNING  : $warning"
Write-Output "  ERROR    : $erreurs"
Write-Output "  CRITICAL : $critical"

# Écrire dans le fichier rapport
"RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')" | Out-File $rapportPath -Encoding UTF8

Write-Rapport "Compteurs" "INFO=$info  WARNING=$warning  ERROR=$erreurs  CRITICAL=$critical" $rapportPath
Write-Rapport "Incidents critiques" ((Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line }) -join "`n") $rapportPath
Write-Rapport "Erreurs" ((Select-String "ERROR" $LogFile | ForEach-Object { $_.Line }) -join "`n") $rapportPath

Write-Output ""
Write-Output "Rapport sauvegardé : $rapportPath"