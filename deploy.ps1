Connect-AzureRmAccount

#Step 1: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
$envPrefixName = 'demo8'
$SecurityResourceGroupName = $envPrefixName + 'ManagementHubSecurity'
New-AzureRMResourceGroup -Name $SecurityResourceGroupName -Location 'East US'
$rg = get-AzureRmresourcegroup -Name $SecurityResourceGroupName

#Step 2: Create Key Vault and set flag to enable for template deployment with ARM
$VaultName = $envPrefixName + 'ManagementHubVault'
New-AzureRmKeyVault -VaultName $VaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 3: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzureKeyVaultSecret -VaultName $VaultName -Name "VMPassword" -SecretValue (Get-Credential).Password

#Step 4: Update Masterdeploy.parameters.json file with your envPrefixName and Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzureRmKeyVault -VaultName $VaultName).ResourceId

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template="C:\Users\rokuehfu\Documents\GitHub\AzureStarterKit-IaaS-3Tier\masterdeploy.json"
$parameterfile="C:\Users\rokuehfu\Documents\GitHub\AzureStarterKit-IaaS-3Tier\Masterdeploy.parameters.json"

New-AzureRmDeployment `
  -Name $job `
  -Location eastus `
  -TemplateFile $template `
  -TemplateParameterFile $parameterfile `
  -envPrefixName $envPrefixName `
  -SecurityKeyVaultName $VaultName `
  -resourceGroupLocation eastus