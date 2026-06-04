$logFile = "ressources/server.log"
$contenu = Get-Content $logFile

$rapport = @"
=== RAPPORT DE LOGS ===
Total lignes : $($contenu.Count)
Erreurs      : $((Select-String "ERROR" $logFile).Count)
Warnings     : $((Select-String "WARNING" $logFile).Count)
Critiques    : $((Select-String "CRITICAL" $logFile).Count)
"@

Write-Output $rapport

$rapport | Out-File "rapport.txt" -Encoding UTF8
Write-Output "Rapport sauvegardé : rapport.txt"

Select-String "ERROR" $logFile | ForEach-Object { $_.Line } | Out-File "erreurs.txt"
