# FullDiskCleanUp

## Why I Created This Project

### Background:
Over time, Windows systems gather a significant amount of temporary files, cached data, and system update leftovers that can lead to reduced disk space and slower performance. Regular disk cleanup is essential to maintain optimal system functionality.

### The Problem:
Manually using the Disk Cleanup tool (`cleanmgr`) can be tedious, especially when you need to repeatedly select the same cleanup options. Automating this process simplifies system maintenance and ensures it is done consistently.

---

## Overview

The **FullDiskCleanUp** script automates the Windows Disk Cleanup process by configuring and running the `cleanmgr` tool with predefined settings. This saves time and effort while ensuring that unwanted files are regularly removed.

---

## Disk Cleanup Component

### 1. Disk Cleanup Configuration
- The script uses the `cleanmgr` tool's built-in `/sageset` option to configure specific cleanup options. These options include:
    - Temporary files
    - Windows Update files
    - Recycle Bin contents
    - Internet cache and history
    - System error memory dump files

- It stores this configuration in the Windows registry for future use.

### 2. Running Disk Cleanup
- The script runs `cleanmgr` using the `/sagerun` option, which automatically cleans the selected files based on the stored settings.
- No manual intervention is required as the script initiates the cleanup and removes unnecessary data in the background.

### 3. Registry Cleanup
- After the disk cleanup process is complete, the script removes the custom cleanup configuration from the registry to avoid cluttering the system with multiple cleanup profiles.

---

## How to Use the Disk Cleanup Feature

1. **Download the Script**:
    - Clone the repository or download the latest version from the [Releases](https://github.com/hexagonal717/fulldiskcleanup/releases) section.
    - Extract the ZIP file to access the **FullDiskCleanUp** script.

2. **Run the `run_this.bat` file**:
    - Locate the `run_this.bat` file in the directory where you extracted or cloned the repository.
    - Double-click the `run_this.bat` file to execute it. This file will run the PowerShell script with the necessary permissions.
    - If Windows SmartScreen appears, warning you that the file might be unsafe, follow these steps to bypass it:
        - Click on **More info**.
        - Then click **Run anyway**.
        - The script will then execute with the necessary permissions.

3. **Automatic Cleanup**:
    - The script will configure the `cleanmgr` tool and run it with your selected options. There is no need for further manual input.

---

## License
This project is licensed under the MIT License - see the LICENSE file for details.
