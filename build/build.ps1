# run from root directory of module!

#TODO: git checkout most recent commit
#git checkout -- *

write-host "RUNNING TESTS!"
.\tests\run-all-tests.ps1

write-host "BUILDING PACKAGE!"
$outputDir = "$($env:TMP)\ps_build_output"
$date = (Get-Date -Date (Get-Date)).ToUniversalTime()
$moduleVersion = Read-Host "Enter a Module Version Number (x.x.x.x)"
$moduleName = "PSGLogThis"
$ArtifactPath = "$($moduleName)_$($moduleVersion).zip"

.\build\buildScript.ps1 `
    -OutputDir $outputDir `
    -ManifestPath "$($moduleName).psd1" `
    -ModuleFilePath "$($moduleName).psm1" `
    -ModuleVersion $moduleVersion `
    -ArtifactPath $ArtifactPath

#TODO: git tag this commit?
#git tag -a "$($moduleVersion)" -m "Release $($moduleVersion)"