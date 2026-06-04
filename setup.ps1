# setup.ps1 — Prépare le projet NexaCloud en une commande

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

Write-Host ""
Write-Banner "SETUP NEXACLOUD — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Host ""

# -- 1. Vérification des prérequis -----------------------------------------
Write-Info "Vérification des prérequis..."

foreach ($cmd in @("python3", "node", "npm")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Err "$cmd est requis mais introuvable — installation interrompue."
    }
}

Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

if (Test-Path "python-api/requirements.txt") {
    pip install -r python-api/requirements.txt --quiet
    Write-Ok "Dépendances Python installées"
} else {
    Write-Warn "python-api/requirements.txt introuvable — étape ignorée"
}

# -- 3. Dépendances Node ----------------------------------------------------
Write-Info "Installation des dépendances Node..."

if (Test-Path "node-client/package.json") {
    Set-Location "node-client"
    npm install --silent
    Set-Location ".."
    Write-Ok "Dépendances Node installées"
} else {
    Write-Warn "node-client/package.json introuvable — étape ignorée"
}

# -- 4. Analyse des logs ----------------------------------------------------
Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

if (Test-Path $logFile) {
    $nbErr  = (Select-String "ERROR"    $logFile).Count
    $nbCrit = (Select-String "CRITICAL" $logFile).Count
    Write-Ok "Logs analysés — ERROR: $nbErr | CRITICAL: $nbCrit"

    if ($nbCrit -gt 0) {
        Write-Host "[ALERTE] $nbCrit incident(s) critique(s) détecté(s) :" -ForegroundColor Red
        Select-String "CRITICAL" $logFile | ForEach-Object { Write-Host "  $($_.Line)" -ForegroundColor Red }
    }
} else {
    Write-Warn "$logFile introuvable — analyse ignorée"
}

Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""
