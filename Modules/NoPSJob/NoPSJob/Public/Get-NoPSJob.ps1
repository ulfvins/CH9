Function Get-NoPSJob{

    #Get-NoPsJob | ? {$PSItem.WorkplaceName -like "*Mc*"}
    #$Jobs = Get-NoPSJob | ? {$_.Workplace -like "*McDo*" -and $_.Location -like "*stock*"}
    #$Jobs[0].ApplyForJob()
    #$Jobs | | % {$_.ApplyForJob()

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

            $NonPSJobObject   = New-Object NoPSJob -Property @{
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