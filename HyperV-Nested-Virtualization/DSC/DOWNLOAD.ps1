Configuration DOWNLOAD
{
   param
   (
    )

    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile   

    Node localhost
    {
        File CreateASRFolder
        {
            Type = 'Directory'
            DestinationPath = 'C:\ASR'
            Ensure = "Present"
            DependsOn = '[Registry]SchUseStrongCrypto', '[Registry]SchUseStrongCrypto64'
        }

        xRemoteFile DownloadASRProvider
        {
            DestinationPath = "C:\ASR\AzureSiteRecoveryProvider.exe"
            Uri             = "http://aka.ms/downloaddra_ugv"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateASRFolder'
        }

        xRemoteFile Win10Download
        {
            DestinationPath = "C:\ASR\WinDev2016Eval.HyperVGen1.zip"
            Uri             = "https://aka.ms/windev_VM_hyperv"
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[xRemoteFile]DownloadASRProvider'
        }

        Script CreateWin10VM
        {
            SetScript =
            {
                # UnCompress Win10
                $VMs = Get-Item -Path "C:\ASR\WinDev2016Eval.HyperVGen1" -ErrorAction 0
                IF ($VMs -eq $Null) {
                Expand-Archive -Path "C:\ASR\WinDev2016Eval.HyperVGen1.zip" -DestinationPath "V:\" -Force
                $VMFile = Get-ChildItem -Path "C:\ASR\" | Where-Object {$_.Name -like '*vmcx'}
                $VMFileName = $VMFile.Name
                Import-VM -Path "C:\ASR\$VMFileName"
                Start-VM -Name WinDev2016Eval
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[xRemoteFile]Win10Download'
        }

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }
     }
  }