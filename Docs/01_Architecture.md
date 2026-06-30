# ARO Sandbox Architecture

This sandbox deploys an Azure Red Hat OpenShift cluster using Bicep and Azure DevOps

## Components

### 1. Resource Group
Each sandbox cluster is isolated:
- rg-aro-sandbox01
- rg-aro-sandbox02

---

### 2. Networking
- VNet: 10.10.0.0/22
- Master Subnet: 10.10.0.0/23
- Worker Subnet: 10.10.2.0/23

---

### 3. ARO Cluster
- 3 control plane nodes (managed by Azure)
- 1 worker node (configurable)
- Public API endpoint (sandbox mode)

---

### 4. Deployment Flow

1. Azure DevOps pipeline triggered
2. Resource group created
3. Bicep deployment executed
4. ARO cluster provisioned
5. Validation executed
6. Credentials retrieved

---

### 5. Destroy Flow

1. Manual approval required
2. Resource group deleted
3. All dependencies removed automatically
