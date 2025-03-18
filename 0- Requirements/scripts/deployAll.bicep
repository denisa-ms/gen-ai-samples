// General params
param location string = resourceGroup().location

// SQL Server params
param serverName string = 'sqlserver-${uniqueString(resourceGroup().id)}'
param databaseName string = 'genaiworks'
param adminLoginsql string = 'SqlAdmin'
@secure()
param adminPasswordsql string = 'jpangenaiworkshop@au2025!'

// Cosmos DB params
@maxLength(44)
param clusterName string = 'msdocs-${uniqueString(resourceGroup().id)}'
param adminUsernamecosmos string = 'CosmosAdmin'
@secure()
@minLength(8)
@maxLength(128)
param adminPasswordcosmos string = 'jpangenaiworkshop@au2025!'

// Speech Service params
param SpeechServiceName string = 'aispeech-${uniqueString(resourceGroup().id)}'
param speech_location string = 'australiaeast'
param vision_location string = 'australiaeast'

// OpenAI params
// jpan's region is australiaeast
// jpan's workshop date is 2025-02-26
// Region availability: https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models?tabs=standard%2Cstandard-chat-completions#model-summary-table-and-region-availability
param OpenAIServiceName string = 'openai-${uniqueString(resourceGroup().id)}'
param openai_deployments array = [
  {
    name: 'text-embedding-ada-002'
	  model_name: 'text-embedding-ada-002'
    version: '2'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 20
    sku_name: 'Standard'
  }
  {
    name: 'text-embedding-3-small'
	  model_name: 'text-embedding-3-small'
    version: '1'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 20
    sku_name: 'Standard'
  }
  {
    name: 'gpt-4'
	  model_name: 'gpt-4'
    //lastest australiaeast global standard 4: turbo-2024-04-09
    version: 'turbo-2024-04-09'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 20
    sku_name: 'GlobalStandard'
    //lastest australiaeast standard 4: 1106-Preview
    //version: '1106-Preview'
    //sku_name: 'Standard'
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
  {
    name: 'gpt-4o-mini'
	  model_name: 'gpt-4o-mini'
    //lastest australiaeast global standard 4o-mini: 2024-07-18
    version: '2024-07-18'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 20
    sku_name: 'GlobalStandard'
    //latest australiaeast standard 4o-mini: none
    //sku_name: 'Standard'
  }
  {
    name: 'dall-e-3'
	  model_name: 'dall-e-3'
    version: '3.0'
    raiPolicyName: 'Microsoft.Default'
    sku_capacity: 1
    sku_name: 'Standard'
  }
]

// AI Search params
param aisearch_name string = 'aisearch-${uniqueString(resourceGroup().id)}'

// AI Vision params
param aivision_name string = 'aivision-${uniqueString(resourceGroup().id)}'


//resources
//Azure SQL Server, firewall rule, and database
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: adminLoginsql
    administratorLoginPassword: adminPasswordsql
  }
}

resource sqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  parent: sqlServer
  name: 'Allow Azure Services'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: databaseName
  parent: sqlServer
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    sampleName: 'AdventureWorksLT'
  }
}

//Cosmos DB
resource cluster 'Microsoft.DocumentDB/mongoClusters@2022-10-15-preview' = {
  name: clusterName
  location: location
  properties: {
    administratorLogin: adminUsernamecosmos
    administratorLoginPassword: adminPasswordcosmos
    nodeGroupSpecs: [
        {
            kind: 'Shard'
            shardCount: 1
            sku: 'M40'
            diskSizeGB: 128
            enableHa: false
        }
    ]
  }
}

resource firewallRules 'Microsoft.DocumentDB/mongoClusters/firewallRules@2022-10-15-preview' = {
  parent: cluster
  name: 'AllowAllAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

//Speech Service
resource cognitiveService 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: SpeechServiceName
  location: speech_location
  sku: {
    name: 'S0'
  }
  kind: 'SpeechServices'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

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

//Computer Vision
resource vision 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: aivision_name
  location: vision_location
  sku: {
    name: 'S1'
  }
  kind: 'ComputerVision'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

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


