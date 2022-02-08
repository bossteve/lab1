configuration CONFIGEXCHANGE10
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
        [String]$IssuingCAServer,
        [String]$IssuingCAName,
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

        Script ConfigureExchange2010
        {
            SetScript =
            {
                repadmin /replicate "$using:Site1DC" "$using:Site2DC" "$using:BaseDN"
                repadmin /replicate "$using:Site2DC" "$using:Site1DC" "$using:BaseDN"

                $fqdn = "$using:ExternalDomainName"
                $CN = '"CN'
                $DNS = '"DNS'
                $quote = '"'
                $windowsNT = '"$Windows NT"'

                # Create Exchange Request Policy File
                $file = Get-Item -Path "S:\ExchangeInstall\GetCertificate.inf" -ErrorAction 0
                IF ($file -eq $Null){
                Set-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "[Version]"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "Signature=$WindowsNT"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "[NewRequest]"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "Subject = $CN=owa2010.$fqdn$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "KeyLength = 2048"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "KeySpec = 1"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "KeyUsage = 0xA0"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "MachineKeySet = True"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value 'ProviderName = "Microsoft RSA SChannel Cryptographic Provider"'
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "RequestType = PKCS10"

                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value '[EnhancedKeyUsageExtension]'
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value 'OID=1.3.6.1.5.5.7.3.1'
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value 'OID=1.3.6.1.5.5.7.3.2'

                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value '[Extensions]'
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "2.5.29.17 = $quote{text}$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "_continue_ = $DNS=owa2010.$fqdn&$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "_continue_ = $DNS=autodiscover.$fqdn&$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "_continue_ = $DNS=autodiscover2010.$fqdn&$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "_continue_ = $DNS=eas2010.$fqdn&$quote"
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value "_continue_ = $DNS=outlook2010.$fqdn&$quote"

                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value '[RequestAttributes]'
                Add-Content -Path S:\ExchangeInstall\GetCertificate.inf -Value 'CertificateTemplate = WebServer1'
                
                certreq -new S:\ExchangeInstall\GetCertificate.inf S:\ExchangeInstall\Request.req
                certreq -submit -config "$using:IssuingCAServer\$using:IssuingCAName" S:\ExchangeInstall\Request.req S:\ExchangeInstall\Response.cer
                certreq -accept S:\ExchangeInstall\Response.cer
                }

                # Get Exchange 2010 Certificate
                $thumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Subject -like "CN=owa2010.$using:ExternalDomainName"}).Thumbprint
                (Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint).FriendlyName = "Exchange 2010 SAN Cert"

                # Set Virtual Directories
                $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$using:computername.$using:InternalDomainName/PowerShell/"
                Import-PSSession $Session
                Set-ClientAccessServer "$using:computername" –AutodiscoverServiceInternalUri "https://autodiscover2010.$using:ExternalDomainName/Autodiscover/Autodiscover.xml"
                Set-OWAVirtualDirectory –Identity "$using:computername\owa (Default Web Site)" –InternalURL "https://owa2010.$using:ExternalDomainName/OWA" -ExternalURL "https://owa2010.$using:ExternalDomainName/OWA" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True
                Set-ECPVirtualDirectory –Identity "$using:computername\ecp (Default Web Site)" –InternalURL "https://owa2010.$using:ExternalDomainName/ECP" -ExternalURL "https://owa2010.$using:ExternalDomainName/ECP" -ExternalAuthenticationMethods NTLM -FormsAuthentication:$False -BasicAuthentication:$False –WindowsAuthentication:$True
                Set-OABVirtualDirectory –Identity "$using:computername\oab (Default Web Site)" –InternalURL "https://outlook2010.$using:ExternalDomainName/OAB" -ExternalURL "https://outlook2010.$using:ExternalDomainName/OAB"
                Set-WebServicesVirtualDirectory –Identity "$using:computername\EWS (Default Web Site)" –MRSProxyEnabled:$True
                Set-ActiveSyncVirtualDirectory –Identity "$using:computername\Microsoft-Server-ActiveSync (Default Web Site)" –InternalURL "https://eas2010.$using:ExternalDomainName/Microsoft-Server-ActiveSync" -ExternalURL "https://eas2010.$using:ExternalDomainName/Microsoft-Server-ActiveSync"
                Set-WebServicesVirtualDirectory –Identity "$using:computername\EWS (Default Web Site)" –InternalURL "https://outlook2010.$using:ExternalDomainName/EWS/Exchange.asmx" -ExternalURL "https://outlook2010.$using:ExternalDomainName/EWS/Exchange.asmx"

                # Enable Exchange 2010 Certificate
                Enable-ExchangeCertificate -Thumbprint $thumbprint -Services IIS -Confirm:$False

                # Create Connectors
                $LocalRelayRecieveConnector = Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" -ErrorAction 0
                IF ($LocalRelayRecieveConnector -eq $Null) {
                New-ReceiveConnector "LocalRelay $using:computerName" -Custom -Bindings 0.0.0.0:25 -RemoteIpRanges "$using:CAServerIP" -DomainController "$using:ConfigDC"
                Get-ReceiveConnector "LocalRelay $using:computerName" -DomainController "$using:ConfigDC" | Add-ADPermission -User "NT AUTHORITY\ANONYMOUS LOGON" -ExtendedRights "Ms-Exch-SMTP-Accept-Any-Recipient" -ErrorAction 0
                Set-ReceiveConnector "LocalRelay $using:computerName" -AuthMechanism ExternalAuthoritative -PermissionGroups ExchangeServers
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
        }
    }
}