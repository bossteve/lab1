configuration DOWNLOADEXCHANGE10
{
   param
   (
        [String]$ExchangeSP3ISOUrl

    )
    Import-DscResource -Module xStorage # Used for Mount ISO
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
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

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script DismountISO
        {
      	    SetScript = {
                Dismount-DiskImage "C:\MachineConfig\Exchange2010SP3.ISO" -ErrorAction 0
            }
            GetScript =  { @{} }
            TestScript = { $false }
        }

        File Machineconfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\MachineConfig'
            Ensure = "Present"
            DependsOn = '[Script]DismountISO'
        }

        xRemoteFile DownloadFile
        {
            DestinationPath = "C:\MachineConfig\Exchange2010SP3.ISO"
            Uri             = "$ExchangeSP3ISOUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]Machineconfig'
        }

        xMountImage MountExchangeISO
        {
            Ensure = "Present"
            ImagePath   = "C:\MachineConfig\Exchange2010SP3.ISO"
            DriveLetter = 'I'
            DependsOn = '[xRemoteFile]DownloadFile'
        }

        xWaitForVolume WaitForISO
        {
            DriveLetter      = 'I'
            RetryIntervalSec = 5
            RetryCount       = 10
        }

        File PrepareADCCopy
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "I:\"
            DestinationPath = "C:\MachineConfig\Exchange2010SP3"
            DependsOn = '[xWaitForVolume]WaitForISO'
        }
    }
}