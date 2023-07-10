param sqlServerName string
param adminUsername string
param adminPassword string
param location string = resourceGroup().location

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    version: '12.0'
    publicNetworkAccess: 'Disabled'
    threatDetectionPolicies: {
      defaultPolicy: {
        state: 'Enabled'
      }
    }
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${sqlServer.name}/databaseName'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    transparentDataEncryption: {
      status: 'Enabled'
    }
  }
}

output sqlServerNameOutput string = sqlServer.name
