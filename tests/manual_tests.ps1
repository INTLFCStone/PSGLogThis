Process {
    if ( Get-Module PSGLogThis ) {
        Remove-Module PSGLogThis
    }
    Import-Module .\PSGLogThis.psd1 -Force -Verbose
    Set-StrictMode -Version latest
    $ErrorActionPreference = "Stop"

    $facility = "PSGLogThisTesting"

    Initialize-GLT_Module -UDP -GelfServer $env:GELF_NONPROD_UDP_SERVER -GelfPort $env:GELF_NONPROD_UDP_PORT -Facility $facility
    PerformAllTests

    Initialize-GLT_Module -TCP -GelfServer $env:GELF_NONPROD_TCP_SERVER -GelfPort $env:GELF_NONPROD_TCP_PORT -Facility $facility
    PerformAllTests

    #Initialize-GLT_Module -TCP -Encrypt -GelfServer $env:GELF_NONPROD_TCP_SERVER -GelfPort $env:GELF_NONPROD_TCP_PORT -Facility $facility
    #PerformAllTests
}
Begin {
    Function PerformAllTests {
        #--------------------------
        # send messages (text only)
        #--------------------------
        Send-GLT_DebugLog "PSGLogThis test - Debug message test" -Verbose
        Send-GLT_InfoLog "PSGLogThis test - Informational message test" -Verbose
        Send-GLT_NoticeLog "PSGLogThis test - Notice message test" -Verbose
        Send-GLT_WarningLog "PSGLogThis test - Warning message test" -Verbose
        Send-GLT_ErrorLog "PSGLogThis test - Error message test" -Verbose
        Send-GLT_CriticalLog "PSGLogThis test - Critical message test" -Verbose
        Send-GLT_AlertLog "PSGLogThis test - Alert message test" -Verbose
        Send-GLT_EmergencyLog "PSGLogThis test - Emergency message test" -Verbose

        #----------------------------------
        # send messages based on exceptions
        #----------------------------------
        try {
            throw "PSGLogThis test - Exception (throw) message test"
        }
        catch {
            Send-GLT_ExceptionLog $_ -Verbose
        }

        try {
            this is a syntax error
        }
        catch {
            Send-GLT_ExceptionLog $_ -Verbose
        }

        try {
            Function We {
                Function Must {
                    Function Go {
                        Function Deeper {
                            $a = @()
                            $a[100] = "foobar"
                        }
                        Deeper
                    }
                    Go
                }
                Must
            }
            We
        }
        catch {
            Send-GLT_ExceptionLog $_ -Verbose
        }

        #------------------------------------
        # Send messages with objects attached
        #------------------------------------
        $obj = [PSCustomObject] @{
            'custom'  = "This is my custom field"
            'guid'    = [Guid]::NewGuid()
            'decimal' = [Decimal] 123.45
        }
        Send-GLT_DebugLog "PSGLogThis test - Debug message/object test"  $obj -Verbose
        Send-GLT_InfoLog "PSGLogThis test - Informational message/object test" $obj -Verbose
        Send-GLT_NoticeLog "PSGLogThis test - Notice message/object test" $obj -Verbose
        Send-GLT_WarningLog "PSGLogThis test - Warning message/object test" $obj -Verbose
        Send-GLT_ErrorLog "PSGLogThis test - Error message/object test" $obj -Verbose
        Send-GLT_CriticalLog "PSGLogThis test - Critical message/object test" $obj -Verbose
        Send-GLT_AlertLog "PSGLogThis test - Alert message/object test" $obj -Verbose
        Send-GLT_EmergencyLog "PSGLogThis test - Emergency message/object test" $obj -Verbose
    }
}
