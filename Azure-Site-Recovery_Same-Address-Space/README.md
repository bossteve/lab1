# Azure Site Recovery (Same Address Space)
<img src="../x_Images/ASR.png" alt="Azure Site Recovery" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Site-Recovery_Same-Address-Space%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Site-Recovery_Same-Address-Space%2Fazuregovdeploy.json)


This Templates deploys a Azure Site Recovery Lab which includes a Customer Managed Key Encrypted VM that is backed up within Region 1's Recovery Service Vault and replicated to Region 2's Recovery Services Vault:

- 1 - Server
- 2 - Azure Key Vaults (1 within each Region)
- 2 - RSA Key Vault Keys (1 within each Region)
- 2 - Double-Encrypted Disk Encryption Sets (1 within each Region)
- 2 - Azure Storage Accounts (1 Cache Storage & 1 Target Storage)
- 2 - Recovery Services Vaults (1 within each Region)

!!!Note:  In order to successfully deploy this lab, you will need the Object ID of the account that will accessing your KeyVault

The deployment leverages Desired State Configuration scripts to further customize the following:

Parameters that support changes
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- Site1RG.  Enter the name for the Site 1 Resource Group.
- Site2RG.  Enter the name for the Site 2 Resource Group.
- Admin Object ID. Enter the Object ID for the Admin Account that will need access the Azure KeyVaults and Recovery Services Vaults.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- SRV1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Root CA OS Version
- SRV1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- KeyVaultUniqueID. Enter a valid identifier for your Azure Key Vaults.
- RecoveryServicesVaultUniqueID. Enter a valid identifier for your Azure Recovery Services Vaults.