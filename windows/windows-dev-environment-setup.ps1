#################################################################################################
# Windows Complete Development Environment Setup Script
# Version: 1.0.0
# Author: Development Environment Automation
# Description: One-click installation for complete development environment on Windows
#              Including: WSL, Android Studio, VS Code, Claude Code with agents,
#              Qwen Code, Flutter, and all essential development tools
#################################################################################################

#Requires -RunAsAdministrator

# Script configuration
$ScriptVersion = "1.0.0"
$LogFile = "$env:USERPROFILE\dev-setup-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$ErrorsFound = 0

# Color definitions
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Magenta = "Magenta"
    Cyan = "Cyan"
    White = "White"
}

#################################################################################################
# Helper Functions
#################################################################################################

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Blue
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Blue
    Write-Host ""
}

function Write-Step {
    param([string]$Text)
    Write-Host "▶ $Text" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Text)
    Write-Host "✅ $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "❌ $Text" -ForegroundColor Red
    $script:ErrorsFound++
    Add-Content -Path $LogFile -Value "[ERROR] $(Get-Date): $Text"
}

function Write-Info {
    param([string]$Text)
    Write-Host "ℹ️  $Text" -ForegroundColor Blue
}

function Write-Warning {
    param([string]$Text)
    Write-Host "⚠️  $Text" -ForegroundColor Yellow
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Add-ToPath {
    param([string]$Path)
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$Path*") {
        $newPath = "$currentPath;$Path"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Success "Added $Path to PATH"
    }
}

function Write-Log {
    param([string]$Message)
    Add-Content -Path $LogFile -Value "[$(Get-Date)] $Message"
}

#################################################################################################
# System Checks
#################################################################################################

function Test-WindowsVersion {
    Write-Header "Checking Windows Version"
    
    $version = [System.Environment]::OSVersion.Version
    $build = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    
    Write-Step "Detecting Windows version..."
    
    if ($version.Major -lt 10) {
        Write-Error "This script requires Windows 10 or later. Current version: $($version.Major).$($version.Minor)"
        exit 1
    }
    
    Write-Success "Windows 10/11 detected (Build: $build)"
    
    # Check for WSL support
    if ($version.Build -ge 16299) {
        Write-Success "WSL support available"
        return $true
    } else {
        Write-Warning "WSL may not be fully supported on this build"
        return $false
    }
}

function Test-AdminRights {
    Write-Header "Checking Administrator Rights"
    
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Success "Running with Administrator privileges"
        return $true
    } else {
        Write-Error "This script must be run as Administrator"
        Write-Info "Right-click PowerShell and select 'Run as Administrator'"
        exit 1
    }
}

#################################################################################################
# Package Manager Installation
#################################################################################################

function Install-Chocolatey {
    Write-Header "Installing Chocolatey Package Manager"
    
    if (Test-Command "choco") {
        Write-Success "Chocolatey already installed"
        choco upgrade chocolatey -y
    } else {
        Write-Step "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        refreshenv
        Write-Success "Chocolatey installed"
    }
}


#################################################################################################
# WSL Setup
#################################################################################################

function Install-WSL {
    Write-Header "Installing Windows Subsystem for Linux (WSL)"
    
    Write-Step "Checking WSL status..."
    
    try {
        $wslStatus = wsl --status 2>$null
        if ($wslStatus) {
            Write-Success "WSL already installed"
            return
        }
    }
    catch {
        # WSL not installed, continue with installation
    }
    
    Write-Step "Enabling WSL feature..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    
    Write-Step "Enabling Virtual Machine Platform..."
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    
    Write-Step "Installing WSL 2..."
    wsl --install --no-distribution
    
    Write-Step "Setting WSL 2 as default..."
    wsl --set-default-version 2
    
    Write-Success "WSL 2 installed successfully"
    Write-Info "A restart may be required to complete WSL installation"
}

function Install-Ubuntu {
    Write-Header "Installing Ubuntu on WSL"
    
    Write-Step "Checking for existing Ubuntu installation..."
    
    $distributions = wsl --list --quiet
    if ($distributions -contains "Ubuntu") {
        Write-Success "Ubuntu already installed on WSL"
        return
    }
    
    Write-Step "Installing Ubuntu from Microsoft Store..."
    try {
        choco install wsl-ubuntu-2204 --yes
        Write-Success "Ubuntu 22.04 LTS installed"
    }
    catch {
        Write-Step "Fallback: Installing Ubuntu via WSL command..."
        wsl --install --distribution Ubuntu
    }
    
    Write-Info "Please complete Ubuntu setup by running: wsl"
    Write-Info "Create a username and password when prompted"
}

#################################################################################################
# Development Tools Installation
#################################################################################################

function Install-Git {
    Write-Header "Installing Git for Windows"
    
    if (Test-Command "git") {
        Write-Success "Git already installed: $(git --version)"
    } else {
        Write-Step "Installing Git for Windows..."
        choco install git --yes
        refreshenv
        Write-Success "Git for Windows installed"
    }
    
    # Set Git Bash path for Claude Code
    $gitBashPath = "${env:ProgramFiles}\Git\bin\bash.exe"
    if (Test-Path $gitBashPath) {
        [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", $gitBashPath, "User")
        Write-Success "Git Bash path configured for Claude Code"
    }
}

function Install-NodeJS {
    Write-Header "Installing Node.js via NVM"
    
    # Install NVM for Windows first
    Write-Step "Installing NVM for Windows..."
    if (-not (Test-Path "$env:APPDATA\nvm")) {
        choco install nvm --yes
        refreshenv
        Write-Success "NVM for Windows installed"
    }
    
    # Install Node.js LTS via NVM
    if (-not (Test-Command "node")) {
        Write-Step "Installing Node.js LTS via NVM..."
        nvm install lts
        nvm use lts
        refreshenv
        Write-Success "Node.js LTS installed via NVM: $(node --version)"
    } else {
        Write-Success "Node.js already installed: $(node --version)"
    }
}

function Install-Python {
    Write-Header "Installing Python"
    
    if (Test-Command "python") {
        Write-Success "Python already installed: $(python --version)"
    } else {
        Write-Step "Installing Python 3.12..."
        choco install python312 --yes
        refreshenv
        Write-Success "Python installed"
    }
    
    Write-Step "Installing essential Python packages..."
    python -m pip install --upgrade pip
    pip install requests numpy pandas jupyter
}

function Install-AndroidStudio {
    Write-Header "Installing Android Studio"
    
    if (Test-Path "${env:ProgramFiles}\Android\Android Studio") {
        Write-Success "Android Studio already installed"
    } else {
        Write-Step "Installing Android Studio..."
        choco install androidstudio --yes
        Write-Success "Android Studio installed"
    }
    
    # Set Android environment variables
    Write-Step "Setting up Android SDK environment variables..."
    $androidHome = "$env:LOCALAPPDATA\Android\Sdk"
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidHome, "User")
    [Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $androidHome, "User")
    
    Add-ToPath "$androidHome\platform-tools"
    Add-ToPath "$androidHome\cmdline-tools\latest\bin"
    
    Write-Success "Android environment variables configured"
}

function Install-VSCode {
    Write-Header "Installing Visual Studio Code"
    
    if (Test-Command "code") {
        Write-Success "VS Code already installed"
    } else {
        Write-Step "Installing VS Code..."
        choco install vscode --yes
        refreshenv
        Write-Success "VS Code installed"
    }
    
    Write-Step "Installing VS Code extensions..."
    $extensions = @(
        "Dart-Code.dart-code",
        "Dart-Code.flutter",
        "ms-python.python",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "eamodio.gitlens",
        "ms-vscode-remote.remote-wsl"
    )
    
    foreach ($extension in $extensions) {
        Write-Step "Installing extension: $extension"
        code --install-extension $extension --force
    }
    
    Write-Success "VS Code extensions installed"
}

function Install-Flutter {
    Write-Header "Installing Flutter SDK"
    
    if (Test-Command "flutter") {
        Write-Success "Flutter already installed: $(flutter --version | Select-Object -First 1)"
    } else {
        Write-Step "Installing Flutter..."
        
        # Create Flutter directory
        $flutterPath = "$env:USERPROFILE\flutter"
        if (-not (Test-Path $flutterPath)) {
            New-Item -ItemType Directory -Path $flutterPath -Force
        }
        
        # Download and extract Flutter
        $flutterZip = "$env:TEMP\flutter_windows_stable.zip"
        $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.35.1-stable.zip"
        
        Write-Step "Downloading Flutter SDK..."
        Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip
        
        Write-Step "Extracting Flutter SDK..."
        Expand-Archive -Path $flutterZip -DestinationPath $env:USERPROFILE -Force
        
        Add-ToPath "$flutterPath\bin"
        refreshenv
        
        Write-Success "Flutter SDK installed"
    }
    
    Write-Step "Accepting Android licenses..."
    Start-Process -FilePath "flutter" -ArgumentList "doctor --android-licenses" -Wait -NoNewWindow
}

#################################################################################################
# AI Coding Assistants
#################################################################################################

function Install-ClaudeCode {
    Write-Header "Installing Claude Code"
    
    Write-Step "Installing Claude Desktop app..."
    if (-not (Get-AppxPackage | Where-Object {$_.Name -like "*Claude*"})) {
        Write-Info "Please download and install Claude Desktop manually from https://claude.ai/download"
        Write-Info "Claude Desktop is not available via Chocolatey"
    }
    
    Write-Step "Installing Claude Code CLI..."
    if (Test-Command "node") {
        # Install via npm if available
        npm install -g @anthropic-ai/claude-code
        Write-Success "Claude Code CLI installed via npm"
    } else {
        # Manual installation
        $claudeDir = "$env:USERPROFILE\.claude"
        if (-not (Test-Path $claudeDir)) {
            New-Item -ItemType Directory -Path $claudeDir -Force
        }
        
        Write-Info "Please install Node.js first, then run: npm install -g @anthropic-ai/claude-code"
    }
}

function Install-ClaudeAgents {
    Write-Header "Installing Claude Code Subagents Collection"
    
    $claudeDir = "$env:USERPROFILE\.claude"
    $agentsDir = "$claudeDir\agents"
    
    Write-Step "Installing 74+ specialized agents from wshobson/agents..."
    
    if (Test-Path $agentsDir) {
        Write-Step "Updating existing agents..."
        Set-Location $agentsDir
        git pull origin main
    } else {
        Write-Step "Cloning agents repository..."
        if (-not (Test-Path $claudeDir)) {
            New-Item -ItemType Directory -Path $claudeDir -Force
        }
        Set-Location $claudeDir
        git clone https://github.com/wshobson/agents.git
    }
    
    Write-Success "Claude agents installed successfully"
    Write-Info "Available agent categories:"
    Write-Host "  - Development and Architecture agents" -ForegroundColor Gray
    Write-Host "  - Language-specific specialists (Python, JS, Go, Rust, etc.)" -ForegroundColor Gray
    Write-Host "  - Infrastructure and DevOps agents" -ForegroundColor Gray
    Write-Host "  - Security and Quality agents" -ForegroundColor Gray
    Write-Host "  - Data Science and AI agents" -ForegroundColor Gray
    Write-Host "  - Business and Marketing agents" -ForegroundColor Gray
}

function Install-QwenCode {
    Write-Header "Installing Qwen Coder via Ollama"
    
    Write-Step "Installing Ollama for Windows..."
    if (-not (Test-Command "ollama")) {
        $ollamaUrl = "https://ollama.ai/download/OllamaSetup.exe"
        $ollamaInstaller = "$env:TEMP\OllamaSetup.exe"
        Invoke-WebRequest -Uri $ollamaUrl -OutFile $ollamaInstaller
        Start-Process -FilePath $ollamaInstaller -ArgumentList "/S" -Wait
        refreshenv
        Write-Success "Ollama installed"
    }
    
    Write-Step "Pulling Qwen2.5-Coder model..."
    Start-Process -FilePath "ollama" -ArgumentList "pull qwen2.5-coder:7b" -Wait -NoNewWindow
    
    Write-Success "Qwen Coder installed via Ollama"
    Write-Info "Access Qwen: ollama run qwen2.5-coder:7b"
}

function Install-GitHubCopilot {
    Write-Header "Installing GitHub Copilot"
    
    if (Test-Command "code") {
        Write-Step "Installing GitHub Copilot VS Code extensions..."
        code --install-extension GitHub.copilot --force
        code --install-extension GitHub.copilot-chat --force
        Write-Success "GitHub Copilot extensions installed"
        Write-Info "Note: GitHub Copilot requires a subscription. Sign in through VS Code."
    } else {
        Write-Warning "VS Code not found. Install VS Code first to use GitHub Copilot."
    }
}

function Install-Cursor {
    Write-Header "Installing Cursor Editor"
    
    if (Test-Path "${env:LOCALAPPDATA}\Programs\Cursor") {
        Write-Success "Cursor already installed"
    } else {
        Write-Step "Installing Cursor Editor..."
        try {
            choco install cursor --yes
            Write-Success "Cursor Editor installed"
        }
        catch {
            Write-Info "Please install Cursor manually from https://cursor.sh/"
        }
    }
}

#################################################################################################
# Additional Tools
#################################################################################################

function Install-Docker {
    Write-Header "Installing Docker Desktop"
    
    if (Test-Command "docker") {
        Write-Success "Docker already installed"
    } else {
        Write-Step "Installing Docker Desktop..."
        choco install docker-desktop --yes
        Write-Success "Docker Desktop installed"
        Write-Info "Docker Desktop requires a restart to complete installation"
    }
}

function Install-DatabaseTools {
    Write-Header "Installing Database Tools"
    
    Write-Step "Installing PostgreSQL..."
    choco install postgresql --yes
    
    Write-Step "Installing MAMP (Apache MySQL PHP)..."
    choco install mamp --yes
    
    Write-Step "Installing Redis..."
    choco install redis-64 --yes
    
    Write-Step "Installing MongoDB..."
    choco install mongodb --yes
    
    Write-Success "Database tools installed"
}

function Install-MobileDevTools {
    Write-Header "Installing Mobile Development Tools"
    
    Write-Step "Installing ADB and Fastboot..."
    choco install adb --yes
    
    Write-Step "Installing Firebase CLI..."
    npm install -g firebase-tools
    
    Write-Step "Installing FVM (Flutter Version Manager)..."
    choco install fvm --yes
    
    Write-Success "Mobile development tools installed"
}

#################################################################################################
# WSL Development Setup
#################################################################################################

function Setup-WSLDevelopment {
    Write-Header "Setting up Development Environment in WSL"
    
    Write-Step "Installing development tools in Ubuntu WSL..."
    
    $wslCommands = @(
        "sudo apt update",
        "sudo apt upgrade -y",
        "sudo apt install -y curl git build-essential",
        "curl -sSL https://install.python-poetry.org | python3 -",
        "sudo snap install flutter --classic",
        "git clone https://github.com/wshobson/agents.git ~/.claude/agents"
    )
    
    foreach ($command in $wslCommands) {
        Write-Step "Running in WSL: $command"
        wsl -d Ubuntu -- bash -c $command
    }
    
    Write-Success "WSL development environment configured"
}

#################################################################################################
# Configuration and Verification
#################################################################################################

function Set-GitConfig {
    Write-Header "Configuring Git"
    
    Write-Step "Setting up Git configuration..."
    
    $gitUser = Read-Host "Enter your Git username"
    $gitEmail = Read-Host "Enter your Git email"
    
    git config --global user.name "$gitUser"
    git config --global user.email "$gitEmail"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    
    Write-Success "Git configured"
}

function Test-Installations {
    Write-Header "Verifying Installations"
    
    Write-Host "`nDevelopment Environment Status:`n" -ForegroundColor White
    
    # Core Tools
    Write-Host "Core Tools:" -ForegroundColor Cyan
    if (Test-Command "git") { Write-Host "  ✅ Git: $(git --version)" -ForegroundColor Green } else { Write-Host "  ❌ Git: Not installed" -ForegroundColor Red }
    if (Test-Command "node") { Write-Host "  ✅ Node.js: $(node --version)" -ForegroundColor Green } else { Write-Host "  ❌ Node.js: Not installed" -ForegroundColor Red }
    if (Test-Command "python") { Write-Host "  ✅ Python: $(python --version)" -ForegroundColor Green } else { Write-Host "  ❌ Python: Not installed" -ForegroundColor Red }
    if (Test-Command "choco") { Write-Host "  ✅ Chocolatey: $(choco --version)" -ForegroundColor Green } else { Write-Host "  ❌ Chocolatey: Not installed" -ForegroundColor Red }
    
    # WSL
    Write-Host "`nWSL Environment:" -ForegroundColor Cyan
    try {
        $wslStatus = wsl --status 2>$null
        if ($wslStatus) { Write-Host "  ✅ WSL: Available" -ForegroundColor Green } else { Write-Host "  ❌ WSL: Not installed" -ForegroundColor Red }
    } catch { Write-Host "  ❌ WSL: Not installed" -ForegroundColor Red }
    
    # IDEs
    Write-Host "`nIDEs and Editors:" -ForegroundColor Cyan
    if (Test-Path "${env:ProgramFiles}\Android\Android Studio") { Write-Host "  ✅ Android Studio: Installed" -ForegroundColor Green } else { Write-Host "  ❌ Android Studio: Not installed" -ForegroundColor Red }
    if (Test-Command "code") { Write-Host "  ✅ VS Code: Installed" -ForegroundColor Green } else { Write-Host "  ❌ VS Code: Not installed" -ForegroundColor Red }
    if (Test-Path "${env:LOCALAPPDATA}\Programs\Cursor") { Write-Host "  ✅ Cursor: Installed" -ForegroundColor Green } else { Write-Host "  ❌ Cursor: Not installed" -ForegroundColor Red }
    
    # Mobile Development
    Write-Host "`nMobile Development:" -ForegroundColor Cyan
    if (Test-Command "flutter") { Write-Host "  ✅ Flutter: $(flutter --version | Select-Object -First 1)" -ForegroundColor Green } else { Write-Host "  ❌ Flutter: Not installed" -ForegroundColor Red }
    if (Test-Command "firebase") { Write-Host "  ✅ Firebase CLI: Installed" -ForegroundColor Green } else { Write-Host "  ❌ Firebase: Not installed" -ForegroundColor Red }
    
    # AI Assistants
    Write-Host "`nAI Coding Assistants:" -ForegroundColor Cyan
    if (Test-Path "$env:USERPROFILE\.claude\agents") { Write-Host "  ✅ Claude Agents: Installed" -ForegroundColor Green } else { Write-Host "  ❌ Claude Agents: Not installed" -ForegroundColor Red }
    if (Test-Command "ollama") { Write-Host "  ✅ Ollama (Qwen): Installed" -ForegroundColor Green } else { Write-Host "  ❌ Ollama: Not installed" -ForegroundColor Red }
    
    # Additional Tools
    Write-Host "`nAdditional Tools:" -ForegroundColor Cyan
    if (Test-Command "docker") { Write-Host "  ✅ Docker Desktop: Installed" -ForegroundColor Green } else { Write-Host "  ❌ Docker: Not installed" -ForegroundColor Red }
    if (Test-Path "${env:ProgramFiles(x86)}\MAMP") { Write-Host "  ✅ MAMP: Installed" -ForegroundColor Green } else { Write-Host "  ❌ MAMP: Not installed" -ForegroundColor Red }
}

function New-TestProject {
    Write-Header "Creating Test Flutter Project"
    
    Write-Step "Creating test project to verify setup..."
    
    $testDir = "$env:USERPROFILE\flutter_test_project"
    if (-not (Test-Path $testDir)) {
        flutter create $testDir
        Set-Location $testDir
        flutter pub get
        Write-Success "Test project created at $testDir"
    } else {
        Write-Info "Test project already exists at $testDir"
    }
}

#################################################################################################
# Main Installation Flow
#################################################################################################

function Show-MainMenu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║    Windows Complete Development Environment Installer v$ScriptVersion    ║" -ForegroundColor Magenta
    Write-Host "║                                                                ║" -ForegroundColor Magenta
    Write-Host "║  This script will install:                                    ║" -ForegroundColor Magenta
    Write-Host "║  - WSL 2 with Ubuntu for Linux development                    ║" -ForegroundColor Magenta
    Write-Host "║  - Core development tools (Git, Node.js, Python)              ║" -ForegroundColor Magenta
    Write-Host "║  - Android Studio and Flutter SDK                             ║" -ForegroundColor Magenta
    Write-Host "║  - VS Code and Cursor Editor                                  ║" -ForegroundColor Magenta
    Write-Host "║  - Claude Code with 74+ specialized agents                    ║" -ForegroundColor Magenta
    Write-Host "║  - Qwen Coder and GitHub Copilot                             ║" -ForegroundColor Magenta
    Write-Host "║  - Docker, databases, and mobile dev tools                    ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
    
    Write-Host "`nInstallation Options:" -ForegroundColor Yellow
    Write-Host "  1) Full Installation with WSL (Recommended)"
    Write-Host "  2) Native Windows Installation Only"
    Write-Host "  3) WSL Development Environment Only"
    Write-Host "  4) AI Assistants Only"
    Write-Host "  5) Mobile Development Tools Only"
    Write-Host "  6) Verify Existing Installation"
    Write-Host "  7) Exit"
    Write-Host ""
    
    $choice = Read-Host "Select option (1-7)"
    
    switch ($choice) {
        "1" { Invoke-FullInstallation }
        "2" { Invoke-NativeWindowsInstallation }
        "3" { Invoke-WSLInstallation }
        "4" { Invoke-AIAssistantsInstallation }
        "5" { Invoke-MobileToolsInstallation }
        "6" { Test-Installations }
        "7" { Write-Host "Exiting..."; exit 0 }
        default { Write-Host "Invalid option. Please try again."; Start-Sleep 2; Show-MainMenu }
    }
}

function Invoke-FullInstallation {
    Write-Header "Starting Full Installation"
    
    # System checks
    Test-WindowsVersion
    Test-AdminRights
    
    # Package managers
    Install-Chocolatey
    
    # WSL setup
    Install-WSL
    Install-Ubuntu
    
    # Core tools
    Install-Git
    Install-NodeJS
    Install-Python
    
    # IDEs
    Install-AndroidStudio
    Install-VSCode
    Install-Cursor
    
    # Mobile development
    Install-Flutter
    Install-MobileDevTools
    
    # AI Assistants
    Install-ClaudeCode
    Install-ClaudeAgents
    Install-QwenCode
    Install-GitHubCopilot
    
    # Additional tools
    Install-Docker
    Install-DatabaseTools
    
    # WSL development environment
    Setup-WSLDevelopment
    
    # Configuration
    Set-GitConfig
    
    # Testing
    New-TestProject
    Test-Installations
    
    Show-CompletionMessage
}

function Invoke-NativeWindowsInstallation {
    Write-Header "Installing Native Windows Development Environment"
    
    Test-WindowsVersion
    Test-AdminRights
    Install-Chocolatey
    Install-Git
    Install-NodeJS
    Install-Python
    Install-AndroidStudio
    Install-VSCode
    Install-Flutter
    Install-ClaudeCode
    Install-ClaudeAgents
    Set-GitConfig
    Test-Installations
}

function Invoke-WSLInstallation {
    Write-Header "Installing WSL Development Environment"
    
    Test-WindowsVersion
    Test-AdminRights
    Install-WSL
    Install-Ubuntu
    Setup-WSLDevelopment
    Test-Installations
}

function Invoke-AIAssistantsInstallation {
    Write-Header "Installing AI Coding Assistants"
    
    Test-AdminRights
    Install-Git
    Install-NodeJS
    Install-ClaudeCode
    Install-ClaudeAgents
    Install-QwenCode
    Install-GitHubCopilot
    Install-Cursor
    Test-Installations
}

function Invoke-MobileToolsInstallation {
    Write-Header "Installing Mobile Development Tools"
    
    Test-WindowsVersion
    Test-AdminRights
    Install-Chocolatey
    Install-AndroidStudio
    Install-Flutter
    Install-MobileDevTools
    New-TestProject
    Test-Installations
}

function Show-CompletionMessage {
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "     🎉 Installation Complete! 🎉" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Green
    
    if ($ErrorsFound -gt 0) {
        Write-Warning "Installation completed with $ErrorsFound errors. Check log: $LogFile"
    } else {
        Write-Success "All components installed successfully!"
    }
    
    Write-Host "`nNext Steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart your computer to complete installations"
    Write-Host "  2. Open Android Studio to complete SDK setup"
    Write-Host "  3. Run 'flutter doctor' to verify Flutter setup"
    Write-Host "  4. Set up WSL Ubuntu environment: wsl"
    Write-Host "  5. Sign in to Claude Desktop app"
    Write-Host "  6. Configure GitHub Copilot in VS Code"
    
    Write-Host "`nQuick Commands:" -ForegroundColor Cyan
    Write-Host "  - Start coding (Windows):  code ."
    Write-Host "  - Start coding (WSL):      wsl code ."
    Write-Host "  - Use Claude Code:         claude"
    Write-Host "  - Run Qwen Coder:          ollama run qwen2.5-coder:7b"
    Write-Host "  - Create Flutter app:      flutter create my_app"
    Write-Host "  - Open WSL:                wsl"
    
    Write-Host "`nClaude Code Setup Options:" -ForegroundColor Cyan
    Write-Host "  - WSL: Use 'wsl' command to access Linux environment"
    Write-Host "  - Git Bash: Configured at $env:CLAUDE_CODE_GIT_BASH_PATH"
    
    Write-Host "`nInstallation log saved to: $LogFile" -ForegroundColor Blue
}

#################################################################################################
# Script Entry Point
#################################################################################################

# Initialize logging
Write-Log "Starting Windows development environment setup - Version $ScriptVersion"
Write-Log "System: $(Get-ComputerInfo | Select-Object -ExpandProperty WindowsProductName)"

# Show main menu
Show-MainMenu
