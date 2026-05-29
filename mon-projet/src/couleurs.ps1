# couleurs.ps1 — Tester les fonctions d'affichage

# Ces deux fonctions sont déjà écrites — observez leur structure
function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }

# TODO: écrivez Write-Warn en jaune avec le préfixe [WARN]
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
# TODO: écrivez Write-Err  en rouge avec le préfixe [ERR]
function Write-Err { param($m) Write-Host "[ERROR] $m" -ForegroundColor Red }

# Test — ces 4 lignes doivent s'afficher chacune dans la bonne couleur
Write-Ok   "Installation réussie"
Write-Info "Démarrage du serveur..."
Write-Warn "Mémoire basse : 78%"
Write-Err  "Connexion échouée"