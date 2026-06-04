# analyse-niveaux.ps1 — Compte chaque niveau de log avec pourcentage

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

$total = (Get-Content $logFile).Count

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    $pct = [math]::Round($nb * 100 / $total, 1)
    Write-Output "  $niveau : $nb occurrence(s) — $pct%"
}

Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"
