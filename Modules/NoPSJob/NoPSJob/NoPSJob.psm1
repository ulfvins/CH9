#Load all external Functions:
$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path
"$moduleRoot\Private\*.ps1","$moduleRoot\Public\*.ps1" |
Resolve-Path |
Where-Object { -not ($_.ProviderPath.ToLower().Contains(".tests.")) } |
ForEach-Object { . $_.ProviderPath }