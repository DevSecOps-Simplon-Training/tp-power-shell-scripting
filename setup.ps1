# setup.ps1 — Prépare le projet NexaCloud en une commande
Get-Location | Write-Host
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

# TODO: parcourez @("python3","node","npm") avec foreach
# Pour chaque commande, vérifiez avec Get-Command si elle existe
# Si elle n'existe pas (-not ...) -> appelez Write-Err pour stopper
foreach($dependency in @("python3","node","npm")){
    if(-not (Get-Command $dependency -ErrorAction SilentlyContinue)){
        Write-Err "$dependency non installé"
    }
}


Write-Ok "Prérequis : Python3, Node.js, npm présents"

# -- 2. Dépendances Python --------------------------------------------------
Write-Info "Installation des dépendances Python..."

# TODO: si "python-api/requirements.txt" existe (Test-Path)
# -> pip install -r python-api/requirements.txt --quiet
# -> Write-Ok "Dépendances Python installées"
# Sinon -> Write-Warn pour prévenir sans bloquer

$requirementsPath="python-api/requirements.txt"
if(Test-Path "$requirementsPath"){
    pip install -r $requirementsPath --quiet
    Write-Ok "Dépendances Python installées"
} else {
    Write-Warn "Fichier $requirementsPath non présent"
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

$nodePath="node-client/package.json"
if(Test-Path "$nodePath"){
    Set-Location "node-client"
    npm install --silent
    Write-Ok "Dépendances Node installées"
    Set-Location ".."
} else {
    Write-Warn "Fichier $nodePath non présent"
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

if(-not (Test-Path $logFile)){
    Write-Warn "$logFile n'existe pas"
} else {
    $nbErr = (Select-String "ERROR" $logFile).Count
    $nbCrit = (Select-String "CRITICAL" $logFile).Count
    Write-Ok "$nbErr errors"
    Write-Ok "$nbErr criticals"
    if($nbCrit -gt 0){
        Write-Host "!!! $nbCrit ERREURS CRITIQUES !!!" -ForegroundColor Red
    }
}

# Le message de fin est fourni
Write-Host ""
Write-Banner "SETUP TERMINÉ AVEC SUCCÈS" "Green"
Write-Host ""
Write-Host "  Lancer l'API Python  : Set-Location python-api; python3 app.py"
Write-Host "  Lancer le client Node: Set-Location node-client; node app.js"
Write-Host ""