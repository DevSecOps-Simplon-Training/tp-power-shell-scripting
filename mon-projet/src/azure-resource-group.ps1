# Créer un ressource group

$resourceGroup = "mcherfiRG2"
$location = "francecentral"
$storageAccount = "stnexacloud$((Get-Random -Maximum 9999))"

# Créer un resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Lister les resource groups
Get-AzResourceGroup | Format-Table ResourceGroupName, Location, ProvisioningState

# Vérifier l'état
(Get-AzResourceGroup -Name $resourceGroup).ProvisioningState

New-AzStorageAccount `
    -ResourceGroupName "$resourceGroup" `
    -Name "$storageAccount" | Out-Null

if ((Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).ProvisioningState -eq "Succeeded") {
    Write-Host "Le compte de stockage $storageAccount a été créé avec succès dans le groupe de ressources $resourceGroup." -ForegroundColor Green
}
else {
    Write-Host "Échec de la création du compte de stockage $storageAccount dans le groupe de ressources $resourceGroup." -ForegroundColor Red
}