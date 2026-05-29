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

# La bannière est fournie
Write-Host ""
Write-Banner "SETUP NEXACLOUD — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Host ""

# -- 1. Vérification des prérequis -----------------------------------------
Write-Info "Vérification des prérequis..."

$commandes = @("python3", "node", "npm", "git")
foreach ($commande in $commandes) {
    if (-not (Get-Command $commande -ErrorAction SilentlyContinue)) {
        Write-Err "$commande non trouvé"
    }
}


Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

Test-Path "python-api/requirements.txt" | Out-Null
if (Test-Path "python-api/requirements.txt") {
    pip install -r python-api/requirements.txt --quiet
    Write-Ok "Dépendances Python installées"
} else {
    Write-Warn "Fichier requirements.txt introuvable — dépendances Python non installées"
}


# -- 3. Dépendances Node ----------------------------------------------------
Write-Info "Installation des dépendances Node..."

Test-Path "node-client/package.json" | Out-Null
if (Test-Path "node-client/package.json") {
    Set-Location "node-client"
    npm install --silent
    Set-Location ".."
    Write-Ok "Dépendances Node installées"
} else {
    Write-Warn "Fichier package.json introuvable — dépendances Node non installées"
}


# -- 4. Analyse des logs ----------------------------------------------------
Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

Test-Path $logFile | Out-Null
if (Test-Path $logFile) {
    $nbErr  = (Select-String "ERROR"    $logFile).Count
    $nbCrit = (Select-String "CRITICAL" $logFile).Count
    Write-Ok "Logs analysés : $nbErr erreur(s), $nbCrit incident(s) critique(s)"
    if ($nbCrit -gt 0) {
        Write-Err "ALERTE CRITIQUE : $nbCrit incident(s) critique(s) détecté(s) !"
        Write-Output "Détails des incidents critiques :"
        
    }Select-String "CRITICAL" $logFile | ForEach-Object { $_.Line }
} else {
    Write-Warn "Fichier de logs introuvable : $logFile — analyse des logs ignorée"
}


# Le message de fin est fourni
Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""