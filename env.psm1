function env_parse_targets() {
	[CmdletBinding()]
	param(
		[string]$target
	)

	$targets = @()

	if($target.contains("m")) {
		$targets += "Machine"
	}
	if($target.contains("u")) {
		$targets += "User"
	}
	if($target.contains("p")) {
		$targets += "Process"
	}

	write-output $targets
}

function Get-Environment() {
	[CmdletBinding(DefaultParameterSetName="View")]
	param(
		[Parameter(ParameterSetName="View", Position=1)]
		[array]$vars=@(),

		[Parameter(ParameterSetName="Edit", Mandatory, Position=1)]
		[hashtable]$update,

		[Parameter(ParameterSetName="View")]
		[Parameter(ParameterSetName="Edit")]
		[string]$target="p"
	)

	$targets = env_parse_targets $target

	switch($PSCmdlet.ParameterSetName) {
		"View" {
			$output = @{}
			foreach($t in $targets) {
				$vals = [System.Environment]::GetEnvironmentVariables($t)
				if($vars.length -gt 0) {
					$vals = @{}
					$vars | foreach-object {
						$vals[$_] = [System.Environment]::GetEnvironmentVariable($_, $t)
					}
				}
				$vals.keys | foreach-object {
					$output[$_] = $vals[$_]
				}
			}
			write-output $output
			break
		}

		"Edit" {
			foreach($t in $targets) {
				$update.Keys | foreach-object {
					$val = $update[$_]
					[System.Environment]::SetEnvironmentVariable($_, $val, $t)
					if(!$val) {
						$val = "`$null"
					}
					write-information "Value of $_ in $t changed to: $val" -InformationAction Continue
				}
			}
		}
	}
}

set-alias env Get-Environment
Export-ModuleMember -Function "Get-Environment"
Export-ModuleMember -Alias "env"
