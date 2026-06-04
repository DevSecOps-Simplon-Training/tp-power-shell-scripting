function Write-Banner {
    param([string]$Texte, [string]$Couleur = "Cyan")
    $sep = "=" * 44
    Write-Host $sep -ForegroundColor $Couleur
    Write-Host " $Texte" -ForegroundColor $Couleur
    Write-Host $sep -ForegroundColor $Couleur
}

function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "[ERR]  $m" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Banner "SETUP NEXACLOUD - $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Host ""

Write-Info "Vérification des prérequis..."

$prerequis = @("python3", "node", "npm")
foreach ($cmd in $prerequis) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Err "La commande '$cmd' est manquante. Installation interrompue."
    }
}

Write-Ok "Prérequis : Python3, Node.js, npm présents"

Write-Info "Installation des dépendances Python..."

$reqPython = "python-api/requirements.txt"
if (Test-Path $reqPython) {
    pip install -r $reqPython --quiet
    Write-Ok "Dépendances Python installées"
} else {
    Write-Warn "Fichier $reqPython introuvable, installation ignorée"
}

Write-Info "Installation des dépendances Node..."

$packageNode = "node-client/package.json"
if (Test-Path $packageNode) {
    Set-Location "node-client"
    npm install --silent
    Set-Location ".."
    Write-Ok "Dépendances Node installées"
} else {
    Write-Warn "Fichier $packageNode introuvable, installation ignorée"
}

Write-Info "Analyse des logs..."
$logFile = "ressources/server.log"

if (Test-Path $logFile) {
    $nbErr = (Select-String "ERROR" $logFile).Count
    $nbCrit = (Select-String "CRITICAL" $logFile).Count
    
    Write-Ok "Erreurs : $nbErr, Critiques : $nbCrit"
    
    if ($nbCrit -gt 0) {
        Write-Host "Attention : incidents critiques détectés !" -ForegroundColor Red
        Select-String "CRITICAL" $logFile | ForEach-Object { $_.Line }
    }
} else {
    Write-Warn "Fichier de log introuvable : $logFile"
}

Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host " Lancer l'API Python : Set-Location python-api; python3 app.py"
Write-Host " Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""
