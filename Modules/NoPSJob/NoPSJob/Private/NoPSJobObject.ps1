Class NoPSJob
{
    [string]$Title
    [string]$Workplace
    [string]$Location
    [string]$Category
    [int]$NumberOfSeats            
    [string]$Url

    [void]ApplyForJob() {
        Write-Host "Opening Url: $($this.Url)......." -ForegroundColor Green
        [System.Diagnostics.Process]::Start($this.Url)                
    }
}