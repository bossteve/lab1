configuration PREPAREADEXCHANGE10
{
   param
   (
        [String]$ExchangeOrgName,
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds

    )
    Import-DscResource -Module xStorage # Used for Mount ISO
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)    
    
    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature NET-Framework-Core
        {
            Ensure = 'Present'
            Name = 'NET-Framework-Core'
        }

        Script PrepareExchange2010
        {
            SetScript =
            {
                (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP }
                                
                C:\MachineConfig\Exchange2010SP3\Setup.com /PrepareSchema
                C:\MachineConfig\Exchange2010SP3\Setup.com /PrepareAD /on:"$using:ExchangeOrgName"

                (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }

    }
}