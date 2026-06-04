 #analyse-niveaux.ps1 — Compte chaque niveau de log

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    Write-Output "  $niveau : $nb occurrence(s)"
}

$total = (Get-Content $logFile).Count
Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"