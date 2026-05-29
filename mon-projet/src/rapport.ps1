# rapport.ps1 — Génère un rapport complet avec des fonctions

param([string]$LogFile = "ressources/server.log")

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

# ── Fonctions ──────────────────────────────────────────────────────────

function Write-Titre {
    param([string]$Titre)
    $separateur = "=" * 45    # chaîne * nombre = répétition : "=" * 3 → "===" ; "ab" * 2 → "abab"
    Write-Output $separateur
    Write-Output "  $Titre"
    Write-Output $separateur
}

function Count-Level {
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

$info     = Count-Level "INFO"     $LogFile
$warning  = Count-Level "WARNING"  $LogFile
$err    = Count-Level "ERROR"    $LogFile
$critical = Count-Level "CRITICAL" $LogFile

Write-Output "  INFO     : $info"
Write-Output "  WARNING  : $warning"
Write-Output "  ERROR    : $err"
Write-Output "  CRITICAL : $critical"

# Écrire dans le fichier rapport
"RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')" | Out-File $rapportPath -Encoding UTF8

Write-Rapport "Compteurs" "INFO=$info  WARNING=$warning  ERROR=$err  CRITICAL=$critical" $rapportPath
Write-Rapport "Incidents critiques" (Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath
Write-Rapport "Erreurs" (Select-String "ERROR" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath
Write-Rapport "Derniers incidents critiques" ( Select-String "CRITICAL" $LogFile | Select-Object -Last 3 | ForEach-Object { "Ligne $($_.LineNumber): $($_.Line.Split('—')[0])" } | Out-String ) $rapportPath

Write-Output ""
Write-Output "Rapport sauvegardé : $rapportPath"