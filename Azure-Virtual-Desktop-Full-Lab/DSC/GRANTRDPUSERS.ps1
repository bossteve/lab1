configuration GRANTRDPUSERS
{
   param
   (
        [String]$TimeZone,        
        [String]$Account,
        [String]$NetBiosDomain
    )

    Import-DscResource -ModuleName ComputerManagementDsc

    Node localhost
    {
        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        Script GrantRemoteDesktopUsers
        {
            SetScript =
            {
                $AccountCheck = Get-LocalGroupMember -Group "Remote Desktop Users" -Member "$using:NetBiosDomain\$Using:Account" -ErrorAction 0
                IF ($AccountCheck -eq $null){Add-LocalGroupMember -Member "$using:NetBiosDomain\$Using:Account" -Group "Remote Desktop Users"}
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

    }
}