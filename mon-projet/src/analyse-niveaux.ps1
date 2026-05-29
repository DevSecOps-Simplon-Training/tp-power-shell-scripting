# analyse-niveaux.ps1 — Compte chaque niveau de log

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    $total = (Get-Content $logFile).Count
    $pourcentage = [math]::Round($nb * 100 / $total)
    Write-Output "  $niveau : $nb occurrence(s) - $pourcentage%"
}

$total = (Get-Content $logFile).Count
Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"