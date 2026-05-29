# Informations sur le projet et le log

$nomProjet = "NexaCloud"
$version = "1.1.0"
$logFile = "ressources/server.log"

Write-Output "==============================="
Write-Output "  Projet   : $nomProjet"
Write-Output "  Version  : $version"
Write-Output "==============================="

if (Test-Path $logFile) {
    $nbLignes = (Get-Content $logFile).Count
    Write-Output "  Log      : $logFile ($nbLignes lignes)"
    Write-Output "  Date     : $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
}
else {
    Write-Output "  Log      : fichier introuvable !"
}

Write-Output "==============================="