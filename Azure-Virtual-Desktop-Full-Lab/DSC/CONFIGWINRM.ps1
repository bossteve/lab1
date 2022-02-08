Configuration CONFIGWINRM
{
   param
   (
        [String]$TimeZone,        
        [String]$MaxEnvelopeSizeinKB
    )

    Import-DscResource -Module ComputerManagementDsc

    Node LocalHost
    {

        Script UpdateWinRMSettings
        {
            SetScript =
            {
                # Set WinRM MaxEnvelopeSize
                Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value $using:MaxEnvelopeSizeinKB
            }
            GetScript =  { @{} }
            TestScript = { $false}
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }
    }
}