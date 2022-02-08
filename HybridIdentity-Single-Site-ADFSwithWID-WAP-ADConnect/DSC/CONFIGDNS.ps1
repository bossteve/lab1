configuration CONFIGDNS
{
   param
   (
        [String]$computerName,
        [String]$ExternalDomainName,
        [String]$ADFSServer1IP
    )

    Import-DscResource -Module xDnsServer

    Node localhost
    {
        xDnsServerADZone PrimaryADZone1
        {
            Name             = $ExternalDomainName
            DynamicUpdate = 'Secure'
            Ensure           = 'Present'
            ReplicationScope = 'Domain'
        }

        xDnsRecord adfsrecord
        {
            Name      = "adfs"
            Zone      = $ExternalDomainName
            Target    = $ADFSServer1IP
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerADZone]PrimaryADZone1'
        }
    }
}