Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#-------------------------------------------------------------------------------
# PULL IN FUNCTIONS FROM TREE
#-------------------------------------------------------------------------------
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 )

$dirsToImport = @($Public + $Private)

Foreach( $i in $dirsToImport ) {
    try {
        . $i.fullname
    }
    catch {
        write-error "Failed to import function $($i.fullname): $_"
    }
}

#-------------------------------------------------------------------------------
# EXPORT PUBLIC FUNCTIONS
#-------------------------------------------------------------------------------
Export-ModuleMember -Function $Public.Basename
