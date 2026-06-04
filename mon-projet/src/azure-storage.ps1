# azure-storage.ps1 — Crée un compte de stockage et uploade server.log

param(
    [string]$ResourceGroup  = "rg-nexacloud-tp",
    [string]$Location       = "francecentral",
    [string]$FichierLocal   = "ressources/server.log"
)

$storageAccount = "stnexacloud$((Get-Random -Maximum 9999))"
$container      = "logs"

Write-Host "=== Création du compte de stockage Azure ===" -ForegroundColor Cyan

# Créer le compte de stockage
$storage = New-AzStorageAccount `
    -ResourceGroupName $ResourceGroup `
    -Name $storageAccount `
    -Location $Location `
    -SkuName Standard_LRS `
    -Kind StorageV2

Write-Host "Compte créé : $storageAccount" -ForegroundColor Green

# Récupérer le contexte de stockage
$cle = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name $storageAccount)[0].Value
$ctx = New-AzStorageContext -StorageAccountName $storageAccount -StorageAccountKey $cle

# Créer le conteneur
New-AzStorageContainer -Name $container -Context $ctx -Permission Off | Out-Null
Write-Host "Conteneur créé : $container" -ForegroundColor Green

# Uploader le fichier
Set-AzStorageBlobContent `
    -Container $container `
    -File $FichierLocal `
    -Blob "server.log" `
    -Context $ctx | Out-Null

Write-Host "Fichier uploadé : server.log" -ForegroundColor Green

# Lister les blobs
Write-Host "`n=== Contenu du conteneur ===" -ForegroundColor Cyan
Get-AzStorageBlob -Container $container -Context $ctx |
    Select-Object Name, Length, LastModified | Format-Table
