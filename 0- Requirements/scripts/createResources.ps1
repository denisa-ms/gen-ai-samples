$SubscriptionId = '<your-subscription-id>'
$resourceGroupName = "jpan-genai-workshop"
$location = "australiaeast"

# Check if the Az module is installed
if (-not (Get-Module -ListAvailable -Name Az)) {
    Write-Output "Az module not found. Installing Az module..."
    Install-Module -Name Az -AllowClobber -Force -Scope CurrentUser
}

# Import the Az module
Import-Module Az
# Set subscription 
Set-AzContext -SubscriptionId $subscriptionId 
# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location
# Deploy resources using the Bicep template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile deployAll.bicep -WarningAction:SilentlyContinue

#Use Connect-AzAccount to connect to Azure. If you have multiple Azure subscriptions, you might also need to run Set-AzContext
Set-AzContext -SubscriptionId '89f07bef-2e3f-4ee3-abba-a38a0d048a9e'
# Create a resource group
New-AzResourceGroup -Name 'jpan-demo' -Location 'australiaeast'
# Deploy resources using the Bicep template
New-AzResourceGroupDeployment -Name 'demoDeployment' -ResourceGroupName 'jpan-demo' -TemplateFile '.\0- Requirements\scripts\deployResources.bicep' -WarningAction:SilentlyContinue



New-AzResourceGroupDeployment `
 -Name 'demoDeployment' `
  -ResourceGroupName 'jpan-demo' `
  -TemplateFile '.\0- Requirements\scripts\deployResources.bicep' `
  -WarningAction:SilentlyContinue


New-AzResourceGroupDeployment `
 -Name 'demoDeployment' `
  -ResourceGroupName 'jpan-demo' `
  -TemplateFile deployResources.bicep
