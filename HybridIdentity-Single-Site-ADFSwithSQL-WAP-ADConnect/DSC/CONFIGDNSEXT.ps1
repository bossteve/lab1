configuration CONFIGDNSEXT
{
   param
   (
        [String]$computerName,
        [String]$ExternalDomainName,
        [String]$ADFSServer1IP
    )

    Import-DscResource -ModuleName DnsServerDsc

    Node localhost
    {
        DnsRecordA adfsrecord1
        {
            Name      = "adfs"
            ZoneName  = "$ExternaldomainName"
            IPv4Address = $ADFSServer1IP
            Ensure    = 'Present'
        }
    }
}