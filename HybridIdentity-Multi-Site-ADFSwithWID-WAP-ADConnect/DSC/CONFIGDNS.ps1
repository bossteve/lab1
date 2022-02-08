configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$RootDomainFQDN,
        [String]$ADFSServer1IP,
        [String]$ADFSServer2IP
    )

    Import-DscResource -Module xDnsServer

    Node localhost
    {
        xDnsServerADZone PrimaryADZone1
        {
            Name             = $RootDomainFQDN
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
        }

        xDnsRecord adfsrecord1
        {
            Name      = "adfs"
            Zone      = $RootDomainFQDN
            Target    = $ADFSServer1IP
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]PrimaryADZone1'
        }

        xDnsRecord adfsrecord2
        {
            Name      = "adfs"
            Zone      = $RootDomainFQDN
            Target    = $ADFSServer2IP
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]PrimaryADZone1'
        }

    }
}