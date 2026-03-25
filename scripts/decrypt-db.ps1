param(
    [string]$SourceDb,
    [string]$TargetDb,
    [string]$Password
)

$ErrorActionPreference = "Stop"

$sqleetExe = Join-Path (Split-Path $PSScriptRoot -Parent) "sqleet.exe"
if (-not (Test-Path -LiteralPath $sqleetExe)) {
    Write-Host "[ERROR] Cannot find sqleet.exe next to this script."
    exit 1
}

Write-Host ""
Write-Host "=== Decrypt SQLite Database ==="

if ([string]::IsNullOrWhiteSpace($SourceDb)) {
    $SourceDb = Read-Host "Encrypted database path"
}
if ([string]::IsNullOrWhiteSpace($TargetDb)) {
    $TargetDb = Read-Host "Decrypted output path (leave blank to use .\\decrypted\\<same file name>)"
}
if ([string]::IsNullOrWhiteSpace($Password)) {
    $Password = Read-Host "Password"
}

if ([string]::IsNullOrWhiteSpace($SourceDb)) {
    Write-Host "[ERROR] Encrypted database path is required."
    exit 1
}
if ([string]::IsNullOrWhiteSpace($Password)) {
    Write-Host "[ERROR] Password is required."
    exit 1
}
if (-not (Test-Path -LiteralPath $SourceDb)) {
    Write-Host "[ERROR] Encrypted database does not exist:"
    Write-Host $SourceDb
    exit 1
}

$sourceItem = Get-Item -LiteralPath $SourceDb
if ([string]::IsNullOrWhiteSpace($TargetDb)) {
    $defaultFolder = Join-Path $sourceItem.DirectoryName "decrypted"
    if (-not (Test-Path -LiteralPath $defaultFolder)) {
        New-Item -ItemType Directory -Path $defaultFolder | Out-Null
    }
    $TargetDb = Join-Path $defaultFolder $sourceItem.Name
}

$sourceFull = [System.IO.Path]::GetFullPath($SourceDb)
$targetFull = [System.IO.Path]::GetFullPath($TargetDb)
if ($sourceFull -ieq $targetFull) {
    Write-Host "[ERROR] Source and target paths must be different."
    exit 1
}

if (-not (Test-Path -LiteralPath (Split-Path -Parent $targetFull))) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $targetFull) | Out-Null
}

Copy-Item -LiteralPath $SourceDb -Destination $TargetDb -Force

$escapedPassword = $Password.Replace("'", "''")
$tmpSql = Join-Path $env:TEMP ("sqleet_decrypt_{0}_{1}.sql" -f (Get-Random), (Get-Random))
@(
    "PRAGMA key='$escapedPassword';"
    "PRAGMA rekey='';"
) | Set-Content -LiteralPath $tmpSql -Encoding ascii

try {
    $command = '"' + $sqleetExe + '" "' + $TargetDb + '" < "' + $tmpSql + '"'
    & cmd.exe /d /s /c $command
    if ($LASTEXITCODE -ne 0) {
        throw "sqleet exited with code $LASTEXITCODE."
    }
}
catch {
    Remove-Item -LiteralPath $TargetDb -Force -ErrorAction SilentlyContinue
    Write-Host "[ERROR] Decryption failed."
    Write-Host $_
    exit 1
}
finally {
    Remove-Item -LiteralPath $tmpSql -Force -ErrorAction SilentlyContinue
}

if (-not (Test-Path -LiteralPath $TargetDb)) {
    Write-Host "[ERROR] Decryption command finished, but output file was not created."
    exit 1
}

Write-Host "[OK] Decrypted database created:"
Write-Host $TargetDb
