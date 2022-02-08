configuration CONFIGDNSPROXY
{
   param
   (
        [String]$computerName,
        [String]$computerIP,
        [String]$TimeZone,    
        [String]$AKSDNSZone,                               
        [String]$InternalDomainName,
        [String]$DC1IP,                                       
        [String]$LocalDNSDomain,                               
        [String]$ReverseLookup,
        [String]$dnslastoctet
    )

    Import-DscResource -Module xDnsServer
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -ModuleName xPendingReboot

    Node localhost
    {
        Script SetPrimaryDNSSuffix
        {
            SetScript =
            {
                $domain = get-itemproperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ -Name "Domain" -ErrorAction 0
                $nvdomain = get-itemproperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ -Name "NV Domain" -ErrorAction 0

                IF ($domain -eq $null) {Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name Domain -Value "$using:LocalDNSDomain"}
                IF ($nvdomain -eq $null) {Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "NV Domain" -Value "$using:LocalDNSDomain"}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        WindowsFeature DNS
        {
            Ensure = "Present"
            Name = "DNS"
        }

        WindowsFeature DnsTools
        {
            Ensure = "Present"
            Name = "RSAT-DNS-Server"
            DependsOn = "[WindowsFeature]DNS"
        }

        xDnsServerPrimaryZone DNSLOCAL
        {
            Name             = $LocalDNSDomain
            Ensure           = 'Present'
        }

        xDnsRecord DNSPROXY
        {
            Name      = $computerName
            Zone      = $LocalDNSDomain
            Target    = $computerIP
            Type      = 'ARecord'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerPrimaryZone]DNSLOCAL'
        }

        xDnsServerPrimaryZone ReverseLookupZone
        {
            Name             = "$ReverseLookup.in-addr.arpa"
            Ensure           = 'Present'
        }

        xDnsRecord DNSPtrRecord
        {
            Name      = "$dnslastoctet"
            Zone      = "$ReverseLookup.in-addr.arpa"
            Target    = "$computerName.$LocalDNSDomain"
            Type      = 'Ptr'
            Ensure    = 'Present'
            DependsOn = '[xDnsServerPrimaryZone]ReverseLookupZone', '[xDnsRecord]DNSPROXY'
        }

        xDnsServerConditionalForwarder AKSDnsZone
        {
            Name      = $AKSDNSZone
            MasterServers = "168.63.129.16"
            Ensure    = 'Present'
        }

        xDnsServerConditionalForwarder InternalDomainName
        {
            Name      = $InternalDomainName
            MasterServers = $DC1IP
            Ensure    = 'Present'
        }

        xPendingReboot RebootAfterPrimaryDNSSuffix
        {
            Name = "RebootAfterPrimaryDNSSuffix"
        }
    }
}