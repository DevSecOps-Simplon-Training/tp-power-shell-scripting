# check-logs.ps1 — Vérifie l'état des logs et alerte si nécessaire

$logFile       = "ressources/server.log"
$seuilErreurs  = 3

if (-not (Test-Path $logFile)) {
    Write-Error "Le fichier $logFile n'existe pas."
    exit 1
}

$nbErreurs   = (Select-String "ERROR"    $logFile).Count
$nbCritiques = (Select-String "CRITICAL" $logFile).Count
$nbWarnings  = (Select-String "WARNING"  $logFile).Count
$nbInfos     = (Select-String "INFO"     $logFile).Count

Write-Output "=== Analyse de $logFile ==="
Write-Output "  INFO     : $nbInfos"
Write-Output "  WARNING  : $nbWarnings"
Write-Output "  ERROR    : $nbErreurs"
Write-Output "  CRITICAL : $nbCritiques"
Write-Output "==========================="

if ($nbCritiques -gt 0) {
    Write-Warning "ALERTE CRITIQUE : $nbCritiques incident(s) critique(s) détecté(s) !"
} elseif ($nbErreurs -gt $seuilErreurs) {
    Write-Warning "ATTENTION : $nbErreurs erreurs détectées (seuil : $seuilErreurs)"
} else {
    Write-Output "OK : les logs sont dans les normes."
}