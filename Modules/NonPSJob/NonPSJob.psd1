@{

# Script module or binary module file associated with this manifest.
RootModule =  'NonPSJob.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.0'

# ID used to uniquely identify this module
GUID = '9399d738-33fb-4483-a761-f423a9993972'

# Author of this module
Author = 'Richard Ulfvin'

# Company or vendor of this module
CompanyName = 'AddLevel'

# Copyright statement for this module
Copyright = '(c) 2016 . All rights reserved.'

# Description of the functionality provided by this module
Description = 'Returning No PS Jobs from the Swedish employment service'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

FunctionsToExport = @('Get-NonPSJob','Get-Propeller')

}
