Function Send-GLT_ExceptionLog {
<#
.SYNOPSIS
    Send an Exception as an Alert-Level log
.DESCRIPTION
    Given an ErrorRecord, construct a message from the Exception in the
    ErrorRecord and send the message to GrayLog as an Alert-Level message.
.PARAMETER $e
    ErrorRecord. e.g. $error[0]. Contains all Exception data.
.NOTES
    Author: Brendan Bergen
    Date: Oct, 2018
#>
[cmdletbinding()]
    Param (
        [Parameter(Mandatory)][Object] $e
    )
    Process {
        Get-GLT_IsInitializedOrDie

        # check for higher-level exceptions (e.g Runtime); convert to ErrorRecord
        try {
            $e = $e.ErrorRecord
        }
        catch {
            # do nothing. not a high-level exception. Assume it's an ErrorRecord.
        }

        # expect an ErrorRecord Object by this point. Find relevant error info.
        $msg = $e.Exception.Message
        try {
            $add = @{
                'exceptiontype'    = [String] $e.Exception.GetType().Name
                'stacktrace'       = [String] $e.ScriptStackTrace
                'scriptlinenumber' = [String] $e.InvocationInfo.ScriptLineNumber
                'offsetinline'     = [String] $e.InvocationInfo.OffsetInLine
            }
        }
        catch {
            $add = @{}
        }

        Send-GLT_LevelLog $msg 'EMERGENCY' $add
    }
}
