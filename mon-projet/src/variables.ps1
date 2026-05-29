# Variables en PowerShell

# Déclarer et utiliser une variable
$nomProjet = "NexaCloud"
$port = 5001
Write-Output "Projet : $nomProjet, Port : $port"

# Typage explicite (optionnel mais recommandé dans les scripts)
[string]$nom   = "NexaCloud"
[int]$port     = 5001
[bool]$debug   = $true

# Tableau
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
Write-Output $niveaux[0]   # INFO
Write-Output $niveaux.Count

# Hashtable (dictionnaire)
$config = @{
    projet = "NexaCloud"
    port   = 5001
    env    = "development"
}
Write-Output $config["projet"]
Write-Output $config.port