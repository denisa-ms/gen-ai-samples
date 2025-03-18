// General params
param location string = resourceGroup().location

// OpenAI params
// jpan's region is australiaeast
// jpan's workshop date is 2025-02-26
// Region availability: https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models?tabs=standard%2Cstandard-chat-completions#model-summary-table-and-region-availability
param OpenAIServiceName string = 'openai-${uniqueString(resourceGroup().id)}'
param openai_deployments array = [
  {
    name: 'text-embedding-3-small'
	  model_name: 'text-embedding-3-small'
    version: '1'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 20
    sku_name: 'Standard'
  }
  {
    name: 'gpt-4o'
	  model_name: 'gpt-4o'
    //lastest australiaeast global standard 4: 2024-08-06
    version: '2024-08-06'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 120
    sku_name: 'GlobalStandard'
    //latest australiaeast standard 4o: none
    //sku_name: 'Standard'
  }
]

//OpenAI
resource openai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: OpenAIServiceName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

@batchSize(1)
resource model 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = [for deployment in openai_deployments: {
  name: deployment.model_name
  parent: openai
  sku: {
	name: deployment.sku_name
	capacity: deployment.sku_capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.name
      version: deployment.version
    }
    raiPolicyName: deployment.raiPolicyName
  }
}]


// AI Search params
param aisearch_name string = 'aisearch-${uniqueString(resourceGroup().id)}'

//AI Search
resource search 'Microsoft.Search/searchServices@2024-06-01-Preview' = {
  name: aisearch_name
  location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
  }
}


