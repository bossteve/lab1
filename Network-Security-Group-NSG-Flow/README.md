# NSG Flow Log
<img src="../x_Images/AzureNSGFlowLogs.png" alt="Azure Network Security Group Flow Logs" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FNetwork-Security-Group-NSG-Flow%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FNetwork-Security-Group-NSG-Flow%2Fazuredeploy.json)

This Templates deploys an NSG Flow Log enabled Environemnt with the following resources:

- 1 - Storage Account
- 1 - Network Security Group
- 1 - Log Analytic Workspace (Only for Gov Deployments)
- 1 - Virtual Network
- 1 - Web Server
- 1 - Tools Server (PowerBi Desktop)

Parameters that support changes
- Resource Group. Resource Group Name for Resources.
- FlowLogName. Name of NSG Flow Log
- AdminUsername.  Enter a valid Admin Username
- AdminPassword.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- WEBOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) for Web Server OS Version
- ToolsOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) for Tools Server OS Version
- WEBVMSize.  Enter a Valid VM Size based on which Region the Web Server is deployed.
- TOOLSVMSize.  Enter a Valid VM Size based on which Region the Tools Server deployed.
- UniqueID. Enter a valid identifier for your Log Analytics Workspace.