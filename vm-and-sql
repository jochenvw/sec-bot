param sqlServerName string = 'mySqlServer'
param adminUsername string = 'adminUser'
param adminPassword securestring = secure('adminPassword')
param vmName string = 'myVM'
param vmSize string = 'Standard_DS2_v2'

var sqlDatabaseName = 'myDatabase'
var sqlUsername = 'myUsername'
var sqlPassword = 'myPassword'

resource sqlServer 'Microsoft.Sql/servers@2020-02-02-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  tags: {
    environment: 'non-production'
  }
  properties: {
    administratorLogin: sqlUsername
    administratorLoginPassword: sqlPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-02-02-preview' = {
  name: '${sqlServerName}/${sqlDatabaseName}'
  dependsOn: [
    sqlServer
  ]
  tags: {
    environment: 'non-production'
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: resourceGroup().location
  dependsOn: [
    sqlServer
  ]
  tags: {
    environment: 'non-production'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmName}-nic'
  location: resourceGroup().location
  dependsOn: [
    virtualNetwork
  ]
  tags: {
    environment: 'non-production'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: 'subnet1'
  tags: {
    environment: 'non-production'
  }
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myVNet'
  location: resourceGroup().location
  tags: {
    environment: 'non-production'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      subnet
    ]
  }
}
