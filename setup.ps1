# setup.ps1 — Prépare le projet  en une commande

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

foreach ($cmd in @("python3", "node", "npm")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Err "Commande requise introuvable : $cmd"
    }
}

Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

if (Test-Path "python-api/requirements.txt") {
    & python3 -m pip install -r "python-api/requirements.txt" --quiet
    Write-Ok "Dépendances Python installées"
}
else {
    Write-Warn "Fichier python-api/requirements.txt introuvable"
}

# -- 3. Dépendances Node ----------------------------------------------------
Write-Info "Installation des dépendances Node..."

if (Test-Path "node-client/package.json") {
    Push-Location "node-client"
    npm install --silent
    Pop-Location
    Write-Ok "Dépendances Node installées"
}
else {
    Write-Warn "Fichier node-client/package.json introuvable"
}

# -- 4. Analyse des logs ----------------------------------------------------
Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

if (Test-Path $logFile) {
    $nbErr  = (Select-String -Pattern "ERROR" -Path $logFile).Count
    $nbCrit = (Select-String -Pattern "CRITICAL" -Path $logFile).Count

    Write-Ok "Logs analysés : $nbErr ERROR, $nbCrit CRITICAL"

    if ($nbCrit -gt 0) {
        Write-Host "Des erreurs critiques ont été détectées :" -ForegroundColor Red

        Select-String -Pattern "CRITICAL" -Path $logFile |
            ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
    }
}
else {
    Write-Warn "Fichier de log introuvable : $logFile"
}

# Le message de fin est fourni
Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""
