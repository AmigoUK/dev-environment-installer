@echo off
REM Windows Development Environment Setup Launcher
REM This batch file makes it easier to run the PowerShell script

echo ╔════════════════════════════════════════════════════════════════╗
echo ║              Windows Dev Environment Setup                     ║
echo ║                     Launcher v1.0                             ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ This script must be run as Administrator
    echo.
    echo Right-click this file and select "Run as Administrator"
    echo Or run Command Prompt as Administrator and execute this file
    pause
    exit /b 1
)

echo ✅ Running with Administrator privileges
echo.

REM Set execution policy for PowerShell
echo 🔧 Setting PowerShell execution policy...
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

REM Check if the PowerShell script exists
if not exist "%~dp0windows-dev-environment-setup.ps1" (
    echo ❌ PowerShell script not found: windows-dev-environment-setup.ps1
    echo.
    echo Please ensure the following files are in the same folder:
    echo   • install-dev-environment.bat ^(this file^)
    echo   • windows-dev-environment-setup.ps1
    echo   • README-windows-dev-setup.md
    pause
    exit /b 1
)

echo ✅ PowerShell script found
echo.

REM Launch the PowerShell script
echo 🚀 Launching Windows Development Environment Setup...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0windows-dev-environment-setup.ps1"

REM Check if PowerShell script completed successfully
if %errorLevel% neq 0 (
    echo.
    echo ⚠️  Setup completed with errors. Check the log file for details.
) else (
    echo.
    echo ✅ Setup completed successfully!
)

echo.
echo Press any key to exit...
pause >nul