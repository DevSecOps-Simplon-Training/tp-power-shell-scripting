# info.ps1 - Affiche des informations sur l'environnement

$nomProjet = "NexaCloud"
$version   = "1.1.0"
$logFile   = "ressources/server.log"

Write-Output "==============================="
Write-Output "  Projet   : $nomProjet"
Write-Output "  Version  : $version"
Write-Output "==============================="

if (Test-Path $logFile) {
    $nbLignes = (Get-Content $logFile).Count
    Write-Output "  Log      : $logFile ($nbLignes lignes)"
} else {
    Write-Output "  Log      : fichier introuvable !"
}

Write-Output "==============================="
