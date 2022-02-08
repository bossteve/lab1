configuration GRANTETS
{
   param
   (
        [String]$NetBiosDomain
    )

    Node localhost
    {
        Script IssueCARequest
        {
            SetScript =
            {
                Add-LocalGroupMember -Member "$NetBiosDomain\Exchange Trusted Subsystem" -Group Administrators
                Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}