# analyse-niveaux.ps1 — Compte chaque niveau de log

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

$total = (Get-Content $logFile).Count

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    $pct = [int]($nb / $total * 100)
    Write-Output "  $niveau : $nb occurrence(s) - $pct%"
}

Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"