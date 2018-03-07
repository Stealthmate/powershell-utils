<#
.SYNOPSIS Shows/Modifies array-like environment variables (PATH, PATHEXT, etc.)

.DESCRIPTION
When used with only one argument, shows all the items in the array, separated by
a newline. When used without -commit, outputs a modified array by prepending,
appending or removing items from it. When used with -commit it does not output
anything and instead applies changes to the actual environment variable in the
PROCESS scope.
#>
function modevarr() {
    [CmdletBinding(DefaultParameterSetName="View")]
    param(
        [Parameter(Mandatory, Position=1)]
        [string]$var,

        [Parameter(ParameterSetName="Edit")]
        [string[]]$prepend,
        [Parameter(ParameterSetName="Edit")]
        [string[]]$append,
        [Parameter(ParameterSetName="Edit")]
        [string[]]$remove,
        [Parameter(ParameterSetName="Edit")]
        [switch]$commit
    )

    $value = env $var

    switch($PSCmdlet.ParameterSetName) {
        "View" {
            write-output $value.split(";")
            break
        }

        "Edit" {
            $value = arrstr $value -d ";" -a $append -p $prepend -r $remove,"" -rd
            if($commit) {
                env -u @{$var=$value} -t p
                write-information "Commited change to Process"
            }
            else {
                write-output $value
            }
        }
    }
}

Export-ModuleMember -Function modevarr
