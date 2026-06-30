targetScope = 'resourceGroup'

@description('Cluster name')
param clusterName string

@description('Location')
param location string

@description('Worker node count')
param workerCount int = 1

@description('OpenShift domain prefix')
param domain string = 'aro-sbx'

@description('Tags')
param tags object = {
  environment: 'sandbox'
  owner: 'platform-team'
  costCenter: 'devops'
  managedBy: 'bicep'
}

var vnetName = '${clusterName}-vnet'
var masterSubnetName = 'master-subnet'
var workerSubnetName = 'worker-subnet'
var nsgName = '${clusterName}-nsg'
var routeTableName = '${clusterName}-rt'

/* =========================
   VNET
========================= */
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags

  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/22'
      ]
    }

    subnets: [
      {
        name: masterSubnetName
        properties: {
          addressPrefix: '10.10.0.0/23'
        }
      }
      {
        name: workerSubnetName
        properties: {
          addressPrefix: '10.10.2.0/23'
        }
      }
    ]
  }
}

/* =========================
   NSG (sandbox baseline)
========================= */
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: nsgName
  location: location
  tags: tags

  properties: {
    securityRules: [
      {
        name: 'allow-https-out'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

/* =========================
   ROUTE TABLE
========================= */
resource routeTable 'Microsoft.Network/routeTables@2023-11-01' = {
  name: routeTableName
  location: location
  tags: tags
}

/* =========================
   SUBNET ASSOCIATIONS
========================= */
resource masterSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  parent: vnet
  name: masterSubnetName
}

resource workerSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  parent: vnet
  name: workerSubnetName
}

/* =========================
   ARO CLUSTER
========================= */
resource aro 'Microsoft.RedHatOpenShift/openShiftClusters@2023-09-04' = {
  name: clusterName
  location: location
  tags: tags

  properties: {
    clusterProfile: {
      domain: domain
      resourceGroupId: resourceGroup().id
      version: '4.18'
    }

    networkProfile: {
      podCidr: '10.128.0.0/14'
      serviceCidr: '172.30.0.0/16'

      masterSubnetId: masterSubnet.id
      workerSubnetId: workerSubnet.id
    }

    masterProfile: {
      vmSize: 'Standard_D8s_v5'
    }

    workerProfiles: [
      {
        name: 'worker'
        vmSize: 'Standard_D8s_v5'
        diskSizeGB: 128
        count: workerCount
      }
    ]

    apiserverProfile: {
      visibility: 'Public'
    }

    ingressProfiles: [
      {
        name: 'default'
        visibility: 'Public'
      }
    ]
  }
}

/* =========================
   OUTPUTS
========================= */

output apiServer string = aro.properties.apiserverProfile.url
output consoleUrl string = aro.properties.consoleProfile.url
output clusterId string = aro.id
