# rapport.ps1 — Génère un rapport complet avec des fonctions

param([string]$LogFile = "ressources/server.log")

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

# ── Fonctions ──────────────────────────────────────────────────────────

function Ecrire-Titre {
    param([string]$Titre)
    $separateur = "=" * 45    # chaîne * nombre = répétition : "=" * 3 → "===" ; "ab" * 2 → "abab"
    Write-Output $separateur
    Write-Output "  $Titre"
    Write-Output $separateur
}

function Compter-Niveau {
    param([string]$Niveau, [string]$Fichier)
    return (Select-String $Niveau $Fichier).Count
}

function Ecrire-Rapport {
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

Ecrire-Titre "RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"

$info     = Compter-Niveau "INFO"     $LogFile
$warning  = Compter-Niveau "WARNING"  $LogFile
$error    = Compter-Niveau "ERROR"    $LogFile
$critical = Compter-Niveau "CRITICAL" $LogFile

Write-Output "  INFO     : $info"
Write-Output "  WARNING  : $warning"
Write-Output "  ERROR    : $error"
Write-Output "  CRITICAL : $critical"

# Écrire dans le fichier rapport
"RAPPORT D'ANALYSE — $(Get-Date -Format 'dd/MM/yyyy HH:mm')" | Out-File $rapportPath -Encoding UTF8

Ecrire-Rapport "Compteurs" "INFO=$info  WARNING=$warning  ERROR=$error  CRITICAL=$critical" $rapportPath
Ecrire-Rapport "Incidents critiques" (Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath
Ecrire-Rapport "Erreurs" (Select-String "ERROR" $LogFile | ForEach-Object { $_.Line } | Out-String) $rapportPath
$troisLastCrit = (Select-String "CRITICAL" $LogFile | Select-Object -Last 3)
Ecrire-Rapport "Derniers incidents critiques" ($troisLastCrit | ForEach-Object { "Ligne " + $_.LineNumber + " : " + $_.Line } | Out-String) $rapportPath

Write-Output ""
Write-Output "Rapport sauvegardé : $rapportPath"


# Utiliser des objets personnalisés dans une boucle
$resultats = foreach ($niveau in @("INFO","WARNING","ERROR","CRITICAL")) {
    [PSCustomObject]@{
        Niveau      = $niveau
        Occurrences = (Select-String $niveau "ressources/server.log").Count
    }
}
$resultats | Format-Table
$resultats | Export-Csv "stats.csv" -NoTypeInformation

# Pipeline avec filtrage et tri
Get-ChildItem -Recurse | Where-Object { $_.Extension -eq ".log" } |
    Sort-Object Length -Descending |
    Select-Object Name, Length |
    Format-Table