# SQL Server Standalone Lab to Existing VNet
<img src="../x_Images/SQLStandAloneExistingVNet.png" alt="SQL Server StandAlone with Existing VNet" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FSQLServer_Standalone_ExistingVNet%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FSQLServer_Standalone_ExistingVNet%2Fazuregovdeploy.json)

The Template deploys the folowing:

- 1 - Standalone SQL Server

The deployment leverages Desired State Configuration scripts to further customize the following:

SQL Deployment
- Installs SQL Server 2017/2019 based on selection
- Installs SQL Management Studio

Parameters that support changes
- ExistingVNetName.  Enter the complete name of an Existing Virtual Network
- ExistingSubnetName.  Enter the complete name of an Existing Virtual Network Subnet
- SQLServerIP.  Enter an IP Address that belongs to ExistingSubnetName
- SQLServerName.  Enter the name for the SQL Server
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Seer License Type (Example:  Windows_Server or None)
- SQLSASURL.  Enter a valid URL that points to the SQL 2019 or 2017 .ISO
- SQLOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) SQL OS Version
- SQLVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.