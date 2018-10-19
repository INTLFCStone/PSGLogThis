Function Send-GLT_DebugLog {
<#
.SYNOPSIS
    Send a message as a debug log.
.PARAMETER $msg
    String. Message to log.
.PARAMETER $obj
    Object. Additional fields to log.
.NOTES
    Author: Brendan Bergen
    Date: Oct, 2018
#>
[cmdletbinding()]
    Param (
        [Parameter(Mandatory)][String] $msg,
        [Parameter()]         [Object] $obj
    )
    Process {
        Send-GLT_LevelLog $msg 'DEBUG' $obj
    }
}
