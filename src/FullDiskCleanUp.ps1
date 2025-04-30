# Function to check if the script is running as Administrator
function Test-IsAdministrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Elevate if not already running as Admin
if (-not (Test-IsAdministrator)) {
    Write-Host "This script needs to be run as an Administrator."
    Write-Host "Trying to restart with elevated privileges..."
    Start-Process powershell -ArgumentList "$($MyInvocation.MyCommand.Definition)" -Verb RunAs
    exit
}

# Define the sageset number and format it with leading zeros
$sagesetNumber    = 500
$formattedNumber = $sagesetNumber.ToString("D4")  # four-digit format
$stateFlagsName  = "StateFlags$formattedNumber"

# Registry path for VolumeCaches
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"

# List of built-in cleanup options
$cleanupOptions = @(
    "Delivery Optimization Files",
    "Device Driver Packages",
    "Temporary Files",
    "Windows Error Reporting Files",
    "Temporary Setup Files",
    "Update Cleanup",
    "Recycle Bin",
    "Previous Installations",
    "Thumbnail Cache"
)

# Apply StateFlags to each option
foreach ($option in $cleanupOptions) {
    $optionPath = Join-Path $regPath $option
    if (Test-Path $optionPath) {
        Set-ItemProperty -Path $optionPath -Name $stateFlagsName -Value 2
    } else {
        Write-Host "Registry path not found for option: $option"
    }
}

# Run Disk Cleanup
try {
    Start-Process cleanmgr -ArgumentList "/sagerun:$sagesetNumber" -Wait -NoNewWindow
    Write-Host "cleanmgr /sagerun:$sagesetNumber has been executed."
} catch {
    Write-Host "Failed to run cleanmgr. Error: $_"
}

# Remove the custom StateFlags entries
foreach ($option in $cleanupOptions) {
    $optionPath = Join-Path $regPath $option
    if (Test-Path $optionPath) {
        Remove-ItemProperty -Path $optionPath -Name $stateFlagsName -ErrorAction SilentlyContinue
    }
}

# === Additional arbitrary cleanup paths ===
# Just add any folder paths you want wiped here:
$extraCleanupPaths = @(
    # Stremio cache (relative to %APPDATA%)
    Join-Path $env:APPDATA 'stremio\stremio-server\stremio-cache'

    # Example of an absolute path:
    # 'C:\Temp\OldDownloads'

    # Example of another env-based path:
    # Join-Path $env:LOCALAPPDATA 'MyApp\Cache'
)

foreach ($path in $extraCleanupPaths) {
    if (Test-Path $path) {
        Write-Host "Deleting all contents in: $path"
        Get-ChildItem -Path $path -Force | Remove-Item -Recurse -Force
        Write-Host "✅ Cleared: $path"
    } else {
        Write-Host "❌ Path not found: $path"
    }
}

Write-Host "All cleanup tasks completed."
