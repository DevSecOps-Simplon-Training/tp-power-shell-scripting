# couleurs.ps1 — Tester les fonctions d'affichage

# Ces deux fonctions sont déjà écrites — observez leur structure
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn {
    param($m)
    Write-Host "[WARN] $m" -ForegroundColor Yellow
}

function Write-Err {
    param($m)
    Write-Host "[ERR] $m" -ForegroundColor Red
}



# Test — ces 4 lignes doivent s'afficher chacune dans la bonne couleur
Write-Ok   "Installation réussie"
Write-Info "Démarrage du serveur..."
Write-Warn "Mémoire basse : 78%"
Write-Err  "Connexion échouée"