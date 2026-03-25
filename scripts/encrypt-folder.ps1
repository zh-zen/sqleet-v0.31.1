param(
    [string]$FolderPath,
    [string]$Password
)

$ErrorActionPreference = "Stop"

$encryptScript = Join-Path $PSScriptRoot "encrypt-db.ps1"
if (-not (Test-Path -LiteralPath $encryptScript)) {
    Write-Host "[ERROR] Cannot find encrypt-db.ps1 in the scripts folder."
    exit 1
}

Write-Host ""
Write-Host "=== Encrypt All .db Files In A Folder ==="

if ([string]::IsNullOrWhiteSpace($FolderPath)) {
    $FolderPath = Read-Host "Folder path"
}
if ([string]::IsNullOrWhiteSpace($Password)) {
    $Password = Read-Host "Password"
}

if ([string]::IsNullOrWhiteSpace($FolderPath)) {
    Write-Host "[ERROR] Folder path is required."
    exit 1
}
if ([string]::IsNullOrWhiteSpace($Password)) {
    Write-Host "[ERROR] Password is required."
    exit 1
}
if (-not (Test-Path -LiteralPath $FolderPath -PathType Container)) {
    Write-Host "[ERROR] Folder does not exist:"
    Write-Host $FolderPath
    exit 1
}

$dbFiles = Get-ChildItem -LiteralPath $FolderPath -File -Filter "*.db" |
    Where-Object { $_.BaseName -notlike "*_enc" -and $_.BaseName -notlike "*_dec" } |
    Sort-Object Name

if ($dbFiles.Count -eq 0) {
    Write-Host "[ERROR] No eligible .db files were found in the folder."
    exit 1
}

$processed = 0
foreach ($dbFile in $dbFiles) {
    $targetPath = Join-Path $dbFile.DirectoryName ($dbFile.BaseName + "_enc" + $dbFile.Extension)
    Write-Host ""
    Write-Host ("[INFO] Encrypting {0} -> {1}" -f $dbFile.Name, [System.IO.Path]::GetFileName($targetPath))
    & powershell -NoProfile -ExecutionPolicy Bypass -File $encryptScript -SourceDb $dbFile.FullName -TargetDb $targetPath -Password $Password
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Batch encryption stopped."
        exit $LASTEXITCODE
    }
    $processed++
}

Write-Host ""
Write-Host ("[OK] Encrypted {0} database file(s)." -f $processed)
