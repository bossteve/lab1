configuration CONFIGEXCHANGE13
{
   param
   (
        [String]$ComputerName,
        [String]$InternaldomainName,
        [String]$ExternaldomainName,                                
        [String]$NetBiosDomain,
        [String]$BaseDN,
        [String]$Site1DC,
        [String]$Site2DC,
        [String]$ConfigDC,
        [String]$CAServerIP,
        [String]$Site,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        File Certificates
        {
            Type = 'Directory'
            DestinationPath = 'C:\Certificates'
            Ensure = "Present"
        }

        Script ConfigureCertificate
        {
            SetScript =
            {
                # Create Credentials
                $Load = "$using:DomainCreds"
                $Password = $DomainCreds.Password

                # Get Certificate 2013 Certificate
                $CertCheck = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2013.$using:ExternaldomainName"}
                IF ($CertCheck -eq $Null) {Get-Certificate -Template WebServer1 -SubjectName "CN=owa2013.$using:ExternaldomainName" -DNSName "owa2013.$using:ExternaldomainName","autodiscover.$using:ExternaldomainName","autodiscover2013.$using:ExternaldomainName","outlook2013.$using:ExternaldomainName","eas2013.$using:ExternaldomainName" -CertStoreLocation "cert:\LocalMachine\My"}

                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2013.$using:ExternaldomainName"}).Thumbprint
                (Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint).FriendlyName = "Exchange 2013 SAN Cert"

                # Export Service Communication Certificate
                $CertFile = Get-ChildItem -Path "C:\Certificates\owa2013.$using:ExternaldomainName.pfx" -ErrorAction 0
                IF ($CertFile -eq $Null) {Get-ChildItem -Path cert:\LocalMachine\my\$thumbprint | Export-PfxCertificate -FilePath "C:\Certificates\owa2013.$using:ExternaldomainName.pfx" -Password $Password}

                # Share Certificate
                $CertShare = Get-SmbShare -Name Certificates -ErrorAction 0
                IF ($CertShare -eq $Null) {New-SmbShare -Name Certificates -Path C:\Certificates -FullAccess Administrators}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]Certificates'
        }

        Script ConfigureExchange2013
        {
            SetScript =
            {
                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"

                # Get Certificate 2013 Certificate
                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2013.$using:ExternaldomainName"}).Thumbprint
                
                # Connect to Exchange
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computerName.$using:InternalDomainName/PowerShell/"
                Import-PSSession $Session

                # Set Virtual Directories
                # Set AUTODISCOVER Virtual Directory
                Set-ClientAccessServer "$using:computerName" –AutodiscoverServiceInternalUri "https://autodiscover2013.$using:ExternaldomainName/Autodiscover/Autodiscover.xml"
                
                # Set OWA Virtual Directory"
                Set-OWAVirtualDirectory –Identity "$using:computerName\owa (Default Web Site)" –InternalURL "https://owa2013.$using:ExternaldomainName/OWA" -ExternalURL "https://owa2013.$using:ExternaldomainName/OWA" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True

                # Set ECP Virtual Directory
                Set-ECPVirtualDirectory –Identity "$using:computerName\ecp (Default Web Site)" –InternalURL "https://owa2013.$using:ExternaldomainName/ECP" -ExternalURL "https://owa2013.$using:ExternaldomainName/ECP" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True

                # Set OAB Virtual Directory
                Set-OABVirtualDirectory –Identity "$using:computerName\oab (Default Web Site)" –InternalURL "https://outlook2013.$using:ExternaldomainName/OAB" -ExternalURL "https://outlook2013.$using:ExternaldomainName/OAB"
                
                # Set MRS PROXY Virtual Directory"
                Set-WebServicesVirtualDirectory –Identity "$using:computerName\EWS (Default Web Site)" –MRSProxyEnabled:$True
                Set-WebServicesVirtualDirectory –Identity "$using:computerName\EWS (Default Web Site)" –InternalURL "https://outlook2013.$using:ExternaldomainName/EWS/Exchange.asmx" -ExternalURL "https://outlook2013.$using:ExternaldomainName/EWS/Exchange.asmx"

                # Set ACTIVESYNC Virtual Directory
                Set-ActiveSyncVirtualDirectory –Identity "$using:computerName\Microsoft-Server-ActiveSync (Default Web Site)" –InternalURL "https://eas2013.$using:ExternaldomainName/Microsoft-Server-ActiveSync" -ExternalURL "https://eas2013.$using:ExternaldomainName/Microsoft-Server-ActiveSync"

                # Set MAPI Virtual Directory
                Set-MapiVirtualDirectory –Identity "$using:computerName\mapi (Default Web Site)" –InternalURL "https://outlook2013.$using:ExternaldomainName/MAPI" -ExternalURL "https://outlook2013.$using:ExternaldomainName/MAPI" -IISAuthenticationMethods Ntlm,OAuth,Negotiate

                # Enable Exchange 2013 Certificate
                Enable-ExchangeCertificate -Thumbprint $thumbprint -Services IIS -Confirm:$False

                # Create Connectors
                $LocalRelayRecieveConnector = Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" -ErrorAction 0
                IF ($LocalRelayRecieveConnector -eq $Null) {
                New-ReceiveConnector "LocalRelay $using:computerName" -Custom -Bindings 0.0.0.0:25 -RemoteIpRanges "$using:CAServerIP" -DomainController "$using:ConfigDC" -TransportRole FrontendTransport
                Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" | Add-ADPermission -User "NT AUTHORITY\ANONYMOUS LOGON" -ExtendedRights "Ms-Exch-SMTP-Accept-Any-Recipient" -ErrorAction 0
                Set-ReceiveConnector "LocalRelay $using:computerName" -AuthMechanism ExternalAuthoritative -PermissionGroups ExchangeServer
                }

                $InternetSendConnector = Get-SendConnector "$using:Site Internet" -ErrorAction 0
                IF ($InternetSendConnector -eq $Null) {
                New-SendConnector "$using:Site Internet" -AddressSpaces * -SourceTransportServers "$using:computerName"

                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[Script]ConfigureCertificate'
        }

        Script ConfigureExchangeSecurityandPerformance
        {
            SetScript =
            {
                # Set PageFile to Manual
                $pagefileset = Get-WmiObject Win32_pagefilesetting
                $pagefileset.InitialSize = 8192
                $pagefileset.MaximumSize = 32778
                $pagefileset.Put() | Out-Null
            
                # Disable SMB1
                Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
                Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

                # Set TCP Keep Alive
                $tcpkeepalive = get-itemproperty -Path "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters" -Name "KeepAliveTime" -ErrorAction 0
                IF ($tcpkeepalive -eq $null) {New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters\" -Name "KeepAliveTime" -Value 1800000}
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[Script]ConfigureExchange2013'
        }
    }
}