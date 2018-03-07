function sshtool() {
	param(
		[Parameter(ParameterSetName="View")]
		[switch]$view,

		[Parameter(ParameterSetName="Load", Mandatory)]
		[string]$load
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

			$path = $load
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

export-modulemember -Function sshtool
