$logFile = "ressources/server.log"
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

$total = (Get-Content $logFile).Count

Write-Output "=== Analyse par niveau ==="

foreach ($niveau in $niveaux) {
    $nb = (Select-String $niveau $logFile).Count
    $pourcentage = [math]::Round($nb * 100 / $total, 0)
    
    "{0,-8} : {1} occurrence(s) - {2}%" -f $niveau, $nb, $pourcentage
}

Write-Output "=============================="
Write-Output " TOTAL : $total lignes"
