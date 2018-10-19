Function Get-GLT_IsInitializedOrDie {
<#
.SYNOPSIS
    Throw an error if the module hasn't been configured yet.
.NOTES
    Author: Brendan Bergen
    Date: Oct, 2018
#>
[cmdletbinding()]
    Param ()
    Process {
        if ( ! $Script:GelfLt_Config['IsInitialized'] ) {
            throw "You must initialize the module before sending logs!"
        }
    }
}
