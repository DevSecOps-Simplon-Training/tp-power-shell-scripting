# setup.ps1 — Prépare le projet NexaCloud en une commande

# Les fonctions d'affichage sont fournies
function Write-Banner {
    param([string]$Texte, [string]$Couleur = "Cyan")
    $sep = "=" * 44
    Write-Host $sep -ForegroundColor $Couleur
    Write-Host "   $Texte" -ForegroundColor $Couleur
    Write-Host $sep -ForegroundColor $Couleur
}
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "[ERR]  $m" -ForegroundColor Red; exit 1 }
function Write-Crit { param($m) Write-Host "[CRITICAL]  $m" -ForegroundColor Magenta }

# La bannière est fournie
Write-Host ""
Write-Banner "SETUP NEXACLOUD — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Host ""

# -- 1. Vérification des prérequis -----------------------------------------
Write-Info "Vérification des prérequis..."

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

foreach ($f in @(("python3","Python"),("node","node"),("npm","Node Package Manager"),("git","git"))){
	Test-Commande $f[0] $f[1]
}



Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

if (Test-Path "python-api/requirements.txt") {
	pip install -r python-api/requirements.txt --quiet
	Write-Ok "Dépendances Python installées"
} else {
	Write-Warn "attention pas de requirements python"
}


# -- 3. Dépendances Node ----------------------------------------------------
Write-Info "Installation des dépendances Node..."

# TODO: même logique pour "node-client/package.json"
# Si le fichier existe :
#   -> Set-Location "node-client"
#   -> npm install --silent
#   -> Set-Location ".."
#   -> Write-Ok
# Sinon -> Write-Warn
if (Test-Path "node-client/package.json") {
	Set-Location "node-client"
	npm install --silent
	Set-Location ".."
	Write-Ok "packages node installés"
} else {
	Write-Warn "attention pas de requirements python"
}



# -- 4. Analyse des logs ----------------------------------------------------
Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

# TODO: si $logFile existe :
# - comptez les ERROR  -> $nbErr  = (Select-String "ERROR"    $logFile).Count
# - comptez les CRITICAL -> $nbCrit = (Select-String "CRITICAL" $logFile).Count
# - affichez Write-Ok avec les deux compteurs
# - si $nbCrit -gt 0 : affichez un message en rouge
#   et listez les lignes avec Select-String + ForEach-Object { $_.Line }
$logFile = "ressources/server.log"
if (Test-Path $logFile){
	$nbErr  = (Select-String "ERROR"    $logFile).Count
	$nbCrit = (Select-String "CRITICAL" $logFile).Count
	Write-Ok "$nbErr erreur(s) et $nbCrit erreur(s) critique(s) "
	if ($nbCrit -gt 0) {
		Write-Crit "ATTENTION !!!! $nbCrit ERREUR(S) CRITIQUE(S)"
		Select-String "CRITICAL" $logFile | ForEach-Object { 
			Write-Crit "Ligne $($_.LineNumber) : $($_.Line)" 
		}
	}
}


Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""