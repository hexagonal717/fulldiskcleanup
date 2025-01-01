# Function to check if the script is running as Administrator
function Test-IsAdministrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if the script is running as Administrator
if (-not (Test-IsAdministrator)) {
    Write-Host "This script needs to be run as an Administrator."
    Write-Host "Trying to restart with elevated privileges..."
    Start-Process powershell -ArgumentList "$($MyInvocation.MyCommand.Definition)" -Verb RunAs
    exit
}

# Define the sageset number and format it with leading zeros
$sagesetNumber = 500
$formattedNumber = $sagesetNumber.ToString("D4")  # Formats the number as four digits
$stateFlagsName = "StateFlags$formattedNumber"

# Define the path to the registry key for VolumeCaches
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"

# Define the list of specific cleanup options to modify
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

# Set the StateFlags DWORD value for the specified sageset number
foreach ($option in $cleanupOptions) {
    $optionPath = "$regPath\$option"
    if (Test-Path $optionPath) {
        # Set the StateFlags DWORD for the formatted sageset number
        Set-ItemProperty -Path $optionPath -Name $stateFlagsName -Value 2
    } else {
        Write-Host "Registry path not found for option: $option"
    }
}

# Run the cleanmgr command with the specified sageset number
try {
    Start-Process cleanmgr -ArgumentList "/sagerun:$sagesetNumber" -Wait -NoNewWindow
    Write-Host "cleanmgr /sagerun:$sagesetNumber has been executed."
} catch {
    Write-Host "Failed to run cleanmgr. Error: $_"
}

# Remove the StateFlags DWORD value for the specified sageset number
foreach ($option in $cleanupOptions) {
    $optionPath = "$regPath\$option"
    if (Test-Path $optionPath) {
        # Remove the StateFlags DWORD if it exists
        Remove-ItemProperty -Path $optionPath -Name $stateFlagsName -ErrorAction SilentlyContinue
    }
}

Write-Host "StateFlags values for sageset number $sagesetNumber have been removed for specified cleanup options."