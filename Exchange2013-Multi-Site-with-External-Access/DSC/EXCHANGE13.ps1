configuration EXCHANGE13
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DBName,
        [String]$SetupDC,
        [System.Management.Automation.PSCredential]$Admincreds
    )
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile
    Import-DscResource -Module ComputerManagementDsc # Used for TimeZone
    Import-DscResource -Module xStorage # Used by Disk

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        Script DismountISO
        {
      	    SetScript = {
                Dismount-DiskImage "S:\ExchangeInstall\Exchange2013.iso" -ErrorAction 0
            }
            GetScript =  { @{} }
            TestScript = { $false }
        }

        File ExchangeInstall
        {
            Type = 'Directory'
            DestinationPath = 'S:\ExchangeInstall'
            Ensure = "Present"
        }

        xMountImage MountExchangeISO
        {
            ImagePath   = 'S:\ExchangeInstall\Exchange2013.iso'
            DriveLetter = 'K'
        }

        xWaitForVolume WaitForISO
        {
            DriveLetter      = 'K'
            RetryIntervalSec = 5
            RetryCount       = 10
        }

        Script InstallExchange2013
        {
            SetScript =
            {
                $Install = Get-ChildItem -Path S:\ExchangeInstall\DeployExchange.cmd -ErrorAction 0
                IF ($Install -eq $null) {                
                Set-Content -Path S:\ExchangeInstall\DeployExchange.cmd -Value "K:\Setup.exe /Iacceptexchangeserverlicenseterms /Mode:Install /Role:MB,CA,MT /DbFilePath:M:\$using:DBName\$using:DBName.edb /LogFolderPath:M:\$using:DBName /MdbName:$using:DBName /dc:$using:SetupDC"
                S:\ExchangeInstall\DeployExchange.cmd
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            PsDscRunAsCredential = $DomainCreds
            DependsOn = '[xWaitForVolume]WaitForISO'
        }

    }
}