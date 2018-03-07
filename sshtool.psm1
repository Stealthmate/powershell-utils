<#
.SYNOPSIS
Loads SSH keys using a specified agent

.DESCRIPTION
Given two environment variables - SSH_KEYS(directory containing keys) and
SSH_AGENT(path to the agent executable):
When used with -view, lists all the keys available in SSH_KEYS.

When used with -load, loads the key with the agent from SSH_AGENT.

.PARAMETER load
A list of paths to keys to load. Absolute and relative paths are supported.
Relative paths are resolved with respect to SSH_KEYS
#>
function sshtool() {
	param(
		[Parameter(ParameterSetName="View")]
		[switch]$view,

		[Parameter(ParameterSetName="Load", Mandatory)]
		[string[]]$load
	)

	switch($PSCmdlet.ParameterSetName) {
		"View" {
			if($view) {
				$res = gci $env:SSH_KEYS\* | select -expand Name
				write-output $res
				break
			}
		}

		"Load" {
			$load | % {
				$path = $_
				if(![System.IO.Path]::IsPathRooted($path)) {
					$path = -join($env:SSH_KEYS, "\$path")
				}
				$file = gci $path -erroraction SilentlyContinue

				if($file -eq $null) {
					write-error "Could not load key: Key does not exist: $load"
					return
				}

				write-host "Loading key: $load"
				& $env:SSH_AGENT $file
			}
		}
	}
}

export-modulemember -Function sshtool
