# Exporter les résultats en CSV
Get-ChildItem "ressources/" | Select-Object Name, Length, LastWriteTime | Export-Csv "fichiers.csv" -NoTypeInformation

# Compter les occurrences par niveau de log
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
$niveaux | ForEach-Object {
    $nb = (Select-String $_ "ressources/server.log").Count
    [PSCustomObject]@{ Niveau = $_; Occurrences = $nb }
} | Format-Table

# Chercher sans tenir compte de la casse
Select-String -Pattern "error" -Path "ressources/server.log" -CaseSensitive:$false

