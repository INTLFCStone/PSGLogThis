# Introduction
Send formatted messages to GrayLog by leveraging the PSOoGelf module.

The functions herein are a sister-module to PSGELF. They are better suited for application-level
logging (as opposed to WinEvent logging found in PSGELF). The module automatically populates fields of log messages
like the current machine's IP address, UTC DateTime, and Facility. Additionally, the functions provide a
standard way to log PS Exception Objects. It also manages your connection to your
GELF server throughout your scripts: you login once and send messages
infinitely after that.

This module wraps [PSOoGelf](https://github.com/INTLFCStone/PSOoGelf) to automatically manage the objects created there. See
that module for more details on GELF restrictions.

# Example - Use the GELFMessage and GELFSender factories/orchestrators 
```Powershell
Import-Module PSGLogThis

# initialize a connection to your GELF (Graylog?) server, used for the rest of the script
# alternatively, you can use unencrypted TCP or (unencrypted) UDP.
Initialize-GLT_Module `
    -TCP -Encrypt `
    -GelfServer "my.server.com" `
    -GelfPort 12345 `
    -Facility "MyDefaultApplicaitonFacility"


# wrappers for each level of log messages are provided:
# send a simple text log
Send-GLT_InfoLog "This is informational only"
Send-GLT_WarningLog "Woa there, something's up!"

# send a message with an attached object containing different fields (you can opt
# to override the default facility this way, or add other fields)
# I recommend using HashTables or PSCustomObjects. See PSOoGelf for restrictions.
$obj = [PSCustomObject] @{
    'customfield' = "abc"
    'facility' = "myNewFacilityForThisSpecificMessage"
}
Send-GLT_ErrorLog "Yikes!" $obj

# easy exception handling with emergency-level messages
try {
    throw "What The?!?"
}
catch {
    # pass the Error object. Boom, done!
    Send-GLT_ExceptionLog $_
    throw
}

# destroy hidden-in-memory data like the Gelf Server/Port... not really required.
Reset-GLT_Module
```
