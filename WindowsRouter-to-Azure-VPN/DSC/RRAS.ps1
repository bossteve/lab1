Configuration RRAS
{
    Node localhost
    {   
        WindowsFeature Routing
        { 
            Ensure = 'Present' 
            Name = 'Routing' 
        }         

        WindowsFeature RSAT-RemoteAccess
        { 
            Ensure = 'Present' 
            Name = 'RSAT-RemoteAccess' 
            DependsOn = '[WindowsFeature]Routing'
        }
     }
  }