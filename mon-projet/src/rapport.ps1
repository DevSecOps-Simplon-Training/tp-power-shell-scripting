param([string]$LogFile = "ressources/server.log")

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$rapportPath = "mon-projet/logs/rapport-$timestamp.txt"

function Ecrire-Titre {
    param([string]$Titre)
    $separateur = "=" * 45
    Write-Output $separateur
    Write-Output " $Titre"
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

Ecrire-Titre "RAPPORT D'ANALYSE - $(Get-Date -Format 'dd/MM/yyyy HH:mm')"

$info    = Compter-Niveau "INFO"    $LogFile
$warning = Compter-Niveau "WARNING" $LogFile
$error   = Compter-Niveau "ERROR"   $LogFile
$critical = Compter-Niveau "CRITICAL" $LogFile

Write-Output " INFO     : $info"
Write-Output " WARNING  : $warning"
Write-Output " ERROR    : $error"
Write-Output " CRITICAL : $critical"

"RAPPORT D'ANALYSE - $(Get-Date -Format 'dd/MM/yyyy HH:mm')" | Out-File $rapportPath -Encoding utf8

Ecrire-Rapport "Compteurs" "INFO=$info WARNING=$warning ERROR=$error CRITICAL=$critical" $rapportPath
Ecrire-Rapport "Incidents critiques" (Select-String "CRITICAL" $LogFile | ForEach-Object { $_.Line }) $rapportPath
Ecrire-Rapport "Erreurs" (Select-String "ERROR" $LogFile | ForEach-Object { $_.Line }) $rapportPath

$derniersCriticals = ""
Select-String "CRITICAL" $LogFile | Select-Object -Last 3 | ForEach-Object {
    $derniersCriticals += "Ligne $($_.LineNumber) : $($_.Line)`n"
}
$derniersCriticals = $derniersCriticals.TrimEnd()

Ecrire-Rapport "Derniers incidents critiques" $derniersCriticals $rapportPath

Write-Output ""
Write-Output "Rapport sauvegardé : $rapportPath"
