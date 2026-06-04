# analyse-niveaux.ps1 — Compte chaque niveau de log

$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

Write-Output "=== Analyse par niveau ==="


foreach ($level in $levels) {
    $nb = (Select-String -Path $logFile -Pattern $level).Count
    $pourcentage = [math]::Round($nb * 100 / $total, 1)

    Write-Host ("{0,-8} : {1} occurrence(s) — {2}%" -f $level, $nb, $pourcentage)
}


$levels = "INFO", "WARNING", "ERROR", "CRITICAL"

$total = (Get-Content $logFile).Count
Write-Output "=========================="
Write-Output "  TOTAL : $total lignes"


