param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('1.28.14')]
    [string]$Version
)

$ErrorActionPreference = 'Stop'
$archiveName = "tfsec_${Version}_windows_amd64.tar.gz"
$archiveUri = "https://github.com/aquasecurity/tfsec/releases/download/v$Version/$archiveName"
$expectedSha256 = 'a53c4d7c6c85029378c8895ffbf9b23ea04a887d20136dc1d24d1307cf1a0491'
$tempDirectory = Join-Path $env:AGENT_TEMPDIRECTORY 'tfsec'
$archivePath = Join-Path $env:AGENT_TEMPDIRECTORY $archiveName

New-Item -ItemType Directory -Path $tempDirectory -Force | Out-Null
Invoke-WebRequest -Uri $archiveUri -OutFile $archivePath
$actualSha256 = (Get-FileHash -Path $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actualSha256 -ne $expectedSha256) {
    throw "tfsec archive checksum mismatch: expected $expectedSha256, got $actualSha256"
}

& tar.exe -xzf $archivePath -C $tempDirectory
if ($LASTEXITCODE -ne 0) {
    throw "tfsec archive extraction failed with exit code $LASTEXITCODE"
}

$tfsecPath = Join-Path $tempDirectory 'tfsec.exe'
if (-not (Test-Path $tfsecPath)) {
    throw "tfsec.exe was not found after extracting $archiveName"
}

Write-Host "##vso[task.prependpath]$tempDirectory"
& $tfsecPath --version
if ($LASTEXITCODE -ne 0) {
    throw "tfsec version check failed with exit code $LASTEXITCODE"
}
