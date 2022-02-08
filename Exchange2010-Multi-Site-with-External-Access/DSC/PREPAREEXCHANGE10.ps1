configuration PREPAREEXCHANGE10
{
   param
   (
        [String]$DCIP,        
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds
    )
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature NET-Framework
        {
            Ensure = 'Present'
            Name = 'NET-Framework'
        }

        WindowsFeature RSAT-ADDS
        {
            Ensure = 'Present'
            Name = 'RSAT-ADDS'
        }

        WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        WindowsFeature Web-Basic-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Basic-Auth'
        }

        WindowsFeature Web-Windows-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Windows-Auth'
        }

        WindowsFeature Web-Metabase
        {
            Ensure = 'Present'
            Name = 'Web-Metabase'
        }

        WindowsFeature Web-Net-Ext
        {
            Ensure = 'Present'
            Name = 'Web-Net-Ext'
        }

        WindowsFeature Web-Lgcy-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Lgcy-Mgmt-Console'
        }

        WindowsFeature WAS-Process-Model
        {
            Ensure = 'Present'
            Name = 'WAS-Process-Model'
        }

        WindowsFeature RSAT-Web-Server
        {
            Ensure = 'Present'
            Name = 'RSAT-Web-Server'
        }

        WindowsFeature Web-ISAPI-Ext
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
        }

        WindowsFeature Web-Digest-Auth
        {
            Ensure = 'Present'
            Name = 'Web-Digest-Auth'
        }

        WindowsFeature Web-WMI
        {
            Ensure = 'Present'
            Name = 'Web-WMI'
        }

        WindowsFeature Web-Asp-Net
        {
            Ensure = 'Present'
            Name = 'Web-Asp-Net'
        }

        WindowsFeature Web-ISAPI-Filter
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
        }

        WindowsFeature Web-Dyn-Compression
        {
            Ensure = 'Present'
            Name = 'Web-Dyn-Compression'
        }

        WindowsFeature NET-HTTP-Activation
        {
            Ensure = 'Present'
            Name = 'NET-HTTP-Activation'
        }

        WindowsFeature RPC-over-HTTP-proxy
        {
            Ensure = 'Present'
            Name = 'RPC-over-HTTP-proxy'
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Eastern Standard Time'
        }

        File CreateSoftwareFolder
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall'
            Ensure = "Present"
            Force = $true
        }

        File CreateExchange2010SP3
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall\Exchange2010SP3'
            Ensure = "Present"
            Force = $true
            DependsOn = '[File]CreateSoftwareFolder'
            
        }
       
        File CopyExchangeFromDC
        {
            Ensure = "Present"
            Type = "Directory"
            Recurse = $true
            SourcePath = "\\$DCIP\c$\MachineConfig\Exchange2010SP3"
            DestinationPath = "S:\ExchangeInstall\Exchange2010SP3\"
            Credential = $DomainCreds
            Force = $true
            DependsOn =  '[File]CreateExchange2010SP3'
        }
     
        xRemoteFile DownloadFilterPack2010
        {
            DestinationPath = "S:\ExchangeInstall\FilterPack64bit.exe"
            Uri             = "https://download.microsoft.com/download/0/A/2/0A28BBFA-CBFA-4C03-A739-30CCA5E21659/FilterPack64bit.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = "[File]CopyExchangeFromDC"
        }

        xRemoteFile DownloadFilterPack2010SP2
        {
            DestinationPath = "S:\ExchangeInstall\filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            Uri             = "https://download.microsoft.com/download/D/C/A/DCA32A51-6954-4814-8838-422BD3F508F8/filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            UserAgent       = "[Microsoft.PowerShell.Commands.PerSUserAgent]::InternetExplorer"
            DependsOn = "[xRemoteFile]DownloadFilterPack2010"
        }

        Package InstallFilterPack2010
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "S:\ExchangeInstall\FilterPack64bit.exe"
            Name        = "Download/Install Microsoft Office 2010 Filter Pack"
            ProductId   = "95140000-2000-0409-1000-0000000FF1CE"
            Arguments = "/passive"
            DependsOn   = '[xRemoteFile]DownloadFilterPack2010SP2'
        }

        Package InstallFilterPack2010SP2
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Path        = "S:\ExchangeInstall\filterpacksp2010-kb2687447-fullfile-x64-en-us.exe"
            Name        = "Download/Install Microsoft Office 2010 Filter Pack Service Pack 2"
            ProductId   = "95140000-2000-0409-1000-0000000FF1CE"
            Arguments = "/passive"
            DependsOn   = '[Package]InstallFilterPack2010'
        }
    }
}