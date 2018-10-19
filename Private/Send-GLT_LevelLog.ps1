Function Send-GLT_LevelLog {
[cmdletbinding()]
    Param (
        [Parameter(Mandatory,Position=0)][String] $msg,
        [Parameter(Mandatory,Position=1)][String] $level,
        [Parameter(         ,Position=2)][Object] $adtnl
    )
    Process {
        Get-GLT_IsInitializedOrDie
        $lvlNum = $Script:GelfLt_Config['LogLevels'][$level]
        if ( $lvlNum -eq $null ) {
            throw "Level $($level) is not a valid level!"
        }

        $gm = New-OOG_GELFMessage `
                  -short_message $msg `
                  -full_message $msg `
                  -level $lvlNum `
                  -additional ( ConvertAdditionalObjectToFacilitatedHashTable($adtnl) )

        Send-GLT_MessageToServer( $gm )
    }
    Begin {
        Function ConvertAdditionalObjectToFacilitatedHashTable {
            Param ( [Object] $obj )

            if ( $obj -eq $null ) {
                return @{
                    'facility' = $Script:GelfLt_Config['Facility']
                }
            }

            $hash = @{}
            if ( $obj.GetType().Name -ne "HashTable" ) {
                $props =  @( $obj | Get-Member | Where-Object -Property MemberType -EQ NoteProperty )
                $props += @( $obj | Get-Member | Where-Object -Property MemberType -EQ Property )
                foreach ( $p in $props ) {
                    $name = $p.Name
                    $hash[$name] = $obj.$($name)
                }
            }
            else {
                $hash = [HashTable] $obj
            }

            if ( ! $hash['facility'] ) {
                $hash['facility'] = $Script:GelfLt_Config['Facility']
            }

            return $hash
        }
    }
}
