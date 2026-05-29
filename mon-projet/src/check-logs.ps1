# check-logs.ps1 — Vérifie l'état des logs et alerte si nécessaire

param(
    [string]$LogFile = "ressources/server.log",
    [int]$Seuil = 3
)

if (-not (Test-Path $LogFile)) {
    Write-Error "Le fichier $LogFile n'existe pas."
    exit 1
}

$nbErreurs   = (Select-String "ERROR"    $LogFile).Count
$nbCritiques = (Select-String "CRITICAL" $LogFile).Count
$nbWarnings  = (Select-String "WARNING"  $LogFile).Count
$nbInfos     = (Select-String "INFO"     $LogFile).Count

Write-Output "=== Analyse de $LogFile ==="
Write-Output "  INFO     : $nbInfos"
Write-Output "  WARNING  : $nbWarnings"
Write-Output "  ERROR    : $nbErreurs"
Write-Output "  CRITICAL : $nbCritiques"
Write-Output "==========================="

if ($nbCritiques -gt 0) {
    Write-Warning "ALERTE CRITIQUE dans $LogFile : $nbCritiques incident(s) critique(s) détecté(s) !"
} elseif ($nbErreurs -gt $Seuil) {
    Write-Warning "ATTENTION : $nbErreurs erreurs détectées (seuil : $Seuil)"
} else {
    Write-Output "OK : les logs sont dans les normes."
}