# Créer et charger un fichier .env.example
"PORT=5001" | Out-File ".env.example"
"ENV=development" | Add-Content ".env.example"

Get-Content ".env.example" | Where-Object { $_ -match "=" } | ForEach-Object {
    $cle, $valeur = $_ -split "=", 2
    [System.Environment]::SetEnvironmentVariable($cle.Trim(), $valeur.Trim(), "Process")
}
Write-Output "Port : $env.example:PORT"