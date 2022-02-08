configuration EXCHANGE10
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DBName,
        [String]$SetupDC,
        [System.Management.Automation.PSCredential]$Admincreds
    )

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script InstallExchange2010
        {
            SetScript =
            {
                $Install = Get-ChildItem -Path S:\ExchangeInstall\DeployExchange.cmd -ErrorAction 0
                IF ($Install -eq $null) {
                Set-Content -Path S:\ExchangeInstall\DeployExchange.cmd -Value "S:\ExchangeInstall\Exchange2010SP3\Setup.com /roles:mb,ca,ht /mdbname:$using:DBName /dbfilepath:M:\$using:DBName\$using:DBName.edb /logfolderpath:M:\$using:DBName /dc:$using:SetupDC"
                S:\ExchangeInstall\DeployExchange.cmd
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
        }
    }
}