Function Send-GLT_InfoLog {
<#
.SYNOPSIS
    Send a message as an informational log
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
        Send-GLT_LevelLog $msg 'INFORMATION' $obj
    }
}
