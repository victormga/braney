# Installs the latest braney, or upgrades it in place:
#   irm https://raw.githubusercontent.com/victormga/braney/main/scripts/install.ps1 | iex

# A script block, so nothing leaks into the session iex runs it in; errors throw, since exit would
# close that session's window.
& {
	$ErrorActionPreference = "Stop"
	$ProgressPreference = "SilentlyContinue"

	$repo = "victormga/braney"
	$dir = "$env:LOCALAPPDATA\Programs\braney"

	# The OS's, not the process's: an x64 PowerShell on ARM reports x64.
	$os = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
	$arch = switch ($os) {
		"X64" { "amd64" }
		"Arm64" { "arm64" }
		default { throw "braney: no build for $os, see https://github.com/$repo/releases" }
	}

	$asset = "braney_windows_$arch.zip"
	$url = "https://github.com/$repo/releases/latest/download"

	$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
	New-Item -ItemType Directory -Path $tmp | Out-Null

	try {
		Write-Host "Downloading $asset"
		Invoke-WebRequest "$url/$asset" -OutFile "$tmp\$asset" -UseBasicParsing
		Invoke-WebRequest "$url/checksums.txt" -OutFile "$tmp\checksums.txt" -UseBasicParsing

		$expected = foreach ($line in Get-Content "$tmp\checksums.txt") {
			$hash, $name = $line -split '\s+'
			if ($name -eq $asset) { $hash }
		}
		$actual = (Get-FileHash "$tmp\$asset" -Algorithm SHA256).Hash
		if (-not $expected -or $actual -ne $expected) {
			throw "braney: checksum mismatch for $asset"
		}

		Expand-Archive "$tmp\$asset" $tmp -Force
		New-Item -ItemType Directory -Force -Path $dir | Out-Null

		$exe = "$dir\braney.exe"
		if (Test-Path $exe) {
			Rename-Item $exe ".braney.exe.$([DateTime]::UtcNow.Ticks).old"
		}
		Move-Item "$tmp\braney.exe" $exe
	}
	finally {
		Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
	}

	Write-Host "Installed braney to $exe"

	$paths = @([Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Where-Object { $_ })
	if ($paths -notcontains $dir) {
		[Environment]::SetEnvironmentVariable("Path", (($paths + $dir) -join ";"), "User")
		$env:Path += ";$dir"
		Write-Host "Added $dir to your PATH."
	}

	Write-Host "Run braney in your project folder to start."
}
