# --- VARIABLES ---
# Déclarer et utiliser une variable
$nomProjet = "NexaCloud"
$port = 5001
Write-Output "Projet : $nomProjet, Port : $port"

# Typage explicite
[string]$nom = "NexaCloud"
[int]$portExplicite = 5001
[bool]$debug = $true

# Tableau
$niveaux = @("INFO", "WARNING", "ERROR", "CRITICAL")
Write-Output $niveaux[0]
Write-Output $niveaux.Count

# Hashtable (dictionnaire)
$config = @{
    projet = "NexaCloud"
    port   = 5001
    env    = "development"
}
Write-Output $config["projet"]
Write-Output $config.port

# --- CONDITIONS ---
$nb = 5

if ($nb -gt 10) {
    Write-Output "Grand"
} elseif ($nb -eq 5) {
    Write-Output "Exactement 5"
} else {
    Write-Output "Petit"
}
