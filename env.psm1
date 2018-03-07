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

<#
.SYNOPSIS
Views/Edits environment variables

.DESCRIPTION
When used with no arguments, lists all environment variables and their values.
Passing an array of variable names shows values only for the specified variables.
When used with the -update argument, sets values for all the listed variables.
Using -target allows for specifying whether to view/edit Process, User or Machine
scope variables.

.PARAMETER vars
An array of variable names to show the values of

.PARAMETER update
A hash-table of varible:value pairs, which specifies the variables to edit and
their respective new values. Passing $null as a value is equivalent to deleting
the variable

.PARAMETER target
A string, containing the characters 'm', 'u' and/or 'p', which specifies the
scope where this command operates - Machine, User and Process respectively.
Passing multiple scopes will result in either viewing the variables from both
scopes (-vars) or setting variables in both scopes (-update)
#>
function env() {
	[CmdletBinding(DefaultParameterSetName="View")]
	param(
		[Parameter(ParameterSetName="View", Position=1)]
		[string[]]$vars=@(),

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
			if($output.count -eq 1) {
				$output = $output | select -expandproperty Values
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
					write-information "Value of $_ in $t changed to: $val"
				}
			}
		}
	}
}

Export-ModuleMember -Function "env"
