# azure-vm.ps1 — Crée une VM Ubuntu, récupère son IP et se connecte en SSH

$vmName = "vm-nexacloud-tp"

# Créer une VM
New-AzVM `
    -ResourceGroupName "mcherfiRG" `
    -Name $vmName `
    -Location "francecentral" `
    -Image "Ubuntu2204" `
    -Size "Standard_D2s_v3" `
    -GenerateSshKey `
    -SshKeyName "cle-nexacloud"

# Récupérer l'IP publique
$ip = (Get-AzPublicIpAddress -ResourceGroupName "mcherfiRG").IpAddress
Write-Host "IP de la VM : $ip" -ForegroundColor Green

# Se connecter en SSH
ssh azureuser@$ip