Configuration DOWNLOADAGENT
{
   param
   (
        [String]$MigrationAgentDownloadUrl,
        [System.Management.Automation.PSCredential]$Admincreds
    )
 
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote

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
                
        File OneDriveMigrationToolFolder
        {
            Type = 'Directory'
            DestinationPath = 'C:\OneDriveMigrationTool'
            Ensure = "Present"
        }

        xRemoteFile DownloadOneDriveMigationTool
        {
            DestinationPath = 'C:\OneDriveMigrationTool\clientsetup.exe'
            Uri             = "$MigrationAgentDownloadUrl"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    "[File]OneDriveMigrationToolFolder"
        }
     }
  }