function sshtool() {
	param(
		[Parameter(ParameterSetName="View")]
		[switch]$list,

		[Parameter(ParameterSetName="Load", Mandatory)]
		[string]$load
	)

	switch($PSCmdlet.ParameterSetName) {
		"View" {
			$res = gci $env:SSH_KEYS\*.ppk | foreach-object { $_.replace(".ppk","") }
			write-output $res
			break
		}

		"Load" {
			$file = gci $env:SSH_KEYS\$load".ppk" -erroraction SilentlyContinue

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
