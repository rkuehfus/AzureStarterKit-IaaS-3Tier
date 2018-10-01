Connect-AzureRmAccount

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template="C:\Users\rokuehfu\Documents\GitHub\AzureStarterKit-IaaS-3Tier\masterdeploy.json"

New-AzureRmDeployment `
  -Name $job `
  -Location eastus `
  -TemplateFile $template `
  -envPrefixName demo1 `
  -resourceGroupLocation eastus