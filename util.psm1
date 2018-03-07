function PSCO-To-Hash() {
	param(
	[Parameter(Mandatory=$True, ValueFromPipeline=$True)]
	[PSCustomObject]$obj
	)

	$result = @{}
	$obj | Get-Member -MemberType NoteProperty | ForEach-Object {
        $key = $_.Name
        $result[$key] = $obj."$key"
    }

	write-output $result
}

function lnk() {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true, Position=1)]
		[string]$src,
		[Parameter(Mandatory=$true, Position=2)]
		[string]$dest,
		[Parameter(Mandatory=$true, Position=3)]
		[string]$type,
		[Parameter(Mandatory=$false)]
		[switch]$recurse = $false
	)

	$src = (resolve-path $src).Path
	$dest = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($dest)

	if(test-path $src -pathtype container) {
		$children = gci $src
		if(-not (test-path $dest)) {
			$a = ni $dest -itemtype directory -force
			write-information "Created directory $dest" -informationAction continue
		}
		foreach($c in $children) {
			$c = $c.FullName
			$target = $c.replace($src,$dest)
			if(test-path $c -pathtype container) {
				write-host $recurse
				if($recurse) {
					lnk $c $target $type -recurse $recurse
				}
				else {
					write-information "Skipping directory $c" -informationAction continue
				}
			}
			else {
				lnk $c $target $type
			}
		}
	}
	else {
		if(test-path $dest -pathtype any) {
			write-error "Link target $dest already exists!"
		}
		else {
			$a = new-item $dest -itemtype $type -value $src
			write-information "Created link from $src to $dest" -informationAction continue
		}
	}
}
