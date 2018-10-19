$testFiles = Get-ChildItem .\tests

$ErrorActionPreference="Stop"
foreach ( $f in $testFiles ) {
    if ( $f -notmatch "run-all-tests" ) {
        write-host "RUNNING TESTS IN $($f.FullName)"
        . $f.FullName
    }
}
