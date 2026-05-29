$logFile = "ressources/server.log"
$contenu = Get-Content $logFile

$rapport = @"
=== RAPPORT DE LOGS ===
Total lignes : $($contenu.Count)
Erreurs      : $((Select-String "ERROR" $logFile).Count)
Warnings     : $((Select-String "WARNING" $logFile).Count)
Critiques    : $((Select-String "CRITICAL" $logFile).Count)
"@

# Afficher dans le terminal
Write-Output $rapport

# Sauvegarder dans un fichier
$rapport | Out-File "rapport.txt" -Encoding UTF8
Write-Output "Rapport sauvegardé : rapport.txt"

# Extraire les erreurs dans un fichier séparé
Select-String "ERROR" $logFile | ForEach-Object { $_.Line } | Out-File "erreurs.txt"