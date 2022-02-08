# AKS Private Cluster with Custom DNS Server - Linux
<img src="../x_Images/AKSPrivateCluster" alt="Azure Kubernetes" width="150">
Click a button below to deploy to the cloud of your choice

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAKS-PrivateCluster-with-CustomDNS-Linux%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAKS-PrivateCluster-with-CustomDNS-Linux%2Fazuredeploy.json)

!!!!NOTE:  YOU WILL NEED A SSH KEY PAIR TO USE WITHIN THIS DEPLOYMENT IN ORDER TO SUCCESSFULLY CONNECT TO THE NODE AGENT POOL INSTANCES.

This Templates deploys a an Private AKS Cluster which uses an External DNS Proxy to provide resolution outside of the AKS Network:

- 3 - Virtual Networks (OnPremise, Hub, Spoke)
- 1 - Bastion Host
- 1 - Azure Private DNS Zone
- 1 - User Managed Identity
- 2 - Azure Private DNS Zone Virtual Network Links
- 1 - DNS Proxy Server (Conditional Forwarders for OnPremise DNS and Azure Private DNS Zone)
- 1 - AKS Management Workstation (On AKS/Spoke VNet)
- 1 - OnPremise Domain Controller (Conditional forwarder for AKS Private DNS Zone)
- 1 - OnPremise Workstation


Parameters that support changes
- TimeZone.  Select an appropriate Time Zone.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- Admin Key.  Enter a valid SSH Private Key
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- WindowsClientLicenseType.  Choose Windows Client License Type (Example:  Windows_Client or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- InternalTLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- LocalDNSDomain.  Enter the Zone Name for DNS Proxy Local DNS.  (Example: dns.local)
- Vnet0ID.  Enter first 2 octets of your desired Address Space for OnPrem Virtual Network (Example:  10.1)
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Spoke Virtual Network 1 (Example:  10.20)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Hub Virtual Network 1 (Example:  10.21)
- PODID.  Enter first 2 octets for podCIDR (Example: 10.30)
- SERVICEID.  Enter first 2 octets for serviceCIDR (Example: 10.31)
- Reverse Lookup0.  Enter first 2 octets for VNet0ID (OnPrem) in Reverse (Example:  1.10)
- Reverse Lookup1.  Enter first 2 octets for VNet0ID (Hub) in Reverse (Example:  21.10)
- DNSOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019)  or 2012-R2-Datacenter (Windows 2012 R2) DNS Proxy OS Version
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) or 2012-R2-Datacenter (Windows 2012 R2)Domain Controller 1 OS Version
- WKOSVersion.  Workstation1 OS Version is not configurable and set to 19h1-pro (Windows 10).
- DNSVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WKVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.