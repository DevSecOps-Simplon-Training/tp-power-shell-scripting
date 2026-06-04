# rapport.ps1 — Génère un rapport complet avec des fonctions

param([string]$LogFile = "ressources/server.log")

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

function Ecrire-Titre {
    param([string]$Titre)

    $separateur = "=" * 45
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

if (-not (Test-Path $LogFile)) {
    Write-Error "Fichier introuvable : $LogFile"
    exit 1
}

Ecrire-Titre "RAPPORT ANALYSE - $(Get-Date -Format 'dd/MM/yyyy HH:mm')"

$info     = Compter-Niveau "INFO"     $LogFile
$warning  = Compter-Niveau "WARNING"  $LogFile
$nbError  = Compter-Niveau "ERROR"    $LogFile
$critical = Compter-Niveau "CRITICAL" $LogFile

Write-Output "  INFO     : $info"
Write-Output "  WARNING  : $warning"
Write-Output "  ERROR    : $nbError"
Write-Output "  CRITICAL : $critical"

$dateRapport = Get-Date -Format "dd/MM/yyyy HH:mm"
$titreRapport = "RAPPORT ANALYSE - $dateRapport"

$titreRapport | Out-File $rapportPath -Encoding UTF8

Ecrire-Rapport "Compteurs" "INFO=$info WARNING=$warning ERROR=$nbError CRITICAL=$critical" $rapportPath

$incidentsCritiques = Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line } | Out-String
Ecrire-Rapport "Incidents critiques" $incidentsCritiques $rapportPath

$erreursLog = Select-String "ERROR" $LogFile | ForEach-Object { $_.Line } | Out-String
Ecrire-Rapport "Erreurs" $erreursLog $rapportPath

Write-Output ""
Write-Output "Rapport sauvegarde : $rapportPath"