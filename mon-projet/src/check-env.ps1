# check-env.ps1 - Verifie que l'environnement est pret pour NexaCloud

function Write-Ok   { param($m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Warn { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "  [ERR]  $m" -ForegroundColor Red }

function Test-Commande {
    param([string]$Commande, [string]$Nom)

    if (Get-Command $Commande -ErrorAction SilentlyContinue) {
        Write-Ok "$Nom installé"
    } else {
        Write-Err "$Nom non trouvé"
    }
}

Write-Host ""
Write-Host "=== Vérification de l'environnement NexaCloud ===" -ForegroundColor Cyan
Write-Host ""

# Vérification des commandes installées
Test-Commande "python3" "Python"
Test-Commande "node" "Node"
Test-Commande "npm" "npm"
Test-Commande "git" "Git"

Write-Host ""

# Vérification des fichiers nécessaires
foreach ($f in @("config.json", "ressources/server.log")) {

    if (Test-Path $f) {
        Write-Ok "Fichier trouvé : $f"
    } else {
        Write-Warn "Fichier manquant : $f"
    }
}

Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""