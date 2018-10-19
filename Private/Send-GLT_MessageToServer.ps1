Function Send-GLT_MessageToServer {
<#
.SYNOPSIS
    Attempt to send messages to the GELF server.
.NOTES
    Author: Brendan Bergen
    Date: Oct, 2018
#>
[cmdletbinding()]
    Param (
        [Parameter(Mandatory)] [Object] $msg
    )
    Process {
	if ( $msg.GetType().Name -ne "GELFMessage" ) {
            throw "You must provide a GELFMessage object in order to send!"
        }
        # TODO: maybe this function can go away... maybe it's a way to
        #       expand error handling? Add a try-catch, or verbosity?
        #       dry-runs? idk, leaving it for now.
        Write-Verbose "Sending log message:`n$($msg.ToString())"
        $Script:GelfLt_Config['GELFSender'].SendGELFMessage( $msg )
    }
}
