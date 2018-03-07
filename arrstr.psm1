function arrstr() {
    [CmdletBinding(DefaultParameterSetName="View")]
    param(
        [Parameter(ParameterSetName="View")]
        [Parameter(ParameterSetName="Edit")]
        [Parameter(Mandatory, Position=1)]
        [string]$str,

        [Parameter(ParameterSetName="View")]
        [Parameter(ParameterSetName="Edit")]
        [string]$delimiter=";",

        [Alias("r")]
        [Parameter(ParameterSetName="Edit")]
        [string[]]$remove,
        [Alias("rd")]
        [Parameter(ParameterSetName="Edit")]
        [switch]$removeDuplicates,
        [Parameter(ParameterSetName="Edit")]
        [string[]]$prepend,
        [Parameter(ParameterSetName="Edit")]
        [string[]]$append
    )

    $arr = $str.split($delimiter)

    switch($PSCmdlet.ParameterSetName) {
        "View" {
            write-output ($arr -join ("`n"))
            break
        }

        "Edit" {
            if($prepend) {
                $arr = $prepend + $arr
            }
            if($append) {
                $arr = $arr + $append
            }
            
            $out = new-object System.Collections.ArrayList(,$arr)

            $remove | foreach-object {
                do {
                    $out.remove($_)
                }
                while($out.contains($_) -and $removeDuplicates)
            }

            $out = $out -join($delimiter)
            write-output $out
        }
    }
}

Export-ModuleMember -Function arrstr
