
# The names and locations of the virtual servers are stored in servers.txt. They will be exported in the order given.
$servers = Import-Csv -Path '.\servers.txt'

$vmExportsLocation = Get-Content -Path '.\exportLocation.txt'

foreach ($server in $servers) {
	
	$server = $server.VMName

	Write-Output "Backing up server: $server"

	# Test if a current backup exists
	if (Test-Path -Path "$vmExportsLocation\$server"){
		# Path exists

		# Test if the folder exists in the archive
		if (Test-Path -Path "$vmExportsLocation\Archive\$server"){
			# Path exists
			Write-Output "Deleting archival backup"
			Remove-Item -Recurse -Path "$vmExportsLocation\Archive\$server"
		}

		Write-Output 'Moving previous backup to archive'
		Move-Item -Path "$vmExportsLocation\$server" -Destination "$vmExportsLocation\Archive\$server"
	}

	Write-Output "Exporting VM backup"
	Get-VM $server | Export-VM -Path "$vmExportsLocation"

}