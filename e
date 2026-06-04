$fichierLog = "ressources/server.log"

$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")

function Compter-Niveau {
    param(
        [string]$Niveau, 
        [string]$Fichier
    )
    return (Select-String -Path $Fichier -Pattern $Niveau).Count
}

Write-Output "=== Analyse de $fichierLog ==="

foreach ($niveau in $niveaux) {
    $nbOccurences = Compter-Niveau -Niveau $niveau -Fichier $fichierLog
    "{0,-8} : {1}" -f $niveau, $nbOccurences
}

Write-Output "======================================="

$nbCritical = Compter-Niveau -Niveau "CRITICAL" -Fichier $fichierLog

if ($nbCritical -gt 0) {
    Write-Output "WARNING: ALERTE CRITIQUE : $nbCritical incident(s) critique(s) détecté(s) !"
}
