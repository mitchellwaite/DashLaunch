param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][string]$TemplateFile,
    [Parameter(Mandatory=$true)][string]$OutputFile
)

$ErrorActionPreference = "Stop"

Push-Location $RepoRoot
try {
    $rev = (git rev-list --count HEAD).Trim()
}
finally {
    Pop-Location
}

if (-not ($rev -match '^\d+$')) {
    Write-Error "git rev-list did not return a valid integer: '$rev'"
    exit 1
}

(Get-Content -Raw $TemplateFile) -replace '\$WCREV\$', $rev | Set-Content -NoNewline $OutputFile

Write-Host "Generated $OutputFile (rev $rev)"