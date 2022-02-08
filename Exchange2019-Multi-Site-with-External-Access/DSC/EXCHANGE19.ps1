configuration EXCHANGE19
{
   param
   (
        [String]$NetBiosDomain,
        [String]$DBName,
        [String]$SetupDC,
        [System.Management.Automation.PSCredential]$Admincreds
    )

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
                Dismount-DiskImage "S:\ExchangeInstall\Exchange2019.iso" -ErrorAction 0
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
            ImagePath   = 'S:\ExchangeInstall\Exchange2019.iso'
            DriveLetter = 'L'
        }

        xWaitForVolume WaitForISO
        {
            DriveLetter      = 'L'
            RetryIntervalSec = 5
            RetryCount       = 10
        }


        Script InstallExchange2019
        {
            SetScript =
            {
                $Install = Get-ChildItem -Path S:\ExchangeInstall\DeployExchange.cmd -ErrorAction 0
                IF ($Install -eq $null) {                 
                Set-Content -Path S:\ExchangeInstall\DeployExchange.cmd -Value "L:\Setup.exe /Iacceptexchangeserverlicenseterms /Mode:Install /Role:Mailbox /DbFilePath:M:\$using:DBName\$using:DBName.edb /LogFolderPath:M:\$using:DBName /MdbName:$using:DBName /dc:$using:SetupDC"
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