configuration EXDISKPART
{
   param
   (
        [String]$EXDiskPartUrl,
        [String]$TimeZone
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -ModuleName ComputerManagementDsc

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

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        File DiskConfig
        {
            Type = 'Directory'
            DestinationPath = 'C:\DiskConfig'
            Ensure = "Present"
        }

        xRemoteFile DiskPart
        {
            DestinationPath = "C:\DiskConfig\ExchangeDiskPart.txt"
            Uri             = $EXDiskPartUrl
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]DiskConfig"
        }

        Script ConfigureDisks
        {
            SetScript =
            {
                # Partition Volumes
                C:\Windows\System32\diskpart.exe /s C:\DiskConfig\ExchangeDiskPart.txt
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DiskPart'
        }
    }
}