<# 
.Synopsis
    Get employment objects from the Swedish employment service

.DESCRIPTION
    Build PowerShell objects from the Swedish employment service. This is a example module
    that is used to demonstrate the use of PowerShell 5 and object based on classes.

.EXAMPLE
    PS C:\> Get-NonPsJob

    List all employment objects

.EXAMPLE
    PS C:\> Get-NonPsJob | ? {$_.Workplace -like "*McDon*"}

    Gets all job that should come frome McDonals.

.EXAMPLE
    PS C:\>Get-NonPSJob | ? {$_.Workplace -like "*McDo*" -and $_.Location -like "*stock*"}

    Gets all job that should come frome McDonals and location is Stockholm

.EXAMPLE
    PS C:\>$Jobs = Get-NonPSJob | ? {$_.Workplace -like "*McDo*" -and $_.Location -like "*stock*"}
    PS C:\>$Jobs[0].ApplyForJob()

    Domonstrates that the Objects are built on PowerShell 5 Classes and use its own object methods.

.LINK
    GitHub project                http://GitHub.com/ulfvins/PowerShell/Modules/NonPSJob

#>
Function Get-NonPSJob{

    Param(
        [string]$Category = "Restaurangbitr%C3%A4de",
        [string]$LanId    = "1",
        [string]$NumberOf = "300"            
    )

    BEGIN{
        $Header      = @{  
                       "Accept"="application/json"
                       "Content-Type"="application/json;charset=utf-8"
                       "accept-language"="sv"
                       }
        $URL         = "http://api.arbetsformedlingen.se/platsannons/matchning?lanid=1&nyckelord="           
        $Query       = "$URL$Category&antalrader=$NumberOf"
        $QueryResult = Invoke-RestMethod -Uri $Query -Method Get -Headers $Header | Select-Object -ExpandProperty matchningslista | select -ExpandProperty matchningdata
    }
    PROCESS{
    
        $Result = @()
       
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