function modevarr() {
    [CmdletBinding(DefaultParameterSetName="View")]
    param(
        [Parameter(Mandatory, Position=1)]
        [string]$var,

        [Parameter(ParameterSetName="View")]
        [switch]$split,

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
            if($split) {
                $value = $value.split(';')
            }

            write-output $value
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
