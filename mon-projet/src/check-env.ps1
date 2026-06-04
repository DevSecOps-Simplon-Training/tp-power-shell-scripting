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

Test-Commande "python3" "Python"
Test-Commande "node" "node"
Test-Commande "node" "Node Package Manager"
Test-Commande "git" "git"



Write-Host ""


function Test-Chemin {
	param([string]$fichier)
	if (Test-Path $fichier) {
		Write-Ok "c'est bon le zin, le fichier $fichier est là"
	} else {
		Write-Warn "Le fichier $fichier n'existe pas."
	}
}

foreach ($f in @("ressources/server.log","config.json")){
	Test-Chemin $f
}


Write-Host ""
Write-Host "=== Vérification terminée ===" -ForegroundColor Cyan
Write-Host ""