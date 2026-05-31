# check-env.ps1 — Vérifie que l'environnement est prêt pour NexaCloud

function Write-Ok   { param($m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Warn { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "  [ERR]  $m" -ForegroundColor Red }

# Cette fonction vérifie si une commande est installée — elle est fournie
function Test-Commande {
    param([string]$Commande, [string]$Nom)
    # Get-Command cherche si la commande existe
    # -ErrorAction SilentlyContinue évite un message d'erreur si elle est absente
    if (Get-Command $Commande -ErrorAction SilentlyContinue) {
        Write-Ok "$Nom installé"
    } else {
        Write-Err "$Nom non trouvé"
    }
}

Write-Host ""
Write-Host "=== Vérification de l'environnement NexaCloud ===" -ForegroundColor Cyan
Write-Host ""


# Vérification des commandes
Test-Commande "python3" "Python"
Test-Commande "node" "Node.js"
Test-Commande "npm" "NPM"
Test-Commande "git" "Git"

Write-Host ""

# Vérification des fichiers
$fichiers = @(
    "config.json",
    "ressources/server.log"
)

foreach ($fichier in $fichiers) {
    if (Test-Path $fichier) {
        Write-Ok "Fichier trouvé : $fichier"
    }
    else {
        Write-Warn "Fichier manquant : $fichier"
    }
}


Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""
