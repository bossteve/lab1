# Windows Virtual Desktop Lab with Single AD Site, Server with AD Connect Download, and File Server with OneDrive Migration Tool
<img src="../x_Images/AzureVirtualDesktopFull.png" alt="Azure Site Recovery" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Virtual-Desktop-Full-Lab%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Virtual-Desktop-Full-Lab%2Fazuregovdeploy.json)

!!!NOTE1:  THIS LAB REQUIRES THAT AN AZURE AD GROUP BE CREATED PRIOR TO DEPLOYMENT.  THE OBJECT ID MUST BE PROVIDED WITHIN THE PARAMETERS FOR THE DEPLOYMENT TO SUCCEED. ONCE DEPLOYMENT IS COMPLETE AZURE AD CONNECT CAN BE USED TO SYNC ONPREM ACCOUNT(S)/GROUP(S) THAT CAN BE NESTED WITHIN THE PRE-CREATED AZURE AD GROUP. 

!!!NOTE2:  Please confirm the following procedures outlined in the article below have been performed in order to access the WVD Environment

https://docs.microsoft.com/en-us/azure/virtual-desktop/virtual-desktop-fall-2019/tenant-setup-azure-active-directory#:~:text=To%20grant%20the%20service%20permissions%3A%201%20Open%20a,Virtual%20Desktop%20client%20app.%20...%20More%20items...%20


This Templates deploys a Single Forest/Domain:

- 1 - Active Directory Forest/Domain
- 1 - Domain Controller
- 1 - File Server
- 1 - AD Connect Server
- 1 - Domain Joined Windows 10 Workstation
- 1 - Windows Virtual Desktop Pool
- 1 - Windows Virtual Desktop Application Group
- 1 - Windows Virtual Desktop Workspace
- X - Session Hosts Based on desired count

The deployment leverages Desired State Configuration scripts to further customize the following:

AD OU Structure:
- [domain.com]
- -- Accounts
- --- End User
- ---- Office 365
- ---- Non-Office 365
- --- Admin
- --- Service
- -- Groups
- --- End User
- --- Admin
- -- Servers
- --- Servers2012R2
- --- Serverrs2016
- --- Servers2019
- -- MaintenanceServers
- -- MaintenanceWorkstations
- -- Workstations
- --- Windows10
- --- Windows7

Parameters that support changes
- TimeZone.  Select an appropriate Time Zone.
- UserCount.  Enter the number of User Accounts needed for the Lab. Example: 500
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- WindowsClientLicenseType.  Choose Windows Client License Type (Example:  Windows_Client or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- InternalTLD.  Select a valid Top-Level Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- Reverse Lookup1.  Enter first 2 octets of your desired Address Space in Reverse (Example:  1.10)
- DC1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Domain Controller 1 OS Version
- FS1OSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) File Server 1 OS Version
- WK1OSVersion.  Workstation1 OS Version is not configurable and set to 19h1-pro (Windows 10).
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- FS1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WK1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.