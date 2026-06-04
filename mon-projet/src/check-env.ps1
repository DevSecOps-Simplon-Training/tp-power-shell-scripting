# check-env.ps1 — Vérifie que l'environnement est prêt pour NexaCloud

function Write-Ok { param($m) Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Warn { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Err { param($m) Write-Host "  [ERR]  $m" -ForegroundColor Red }

# Cette fonction vérifie si une commande est installée — elle est fournie
function Test-Commande {
    param([string]$Commande, [string]$Nom)
    # Get-Command cherche si la commande existe
    # -ErrorAction SilentlyContinue évite un message d'erreur si elle est absente
    if (Get-Command $Commande -ErrorAction SilentlyContinue) {
        Write-Ok "$Nom installé"
    }
    else {
        Write-Err "$Nom non trouvé"
    }
}

function Test-File {
    param([string]$Fichier)

    if (Test-Path $Fichier) {
        Write-Ok "Fichier trouvé : $Fichier"
    }
    else {
        Write-Warn "Fichier manquant : $Fichier"
    }
}

Write-Host ""
Write-Host "=== Vérification de l'environnement NexaCloud ===" -ForegroundColor Cyan
Write-Host ""

# Vérifier si les commandes sont installées
foreach ($dependency in @("python", "node", "npm", "git")
) {
    $d = [PSCustomObject]@{
        python = [PSCustomObject]@{
            command = "python3"
            name    = "Python"
        }
        node   = [PSCustomObject]@{
            command = "node"
            name    = "Node.js"
        }
        npm    = [PSCustomObject]@{
            command = "npm"
            name    = "NPM"
        }
        git    = [PSCustomObject]@{
            command = "git"
            name    = "Git"
        }
    }

    Test-Commande $d.$dependency.command $d.$dependency.name
}


Write-Host ""


# Vérifier la présence des fichiers essentiels
foreach ($fichier in @("config.json", "ressources/server.log")) {
    Test-File $fichier
}



Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""