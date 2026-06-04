# couleurs.ps1 — Tester les fonctions d'affichage

function Write-Ok   { param($m) Write-Host "[OK]   $m" -ForegroundColor Green }
function Write-Info { param($m) Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn { param($m) Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err  { param($m) Write-Host "[ERR]  $m" -ForegroundColor Red }

# Test
Write-Ok   "Installation réussie"
Write-Info "Démarrage du serveur..."
Write-Warn "Mémoire basse : 78%"
Write-Err  "Connexion échouée"