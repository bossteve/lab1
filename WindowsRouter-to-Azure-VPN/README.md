# WindowsRouter-to-Azure-VPN
<img src="../x_Images/WindowsRRASwithAzureVNG.png" alt="Windows RRAS VPN with Azure Virtual Network Gateway" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FWindowsRouter-to-Azure-VPN%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FWindowsRouter-to-Azure-VPN%2Fazuregovdeploy.json)

This Templates deploys a Azure to OnPrem VPN with a Windows Router used as the On-Premise VPN Device:

- 2 - Resource Groups
- 2 - Virtual Networks
- 2 - Virtual Machines (1-OnPrem, 1-Azure)
- 1 - Virtual Network Gateway
- 2 - Bastion Hosts
- 1 - Windows Router (VM with 2 NIC's and Public IP)
- 1 - Network Security Group
- 1 - Local Network Gateway
- 1 - Connection
- 1 - Route Table

The deployment leverages Desired State Configuration scripts to further customize the following:

Windows Features
- Windows Routing Remote Access configured as a Site-2-Site VPN

Parameters that support changes
- TimeZone.  Select an appropriate Time Zone.
- Location2.  Location for Azure Resources.
- Site1RG. Resource Group Name for On-Prem Resources
- Site2RG. Resource Group Name for Azure Resources
- AdminUsername.  Enter a valid Admin Username
- AdminPassword.  Enter a valid Admin Password
- SharedKey.  Enter a key used as the VPN Pre-Shared Key.
- WindowsServerLicenseType.  Choose Windows_Server if you already have a WindowsServer License or None if you don't
- OP Naming Convention. Enter a name that will be used as a naming prefix for (On-Prem Servers, VNets, etc) you are using.
- AZ Naming Convention. Enter a name that will be used as a naming prefix for (Azure Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for On-Prem Virtual Network(Example:  10.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Azure Virtual Network(Example:  10.2)

- ROUTEROSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Router OS Version
- ROUTERVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.

- AzureOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Azure VM OS Version
- AzureVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.

- OnPremOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OnPrem VM OS Version
- OnPremVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.