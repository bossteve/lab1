# Windows Virtual Desktop
<img src="../x_Images/AzureVirtualDesktopFull.png" alt="Azure Virtual Desktop" width="150">
Click the button below to deploy

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Virtual-Desktop-WVD-Only%2Fazuredeploy.json)
[![Deploy To Azure US Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Felliottfieldsjr%2FKillerHomeLab%2Fmaster%2FDeployments%2FAzure-Virtual-Desktop-WVD-Only%2Fazuregovdeploy.json)

This Template IS MEANT TO BE USED AS AN ADD-ON to the following labs which must already be deployed:
**** THE PARAMETERS SPECIFIED FOR THIS ADD-ON LAB MUST MATCH THE PARAMETERS OF THE BASE LAB THAT IT WILL BE ADDED TO ****

- 1-Forest_1-DomainController_1-Workstation
- 1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- 1-Forest_Parent-Child-Domain_1-Workstation
- Exchange2010-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2013-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2016-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- Exchange2019-with-External-Access-1-Forest_2-DomainControllers_2-ADSites_2-Workstations
- PKI_2-Tier_CA_With_OCSP_1-Workstation
- PKI_Enterprise_CA_With_OCSP_1-Workstation
- SQL2019-AlwaysOn-Multi-NIC
- SQL2019-AlwaysOn-Single-NIC

!!!NOTE1:  THIS LAB REQUIRES THAT AN AZURE AD GROUP BE CREATED PRIOR TO DEPLOYMENT.  THE OBJECT ID MUST BE PROVIDED WITHIN THE PARAMETERS FOR THE DEPLOYMENT TO SUCCEED. ONCE DEPLOYMENT IS COMPLETE AZURE AD CONNECT CAN BE USED TO SYNC ONPREM ACCOUNT(S)/GROUP(S) THAT CAN BE NESTED WITHIN THE PRE-CREATED AZURE AD GROUP. 

!!!NOTE2:  Please confirm the following procedures outlined in the article below have been performed in order to access the WVD Environment

https://docs.microsoft.com/en-us/azure/virtual-desktop/virtual-desktop-fall-2019/tenant-setup-azure-active-directory#:~:text=To%20grant%20the%20service%20permissions%3A%201%20Open%20a,Virtual%20Desktop%20client%20app.%20...%20More%20items...%20

This Templates deploys a Single Forest/Domain:

- 1 - Windows Virtual Desktop Pool
- 1 - Windows Virtual Desktop Application Group
- 1 - Windows Virtual Desktop Workspace
- X - Session Hosts Based on desired count

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
- HostPoolType.  Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to false.
- personalDesktopAssignmentType.  
- maxSessionLimit.  Maximum number of sessions.
- loadBalancerType.  Type of load balancer algorithm.
- validationEnvironment.  Whether to use validation enviroment.
- vmGalleryImageSKU.  The VM Image Type.
- vmSize.  WVD VMSize.
- vmDiskType.  The VM disk type for the VM: HDD or SSD.
- vmnumberofInstances.  Enter the number of WVD Session Hosts.
- vmInitialNumber.  VM name prefix initial number.
- availabilitySetUpdateDomainCount.  The platform update domain count of avaiability set to be created.
- availabilitySetFaultDomainCount.  
- PrincipalID.  Enter the Object ID of the Azure AD Group you were instructed to create in the ReadMe.
- WVDTokenPhrase.  Enter a PassPhrase that will be used to generate the Hosted Pool Registration Key.