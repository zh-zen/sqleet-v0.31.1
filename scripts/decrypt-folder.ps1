param(
    [string]$FolderPath,
    [string]$Password
)

$ErrorActionPreference = "Stop"

$decryptScript = Join-Path $PSScriptRoot "decrypt-db.ps1"
if (-not (Test-Path -LiteralPath $decryptScript)) {
    Write-Host "[ERROR] Cannot find decrypt-db.ps1 in the scripts folder."
    exit 1
}

Write-Host ""
Write-Host "=== Decrypt All .db Files In A Folder ==="

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
    Where-Object { $_.BaseName -like "*_enc" } |
    Sort-Object Name

if ($dbFiles.Count -eq 0) {
    Write-Host "[ERROR] No eligible encrypted .db files were found in the folder."
    exit 1
}

$processed = 0
foreach ($dbFile in $dbFiles) {
    $plainBaseName = $dbFile.BaseName.Substring(0, $dbFile.BaseName.Length - 4)
    $targetPath = Join-Path $dbFile.DirectoryName ($plainBaseName + "_dec" + $dbFile.Extension)
    Write-Host ""
    Write-Host ("[INFO] Decrypting {0} -> {1}" -f $dbFile.Name, [System.IO.Path]::GetFileName($targetPath))
    & powershell -NoProfile -ExecutionPolicy Bypass -File $decryptScript -SourceDb $dbFile.FullName -TargetDb $targetPath -Password $Password
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Batch decryption stopped."
        exit $LASTEXITCODE
    }
    $processed++
}

Write-Host ""
Write-Host ("[OK] Decrypted {0} database file(s)." -f $processed)
