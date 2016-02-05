Function Get-Propeller{
   [System.Diagnostics.Process]::Start("http://www.propellerkeps.nu") | Out-Null
}