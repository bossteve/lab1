Configuration ASR
{
   param
   (
        [String]$ComputerName,
        [String]$AzureEnvironment,
        [String]$ResourceGroupName,
        [String]$NamingConvention,
        [String]$VaultName,
        [String]$HyperVSite,
        [String]$StorageAccountName,
        [String]$Location,                                       
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile   
    Import-DscResource -Module xPendingReboot # Used for Reboots

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Registry SchUseStrongCrypto
        {
            Key                         = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        Registry SchUseStrongCrypto64
        {
            Key                         = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        File CreateASRFolder
        {
            Type = 'Directory'
            DestinationPath = 'C:\ASR'
            Ensure = "Present"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64'
        }

        File CreateVMFolder
        {
            Type = 'Directory'
            DestinationPath = 'V:\VMs'
            Ensure = "Present"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64'
        }
        
        xRemoteFile DownloadASRProvider
        {
            DestinationPath = "C:\ASR\AzureSiteRecoveryProvider.exe"
            Uri             = "http://aka.ms/downloaddra_ugv"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateASRFolder'
        }

        xRemoteFile Win10Download
        {
            DestinationPath = "C:\ASR\WinDev2106Eval.HyperVGen1.zip"
            Uri             = "https://aka.ms/windev_VM_hyperv"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]DownloadASRProvider'
        }

        Script CreateWin10VM
        {
            SetScript =
            {
                # UnCompress Win10
                $VMs = Get-Item -Path "V:\WinDev2106Eval.HyperVGen1" -ErrorAction 0
                IF ($VMs -eq $Null) {
                Expand-Archive -Path "C:\ASR\WinDev2106Eval.HyperVGen1.zip" -DestinationPath "V:\" -Force
                $VMFile = Get-ChildItem -Path "V:\Virtual Machines\" | Where-Object {$_.Name -like '*vmcx'}
                $VMFileName = $VMFile.Name
                Import-VM -Path "V:\Virtual Machines\$VMFileName"
                Start-VM -Name WinDev2106Eval
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]Win10Download'
        }

        Script InstallAzModule
        {
            SetScript =
            {
                # Install Azure PowerShell
                $NuGetCheck = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
                IF ($NuGetCheck -eq $Null) {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
                $AzModCheck = Get-Module -Name Az -ErrorAction SilentlyContinue
                IF ($AzModCheck -eq $Null) {Install-Module Az -Force}
                IF ($AzModCheck -eq $Null) {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force}
                IF ($AzModCheck -eq $Null) {Import-Module Az}                
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $Admincreds
        }

        Script ConfigureASR
        {
            SetScript =
            {                 
                $CertCheck = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=Windows Azure Tools"}
                IF ($CertCheck -eq $Null){
                $dt = $(Get-Date).ToString("M-d-yyyy")
                $cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -FriendlyName "$using:HyperVSite" -subject "Windows Azure Tools" -KeyExportPolicy Exportable -NotAfter $(Get-Date).AddHours(48) -NotBefore $(Get-Date).AddHours(-24) -KeyProtection None -KeyUsage None -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") -Provider "Microsoft Enhanced Cryptographic Provider v1.0"
                $certificate = [convert]::ToBase64String($cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx))
                }
                ELSE {
                $certificate = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=Windows Azure Tools"}).Thumbprint
                }
                Connect-AzAccount -Environment "$using:AzureEnvironment" -Identity
                
                # Get Vault
                $Vault = Get-AzRecoveryServicesVault -Name "$using:VaultName"
                Set-AzRecoveryServicesAsrVaultContext -Vault $Vault
                
                # Create Hyper-V Site
                $FabricCheck = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite" -ErrorAction SilentlyContinue
                IF ($FabricCheck -eq $Null) {New-AzRecoveryServicesAsrFabric -Type HyperVSite -Name "$using:HyperVSite"}

                # Generate and Download Registration Key
                $SiteIdentifier = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite" | Select-Object -ExpandProperty SiteIdentifier
                $path = Get-AzRecoveryServicesVaultSettingsFile -Vault $Vault -SiteIdentifier $SiteIdentifier -SiteFriendlyName "$using:HyperVSite" -Certificate $certificate

                # Add Hyper-V Server
                $server = Get-AzRecoveryServicesAsrFabric -Name "$using:HyperVSite" | Get-AzRecoveryServicesAsrServicesProvider -FriendlyName "$using:ComputerName"

                # Extract ASR Provider
                $ExtractPath = "C:\ASR\AzureSiteRecoveryProvider.exe"
                & $ExtractPath '/x:C:\ASR\AzureSiteProvider' /q

                # Silent Install
                $InstallPath = "C:\ASR\AzureSiteProvider\setupdr.exe"
                & $InstallPath /i
                
                $ConfigPath = "C:\Program Files\Microsoft Azure Site Recovery Provider\DRConfigurator.exe"
                & $ConfigPath /r /Friendlyname "$using:ComputerName" /Credentials $path.FilePath

                # Create Replication Policy
                $ReplicationFrequencyInSeconds = "300";        #options are 30,300,900
                $PolicyName = “replicapolicy”
                $Recoverypoints = 6                    #specify the number of recovery points

                $StorageAccountCheck = Get-AzStorageAccount -Name "$using:StorageAccountName" -ResourceGroupName "$using:ResourceGroupName" -ErrorAction 0
                IF ($StorageAccountCheck -eq $null) {
                $StorageAccount = New-AzStorageAccount -Name "$using:StorageAccountName" -ResourceGroupName "$using:ResourceGroupName" -SkuName Standard_LRS -Location $Location
                $storageaccountID = $StorageAccount.Id
                }
                ELSE {
                $storageaccountID = Get-AzStorageAccount -Name "$using:StorageAccountName" -ResourceGroupName "$using:ResourceGroupName" | Select-Object -ExpandProperty Id
                }

                $PolicyResult = New-AzRecoveryServicesAsrPolicy -Name $PolicyName -ReplicationProvider “HyperVReplicaAzure” -ReplicationFrequencyInSeconds $ReplicationFrequencyInSeconds -NumberOfRecoveryPointsToRetain $Recoverypoints -ApplicationConsistentSnapshotFrequencyInHours 1 -RecoveryAzureStorageAccountId $storageaccountID

                $Fabric = Get-AzRecoveryServicesAsrFabric -Name "$HyperVSite"
                $protectionContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $Fabric

                $Policy = Get-AzRecoveryServicesAsrPolicy -FriendlyName $PolicyName
                New-AzRecoveryServicesAsrProtectionContainerMapping -Name "OnPrem-to-Azure" -Policy $Policy -PrimaryProtectionContainer $protectionContainer[0]
                $associationJob = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name "OnPrem-to-Azure" -ProtectionContainer $protectionContainer[0]

                while (($associationJob.State -ne 'Paired')){
                $associationJob = Get-AzRecoveryServicesAsrProtectionContainerMapping -Name "OnPrem-to-Azure" -ProtectionContainer $protectionContainer[0]
                Start-Sleep 60}

                $ProtectionContainerMapping = Get-AzRecoveryServicesAsrProtectionContainerMapping -ProtectionContainer $protectionContainer

                $VMFriendlyName = "WinDev2106Eval"          #Name of the VM
                $OSDisk = "$VMFriendlyName"+"_OSDisk"
                $ProtectableItem = Get-AzRecoveryServicesAsrProtectableItem -ProtectionContainer $protectionContainer -FriendlyName $VMFriendlyName

                $OSType = "Windows"          # "Windows" or "Linux"
                $VM = Get-VM -Name WinDev2106Eval
                $ResourceGroup = Get-AzResourceGroup -Name "$using:ResourceGroupName"
                $DRjob = New-AzRecoveryServicesAsrReplicationProtectedItem -ProtectableItem $ProtectableItem -Name $ProtectableItem.Name -ProtectionContainerMapping $ProtectionContainerMapping -HyperVToAzure -UseManagedDisk True -RecoveryResourceGroupId $ResourceGroup.ResourceId -RecoveryAzureStorageAccountId $storageaccountID -OSDiskName $OSDisk -OS Windows

                while (($DRjob.ProtectionState -ne 'Paired')){
                $DRjob = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $protectionContainer[0]
                Start-Sleep 60}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[Script]InstallAzModule'
            PsDscRunAsCredential = $Admincreds
        }

        xPendingReboot AfterRoleInstallation
        {
            Name       = 'AfterRoleInstallation'
        }

     }
  }