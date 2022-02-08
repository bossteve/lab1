# Azure Monitor (Network Performance Monitor)

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAzure-Monitor_Network-Performance-Monitor%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FAzure-Monitor_Network-Performance-Monitor%2Fazuregovdeploy.json)

!!!Note:  In order to successfully deploy this lab, the following Resource Provider must be enabled:
- Microsoft.ContainerInstance

This Template deploys a the following:

- 1 - Log Analytics Workspace (NPM Solution)
- 2 - Virtual Networks
- 2 - Bastion Hosts
- 2 - Virtual Machines (Connected to Log Analytics Workspace)

Parameters that support changes
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- WorkspaceLocation. Enter a Valid Azure Region for your Log Analytics Workspace based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Virtual Network 2 (Example:  10.2)
- VM1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) VM 1 OS Version
- VM2OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) VM 2 OS Version
- VM1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- VM2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.