# azure-keyvault.ps1 — Crée un Key Vault, ajoute et récupère un secret

$keyVaultName = "kv-nexacloud-$((Get-Random -Maximum 9999))"

# Créer le Key Vault
New-AzKeyVault `
    -Name $keyVaultName `
    -ResourceGroupName "mcherfiRG" `
    -Location "francecentral"

# Ajouter un secret
# ConvertTo-SecureString : convertit du texte en objet SecureString (chiffré en mémoire)
# -AsPlainText : l'entrée est du texte brut (pas déjà chiffré)
# -Force       : paramètre obligatoire — confirme qu'on accepte le risque de stocker un mot de passe en clair dans le script
$secret = ConvertTo-SecureString "MonMotDePasse123!" -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "db-password" -SecretValue $secret

# Récupérer un secret
$secretValue = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "db-password" -AsPlainText)
Write-Host "Secret récupéré (longueur : $($secretValue.Length) caractères)" -ForegroundColor Green

# Lister tous les secrets
Get-AzKeyVaultSecret -VaultName $keyVaultName | Format-Table Name, Enabled, Created