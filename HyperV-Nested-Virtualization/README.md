# Hyper-V Nested Virtualization
<img src="../x_Images/HyperVNestedVirtualization.png.png" alt="Hyper-V Nested Virtualization" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FHyperV-Nested-Virtualization%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FHyperV-Nested-Virtualization%2Fazuredeploy.json)

The Template deploys the folowing:

- 1 - D8s_v3 VM with Hyper-V Enabled

The deployment leverages Desired State Configuration scripts to further customize the following:

Hyper-V Deployment
- Create DataDisk
- Install HyperV
- Create Virtual Switch
- Create NAT Gateway
- Create NAT Network

Parameters that support changes
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- HyperVSubnetID.  Enter first 3 octets of your desired Address Space for HyperV VNet (Example:  192.168.1)
- HVOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Hyper-V OS Version
- HVVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.