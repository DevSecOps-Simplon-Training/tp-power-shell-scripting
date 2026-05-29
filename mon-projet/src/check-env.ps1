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

function Test-File {
    param([String[]]$filePaths)
    foreach($filePath in $filePaths){
        if(Test-Path $filePath) {
            Write-Ok "Fichier trouvé : $filePath"
        } else {
            Write-Warn "Fichier manquant : $filePath"
        }
    }
    
}

Write-Host ""
Write-Host "=== Vérification de l'environnement NexaCloud ===" -ForegroundColor Cyan
Write-Host ""

# TODO: appelez Test-Commande pour vérifier python3, node, npm et git
# Exemple : Test-Commande "python3" "Python"
Test-Commande "python3" "Python"
Test-Commande "node" "Node.js"
Test-Commande "npm" "npm"
Test-Commande "git" "Git"

Write-Host ""

# TODO: vérifiez que ces deux fichiers existent avec Test-Path
# Fichiers : "config.json" et "ressources/server.log"
# Si le fichier existe  -> Write-Ok "Fichier trouvé : ..."
# Si le fichier manque  -> Write-Warn "Fichier manquant : ..."
# Indice : vous avez déjà utilisé foreach à l'étape 4

Test-File @("config.json","ressources/server.log")

Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""