# Azure Network Watcher (Connection Monitor)
<img src="../x_Images/NetworkWatcherConnectionMonitor.png" alt="Azure Network Watcher" width="150">
Deploys 2 VM's that utilize Network Watcher to test traffic via VNet Peering between a Source VM on VNet1 and Destination VM on VNet2 running IIS over port 80/TCP using the Connection Monitor feature of Network Watcher.

Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Network-Watcher_Connection-Monitor%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Network-Watcher_Connection-Monitor%2Fazuregovdeploy.json)

!!!Note:  In order to successfully deploy this lab, the following Resource Provider must be enabled:
- Microsoft.ContainerInstance

This Template deploys a the following:

- 1 - Log Analytics Workspace
- 1 - Network Watcher (Connection Monitor)
- 2 - Virtual Networks
- 1 - Bastion Host
- 2 - Virtual Machines (Connected to Log Analytics Workspace)(Destination IIS Server)

Parameters that support changes
- ResourceGroup.  Enter the name for the Resource Group to deploy Resources.
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- TimeZone.  Select an appropriate Time Zone.
- AutoShutdownEnabled.  Yes = AutoShutdown Enabled, No = AutoShutdown Disabled.
- AutoShutdownTime.  24-Hour Clock Time for Auto-Shutdown (Example: 1900 = 7PM)
- AutoShutdownEmail.  Auto-Shutdown notification Email (Example:  user@domain.com)
- WorkspaceLocation. (Azure Government Only Parameter) Enter a Valid Azure Region for your Log Analytics Workspace based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using. 
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
- UniqueID. Enter a valid identifier for your Log Analytics Workspace.