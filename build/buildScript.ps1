Param (
    [Parameter(Mandatory)] [String] $OutputDir,
    [Parameter(Mandatory)] [String] $ManifestPath,
    [Parameter(Mandatory)] [String] $ModuleFilePath,
    [Parameter(Mandatory)] [String] $ModuleVersion,
    [Parameter(Mandatory)] [String] $ArtifactPath
)
process {
	try {
		$ErrorActionPreference = "Stop"

		# ensure we have a manifest
		Test-Path ".\*.psd1"

		# get a listing of all files to include
		$fileFullPaths     = @(gci -Recurse).FullName
		$fileRelativePaths = $fileFullPaths.Substring("$(pwd)".Length)

		# create a directory to publish to
		mkdir $OutputDir

		try {
			# publish all files but the module files
			for ( $i=0; $i -lt $fileFullPaths.length; $i++ ) {
				if ( ($fileFullPaths[$i] -notlike "*.psm1") -and ($fileFullPaths[$i] -notlike "*.psd1") ) {
					cp "$($fileFullPaths[$i])" "$($OutputDir)\$($fileRelativePaths[$i])"
				}
			}

			# only publish the module files specified
			for ( $i=0; $i -lt $fileFullPaths.length; $i++ ) {
				if ( ($fileFullPaths[$i] -like "*$($ManifestPath)") -or ($fileFullPaths[$i] -like "*$($ModuleFilePath)") ) {
					cp "$($fileFullPaths[$i])" "$($OutputDir)\$($fileRelativePaths[$i])"
				}
			}

			# update version number
			$manifestNewPath="$($OutputDir)\$($ManifestPath)"
			(Get-Content $manifestNewPath) | Foreach-Object {$_ -replace '^ModuleVersion.*$', ("ModuleVersion = '$($ModuleVersion)'")} > $manifestNewPath

			# zip
			Compress-Archive -Path "$($OutputDir)/*" -DestinationPath "$($ArtifactPath)"
		}
		catch {
			throw
		}
		finally {
			rm -Recurse -Force $OutputDir
		}
	}
	catch {
		$Error[0].InvocationInfo.PositionMessage
		throw
	}
}