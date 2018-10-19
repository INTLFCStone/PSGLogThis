Function Initialize-GLT_Module {
[cmdletbinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName="UDP")] [Switch] $UDP,
        [Parameter(Mandatory,ParameterSetName="TCP")] [Switch] $TCP,
        [Parameter(          ParameterSetName="TCP")] [Switch] $Encrypt,
        [Parameter(Mandatory                       )] [String] $GelfServer,
        [Parameter(Mandatory                       )] [Int]    $GelfPort,
        [Parameter(Mandatory                       )] [String] $Facility
    )
    Process {
        Reset-GLT_Module

        if ( $UDP ) {
            $Script:GelfLt_Config['GELFSender'] = New-OOG_GELFSenderUDP `
                                                      -GelfServer $GelfServer `
                                                      -GelfPort $GelfPort
        }
        elseif ( $TCP ) {
            if ( $Encrypt ) {
                $Script:GelfLt_Config['GELFSender'] = New-OOG_GELFSenderTCP `
                                                          -GelfServer $GelfServer `
                                                          -GelfPort $GelfPort `
                                                          -Encrypt
            }
            else {
                $Script:GelfLt_Config['GELFSender'] = New-OOG_GELFSenderTCP `
                                                          -GelfServer $GelfServer `
                                                          -GelfPort $GelfPort
            }
        }
        else {
            throw "You must choose TCP or UDP!"
        }

        $Script:GelfLt_Config['LogLevels']     = Get-OOG_LogLevels
        $Script:GelfLt_Config['Facility']      = $Facility
        $Script:GelfLt_Config['IsInitialized'] = $True
    }
}
