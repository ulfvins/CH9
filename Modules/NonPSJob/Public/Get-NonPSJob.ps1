<# 
.Synopsis
    Get employment objects from the Swedish employment service

.DESCRIPTION
    Build PowerShell objects from the Swedish employment service. This is a example module
    that is used to demonstrate the use of PowerShell 5 and object based on classes.

.PARAMETER Category
    What type of Job you look for? (default is "Restaurant")

.PARAMETER Region
    In what part of Sweden do you look for job? (default is 1=Stockholms Län)

    Id Name                   
    -- ----                   
    10 Blekinge län           
    20 Dalarnas län           
     9 Gotlands län           
    21 Gävleborgs län         
    13 Hallands län           
    23 Jämtlands län          
     6 Jönköpings län         
     8 Kalmar län             
     7 Kronobergs län         
    25 Norrbottens län        
    12 Skåne län              
     1 Stockholms län         
     4 Södermanlands län      
     3 Uppsala län            
    17 Värmlands län          
    24 Västerbottens län      
    22 Västernorrlands län    
    19 Västmanlands län       
    14 Västra Götalands län   
    18 Örebro län             
     5 Östergötlands län      
    90 Ospecificerad arbetsort

.EXAMPLE
    PS C:\> Get-NonPsJob

    List all employment objects

.EXAMPLE
    PS C:\> Get-NonPsJob | ? {$_.Workplace -like "*McDon*"}

    Gets all job that should come frome McDonalds.

.EXAMPLE
    PS C:\>Get-NonPSJob | ? {$_.Workplace -like "*McDo*" -and $_.Location -like "*stock*"}

    Gets all job that should come frome McDonalds and location is Stockholm

.EXAMPLE
    PS C:\>$Jobs = Get-NonPSJob | ? {$_.Workplace -like "*McDo*" -and $_.Location -like "*stock*"}
    PS C:\>$Jobs[0].ApplyForJob()

    Demos that the Objects are built in PowerShell 5 Classes and use it´s own object methods.

.LINK
    GitHub project                http://GitHub.com/ulfvins/PowerShell/Modules/NonPSJob

#>
Function Get-NonPSJob{

    [CmdletBinding()]
    Param(
        [Parameter(
            Position=0,
            HelpMessage="What type of job do you search for?"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Category = "Restaurangbitr%C3%A4de",

        [Parameter(
            Position=1,
            HelpMessage="In what region do you want to search?"
        )]
        [ValidatePattern('^[1-9]$|^[1]?[0-9]$|^[1-2]?[0-5]$|^90$')]
        [ValidateNotNullOrEmpty()]
        [string]$Region = "1",

        [Parameter(
            Position=2
        )]
        [ValidateNotNullOrEmpty()]
        [string]$NumberOf = "300"            
    )

    BEGIN{
        $Header      = @{  
                       "Accept"="application/json"
                       "Content-Type"="application/json;charset=utf-8"
                       "accept-language"="sv"
                       }
        $Query       = "http://api.arbetsformedlingen.se/platsannons/matchning?lanid=$Region&nyckelord=$Category&antalrader=$NumberOf"           
        $QueryResult = Invoke-RestMethod -Uri $Query -Method Get -Headers $Header | 
                       Select-Object -ExpandProperty matchningslista | 
                       Select-Object -ExpandProperty matchningdata
    }
    PROCESS{
    
        $Result = @()

        #TODO: Fix if there are no query objects...

        ForEach ($r in $QueryResult){

            $NonPSJobObject   = New-Object NonPSJob -Property @{
                Title         = $($r.annonsrubrik)
                Workplace     = $($r.arbetsplatsnamn)
                Location      = $($r.kommunnamn)
                Category      = $($r.yrkesbenamning)
                NumberOfSeats = $($r.antalplatser)
                Url           = $($r.annonsurl)
            }
            $Result += $NonPSJobObject
        }

        Return  $Result
            
    }
    END{}   
}