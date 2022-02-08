Configuration POWERBIDESKTOP
{
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemote
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    Node localhost
    {
        File Software
        {
            Type = 'Directory'
            DestinationPath = 'C:\Software'
            Ensure = "Present"
        }

        xRemoteFile DownloadPowerBI
        {
            DestinationPath = 'C:\Software\PBIDesktopSetup_x64.exe'
            Uri             = "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    '[File]Software'
        }

        xRemoteFile DownloadPowerBINWTemplate
        {
            DestinationPath = 'C:\Software\PowerBI_FlowLogs_Storage_Template.pbit'
            Uri             = "https://aka.ms/networkwatcherpowerbiflowlogstemplate"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn =    '[File]Software'
        }

        Script InstallPowerBiDesktop
        {
            SetScript =
            {
                # Install PowerBi Desktop
                C:\Software\PBIDesktopSetup_x64.exe -quiet -norestart ACCEPT_EULA=1
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]DownloadPowerBI'
        }


        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }
     }
  }