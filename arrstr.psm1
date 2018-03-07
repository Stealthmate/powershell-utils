<#
.SYNOPSIS
Modifies delimited array-like strings

.DESCRIPTION
After converting a string to an array by splitting on a delimiter, appends,
prepends and/or removes items from the array, and then joins all the items in
a string using the specified delimiter.
#>
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
