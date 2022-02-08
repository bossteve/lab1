Configuration CREATEUSERFOLDERS
{
   param
   (
        [String]$UserCount,
        [String]$NamingConvention,     
        [String]$UserDataUrl,
        [String]$NetBiosDomain,   
        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -Module xStorage
    Import-DscResource -Module xPSDesiredStateConfiguration # Used for xRemoteFile

    Node $AllNodes.NodeName

{
        xWaitforDisk Disk2
        {
            DiskID = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        xDisk ADDataDisk {
            DiskID = 2
            DriveLetter = "H"
            DependsOn = "[xWaitForDisk]Disk2"
        }

        File CreateDataFolder
        {
            Type = 'Directory'
            DestinationPath = "H:\Data"
            Ensure = "Present"
            DependsOn = '[xDisk]ADDataDisk'
        }

        File CreateUsersHomeDrivesFolder
        {
            Type = 'Directory'
            DestinationPath = "H:\HomeDrives"
            Ensure = "Present"
            DependsOn = '[xDisk]ADDataDisk'
        }

        Script ConfigureUserFolderPermissions
        {
            SetScript =
            {
                # Create Parent Share
                $HomeDriveShare = Get-SmbShare -Name "HomeDrives" -ErrorAction 0
                IF ($HomeDriveShare -eq $Null) {
                New-SmbShare -Name "HomeDrives" -Path "H:\HomeDrives" -FullAccess "Domain Users"
                
                # Disable Inheritance & Remove Existing Permissions
                $acl = Get-ACL -Path "H:\HomeDrives"
                $acl.SetAccessRuleProtection($True, $False)
                $acl.Access | %{$acl.RemoveAccessRule($_)} # I remove all security
                Set-Acl -Path "H:\HomeDrives" -AclObject $acl

                # Grant Domain Users
                $permission="Domain Users","ReadandExecute","Allow"
                $accessRule=new-object System.Security.AccessControl.FileSystemAccessRule $permission
                $acl.AddAccessRule($accessRule)
                Set-Acl -Path "H:\HomeDrives" -AclObject $acl

                # Grant Domain Admins
                $user = 'Domain Admins'                # test with this account
                $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                $acl.AddAccessRule($AccessRule)
                Set-Acl -Path "H:\HomeDrives" -AclObject $acl

                # Grant CREATOR OWNER
                $user = 'CREATOR OWNER'                # test with this account
                $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                $acl.AddAccessRule($AccessRule)
                Set-Acl -Path "H:\HomeDrives" -AclObject $acl

                # Grant SYSTEM
                $user = 'SYSTEM'                # test with this account
                $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                $acl.AddAccessRule($AccessRule)
                Set-Acl -Path "H:\HomeDrives" -AclObject $acl
                }
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = '[File]CreateUsersHomeDrivesFolder'
        }

        Registry SchUseStrongCrypto
        {
            Key                         = 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        Registry SchUseStrongCrypto64
        {
            Key                         = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
            ValueName                   = 'SchUseStrongCrypto'
            ValueType                   = 'Dword'
            ValueData                   =  '1'
            Ensure                      = 'Present'
        }

        xRemoteFile DownloadUserData
        {
            DestinationPath = "H:\Data\UserData.zip"
            Uri             = $UserDataUrl
            UserAgent       = "[Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer"
            DependsOn = '[File]CreateDataFolder','[Registry]SchUseStrongCrypto','[Registry]SchUseStrongCrypto64','[Script]ConfigureUserFolderPermissions'
        }

        $Number = 0
        foreach($Item in 1..$UserCount)
        {
            $Number += 1
            $UserName = "$NamingConvention-User$Number"

            File "CreateUserFolder$Number"
            {
                Type = 'Directory'
                DestinationPath = "H:\HomeDrives\$UserName"
                Ensure = "Present"
                DependsOn = '[xRemoteFile]DownloadUserData'
            }

            Script "UnzipUserData$Number"
            {
                SetScript =
                {
                    # UnCompress UserFolder
                    $UserFolderPath = Get-Item -Path "H:\HomeDrives\$using:UserName" -ErrorAction 0
                    IF ($UserFolderPath -ne $Null) {
                    Expand-Archive -Path "H:\Data\UserData.zip" -DestinationPath "H:\HomeDrives\$using:UserName" -Force
                    }
                    ELSE {}
                }
                GetScript =  { @{} }
                TestScript = { $false}
                DependsOn = "[File]CreateUserFolder$Number"
            }

            Script "GrantUserFolder$Number"
            {
                SetScript =
                {
                    # Grant Domain Admins
                    $acl = Get-ACL -Path "H:\HomeDrives\$using:UserName"
                    $user = "$using:UserName"                # test with this account
                    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                    $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
                    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
                    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"None"
                    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                    $acl.AddAccessRule($AccessRule)
                    Set-Acl -Path "H:\HomeDrives\$using:UserName" -AclObject $acl

                }
                GetScript =  { @{} }
                TestScript = { $false}
                DependsOn = "[Script]UnzipUserData$Number"
            }
        }
    }
}