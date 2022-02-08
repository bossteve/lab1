# Exchange 2010 Lab with External Access Multi-Site
<img src="../x_Images/Exchange2010MultiSite.png" alt="Exchange 2010" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FExchange2010-Multi-Site-with-External-Access%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FExchange2010-Multi-Site-with-External-Access%2Fazuregovdeploy.json)

!!!!NOTE:  PLEASE MAKE SURE TO APPLY CRITICAL SECURITY UPDATE KB5000871 TO BOTH EXCHANGE SERVERS AFTER THE DEPLOYMENT IS COMPLETE.

    This Templates deploys a Single Forest/Domain:

- 1 - Active Directory Forest/Domain
- 2 - Active Directory Sites
- 2 - Domain Controllers (1 within each AD Site)
- 1 - Offline Root Certificate Authority Server
- 1 - Issuing Certificate Authority Server
- 1 - Online Certificate Status Protocol Server
- 1 - Exchange 2010 Organization
- 2 - Exchange 2010 Servers (1 within each AD Site)
- 2 - File Share Witness Servers (1 within each AD Site)
- 1 - Database Availability Group
- 2 - Domain Joined Windows 10 Workstations (1 within each AD Site)
- 1 - Azure DNS Zone (Created based on NetBiosDomain and TLD Parameters)
- 2 - Network Security Groups (1 Created in each Region)
- 1 - Bastion Host (VNet1)(Can be used to connect to VNet2 VM's since Peered)

The deployment also makes the following customizations:
- Adds Public IP Address to OCSP and Exchange Servers.
- Creates Azure DNS Zone Records based on the correesponding Servers Public IP
- -- OCSP (OCSP VM Public IP)
- -- OWA2010 (Exchange VM1 Public IP)
- -- OWA2010 (Exchange VM2 Public IP)
- -- AUTODISCOVER2010 (Exchange VM1 Public IP)
- -- AUTODISCOVER2010 (Exchange VM2 Public IP)
- -- OUTLOOK2010 (Exchange VM1 Public IP)
- -- OUTLOOK2010 (Exchange VM2 Public IP)
- -- EAS2010 (Exchange VM1 Public IP)
- -- EAS2010 (Exchange VM2 Public IP)
- -- SMTP (Exchange VM1 Public IP)
- -- SMTP (Exchange VM2 Public IP)

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
- --- Servers2016
- --- Servers2019
- -- MaintenanceServers
- -- MaintenanceWorkstations
- -- Workstations
- --- Windows10
- --- Windows7

AD DNS Zone Record Creation:
- CRL (For CRL Download)
- OCSP (For OCSP Server)
- OWA2010 (For Exchange Server1)
- OWA2010 (For Exchange Server2)
- AUTODISCOVER2010 (For Exchange Server1)
- AUTODISCOVER2010 (For Exchange Server2)
- OUTLOOK2010 (For Exchange Server1)
- OUTLOOK2010 (For Exchange Server2)
- EAS2010 (For Exchange Server1)
- EAS2010 (For Exchange Server2)
- SMTP (For Exchange Server1)
- SMTP (For Exchange Server2)

PKI
- Offline Root CA Configuaration
- Issuing CA Configuration
- OCSP Configuaration

Exchange
- File Share Witness Creation
- Exchange 2010 OS Prerequisites
- Exchange 2010 Installation
- Request/Receive Exchange 2010 SAN Certificate from Issuing CA
- Exchange 2010 Certificate Enablement
- Exchange Virtual Directory Internal/External Configuration
- Exchange Virtual Directory Authentication Configuration
- DAG Creation and Adding both Exchange Servers

Parameters that support changes
- Location2. Enter a Valid Azure Region based on which Cloud (AzureCloud, AzureUSGovernment, etc...) you are using.
- TimeZone.  Select an appropriate Time Zone.
- Exchange Org Name. Enter a name that will be used for your Exchange Organization Name.
- ExchangeSP3ISOUrl.  You must enter a URL or created SAS URL that points to an Exchange 2010 ISO for this installation to be successful.
- Admin Username.  Enter a valid Admin Username
- Admin Password.  Enter a valid Admin Password
- To Email.  Please provide a working email that the Trusted Certificate Authority Chain Can be sent to.  These certificates will allow access to Exchange Services like OWA, EAS and Outlook without Certificate Security warnings.
- WindowsServerLicenseType.  Choose Windows Server License Type (Example:  Windows_Server or None)
- WindowsClientLicenseType.  Choose Windows Client License Type (Example:  Windows_Client or None)
- Naming Convention. Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using.
- Sub DNS Domain.  OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT )
- Sub DNS BaseDN.  OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA )
- Net Bios Domain.  Enter a valid Net Bios Domain Name (Example:  killerhomelab).
- Internal Domain.  Enter a valid Internal Domain (Exmaple:  killerhomelab)
- InternalTLD.  Select a valid Top-Level Domain for your Internal Domain using the Pull-Down Menu.
- External Domain.  Enter a valid External Domain (Exmaple:  killerhomelab)
- ExternalTLD.  Select a valid Top-Level Domain for your External Domain using the Pull-Down Menu.
- Vnet1ID.  Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1)
- Vnet2ID.  Enter first 2 octets of your desired Address Space for Virtual Network 2 (Example:  10.2)
- Reverse Lookup1.  Enter first 2 octets of your desired Address Space in Reverse (Example:  1.10)
- Reverse Lookup2.  Enter first 2 octets of your desired Address Space in Reverse (Example:  2.10)
- Root CA Name.  Enter a Name for your Root Certificate Authority
- Issuing CA Name.  Enter a Name for your Issuing Certificate Authority
- RootCAHashAlgorithm.  Hash Algorithm for Offline Root CA
- RootCAKeyLength.  Key Length for Offline Root CA
- IssuingCAHashAlgorithm.  Hash Algorithm for Issuing CA
- IssuingCAKeyLength.  Key Length for Issuing CA
- DC1OSVersion.  DC1OSVersion OS Version is not configurable and set to 2016-Datacenter (Windows 2016).
- DC2OSVersion.  DC2OSVersion OS Version is not configurable and set to 2016-Datacenter (Windows 2016).
- RCAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Root CA OS Version
- ICAOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) Issuing CA OS Version
- OCSPOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) OCSP OS Version
- FSOSVersion.  Select 2016-Datacenter (Windows 2016) or 2019-Datacenter (Windows 2019) File ShareWiteness OS Version
- EXOSVersion.  Exchange Servers OS Version is not configurable and set to 2008-R2-Datacenter (Windows 2008 R2).
- WK1OSVersion.  Workstation1 OS Version is not configurable and set to 19h1-pro (Windows 10).
- WK2OSVersion.  Workstation2 OS Version is not configurable and set to 19h1-pro (Windows 10).
- DC1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- DC2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- RCAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- ICAVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- OCSPVMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- FS1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- EX1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WK1VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- FS2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- EX2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.
- WK2VMSize.  Enter a Valid VM Size based on which Region the VM is deployed.