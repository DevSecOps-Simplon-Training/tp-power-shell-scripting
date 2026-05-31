# Créer et charger un fichier .env
"PORT=5001" | Out-File ".env"
"ENV=development" | Add-Content ".env"

Get-Content ".env" | Where-Object { $_ -match "=" } | ForEach-Object {
    $cle, $valeur = $_ -split "=", 2
    [System.Environment]::SetEnvironmentVariable($cle.Trim(), $valeur.Trim(), "Process")
}
Write-Output "Port : $env:PORT"