Function Send-GLT_CriticalLog {
<#
.SYNOPSIS
    Send a message as a critical log.
.PARAMETER $msg
    String. Message to log.
.PAREMETER $obj
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
        Send-GLT_LevelLog $msg 'CRITICAL' $obj
    }
}
