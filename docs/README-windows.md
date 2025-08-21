# Windows Complete Development Environment Setup

🚀 **One-click PowerShell script for complete mobile/web development environment on Windows**

## What it installs

### 🖥️ Windows-Specific Setup
- **WSL 2** - Windows Subsystem for Linux
- **Ubuntu 22.04 LTS** - Linux distribution in WSL
- **Chocolatey** - Package manager for Windows
- **Windows Package Manager (winget)** - Microsoft's official package manager

### 🔧 Core Development Tools
- **Git for Windows** - Version control with Git Bash support
- **Node.js & npm** - JavaScript runtime and package manager
- **NVM for Windows** - Node Version Manager
- **Python 3.12** - Programming language with pip

### 🎨 IDEs & Editors
- **Android Studio** - Official Android IDE with SDK
- **Visual Studio Code** - Microsoft's code editor with extensions:
  - Flutter & Dart
  - Python
  - GitLens
  - Remote WSL
  - Prettier & ESLint
- **Cursor Editor** - AI-powered VS Code fork

### 📱 Mobile Development
- **Flutter SDK** - Google's UI toolkit (Windows version)
- **Android SDK** - Android development platform
- **ADB & Fastboot** - Android debugging tools
- **Firebase CLI** - Google's backend platform
- **FVM** - Flutter Version Manager

### 🤖 AI Coding Assistants
- **Claude Desktop App** - Anthropic's AI assistant
- **Claude Code CLI** - Command-line interface (npm package)
- **74+ Specialized Agents** - From [wshobson/agents](https://github.com/wshobson/agents)
- **Qwen Coder** - Via Ollama (7B parameter model)
- **GitHub Copilot** - AI pair programmer (requires subscription)

### 🐳 Additional Tools
- **Docker Desktop** - Containerization platform
- **PostgreSQL** - Relational database
- **MySQL** - Popular database system
- **Redis** - In-memory data store
- **MongoDB** - NoSQL database

## Claude Code Setup Options

The script supports both recommended Claude Code setups for Windows:

### Option 1: Claude Code within WSL ✅ **Recommended**
- Full Linux development environment
- Better package management
- Native Unix tools
- Supports both WSL 1 and WSL 2

### Option 2: Claude Code on Native Windows with Git Bash
- Uses Git for Windows bash environment
- Automatically configures: `$env:CLAUDE_CODE_GIT_BASH_PATH`
- Portable Git installations supported

## System Requirements

- **Windows 10 version 2004** or later (Build 19041+)
- **Windows 11** (any version)
- **Administrator privileges** required
- **Internet connection** for downloads
- **~15GB free disk space** for full installation
- **Virtualization support** for WSL 2 (usually enabled by default)

## Quick Start

### Method 1: Download and Run (Recommended)

1. **Download the script:**
   ```powershell
   # Download to your Downloads folder
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/windows-dev-setup/main/windows-dev-environment-setup.ps1" -OutFile "$env:USERPROFILE\Downloads\windows-dev-setup.ps1"
   ```

2. **Run as Administrator:**
   ```powershell
   # Right-click PowerShell and select "Run as Administrator"
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   cd $env:USERPROFILE\Downloads
   .\windows-dev-setup.ps1
   ```

### Method 2: One-liner Installation
```powershell
# Run as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/yourusername/windows-dev-setup/main/windows-dev-environment-setup.ps1'))
```

### Method 3: Manual Download
1. Download `windows-dev-environment-setup.ps1`
2. Right-click PowerShell → "Run as Administrator"
3. Navigate to download location
4. Run: `.\windows-dev-environment-setup.ps1`

## Installation Options

The script provides several installation modes:

1. **Full Installation with WSL** (Recommended) - Everything including Linux environment
2. **Native Windows Installation Only** - Windows tools only, no WSL
3. **WSL Development Environment Only** - Just Linux setup
4. **AI Assistants Only** - Claude Code, agents, and Qwen Coder
5. **Mobile Development Tools Only** - Flutter, Android Studio, mobile tools
6. **Verify Existing Installation** - Check what's already installed
7. **Exit** - Quit the installer

## What happens during installation?

### Full Installation Flow:
1. **System Checks** - Verifies Windows version and admin rights
2. **Package Managers** - Installs Chocolatey and winget
3. **WSL Setup** - Installs WSL 2 and Ubuntu 22.04 LTS
4. **Core Tools** - Installs Git, Node.js, Python
5. **IDEs** - Sets up Android Studio, VS Code, Cursor with extensions
6. **Mobile Dev** - Configures Flutter, Android SDK, mobile tools
7. **AI Assistants** - Installs Claude Code with 74+ agents, Qwen Coder
8. **Additional Tools** - Sets up Docker, databases
9. **WSL Environment** - Configures Linux development tools
10. **Configuration** - Sets up Git, environment variables
11. **Verification** - Tests installations and creates sample project

## Post-Installation Steps

After running the script:

1. **Restart your computer** (required for WSL and some installations)
2. **Set up Ubuntu in WSL:**
   ```powershell
   wsl
   # Create username and password when prompted
   ```
3. **Open Android Studio** to complete SDK setup
4. **Run Flutter Doctor:**
   ```powershell
   flutter doctor
   ```
5. **Sign in to Claude Desktop app**
6. **Configure GitHub Copilot** in VS Code (requires subscription)

## Quick Commands

After installation and restart:

```powershell
# Code editing
code .                              # Open VS Code (Windows)
wsl code .                         # Open VS Code (WSL)
cursor .                           # Open Cursor Editor

# AI Assistants
claude                             # Use Claude Code CLI
ollama run qwen2.5-coder:7b       # Run Qwen Coder

# Mobile Development  
flutter create my_app              # Create Flutter app
flutter run                       # Run Flutter app
flutter doctor                    # Check Flutter setup

# WSL Commands
wsl                               # Enter WSL Ubuntu environment
wsl --list --verbose             # List WSL distributions
wsl --set-default Ubuntu         # Set default WSL distro

# Version Management
nvm list                          # List Node.js versions (Windows)
fvm list                          # List Flutter versions
```

## Claude Code Usage

### WSL Usage (Recommended):
```bash
# In WSL terminal
cd /mnt/c/Users/YourName/projects
claude
```

### Git Bash Usage:
```powershell
# In Git Bash or PowerShell
# Environment variable automatically set: CLAUDE_CODE_GIT_BASH_PATH
claude
```

## Claude Agents Usage

The script installs 74+ specialized agents available automatically:

- **Architecture**: `architect`, `backend-architect`, `frontend-developer`
- **Language Specialists**: `python-pro`, `javascript-pro`, `csharp-pro`, `rust-pro`
- **Mobile Experts**: `flutter-expert`, `react-native-pro`, `mobile-developer`
- **DevOps**: `deployment-engineer`, `terraform-specialist`, `docker-expert`
- **Security**: `security-auditor`, `penetration-tester`
- **Data**: `data-scientist`, `ml-engineer`, `database-optimizer`

## Troubleshooting

### Common Issues

**"Execution Policy" Error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"Not running as Administrator":**
- Right-click PowerShell
- Select "Run as Administrator"
- Re-run the script

**WSL Installation Issues:**
```powershell
# Check WSL status
wsl --status

# Manual WSL installation
wsl --install

# Update WSL
wsl --update
```

**Flutter Doctor Issues:**
```powershell
# Accept Android licenses
flutter doctor --android-licenses

# Verbose output for debugging
flutter doctor -v
```

**Android SDK Issues:**
- Check environment variables:
  ```powershell
  $env:ANDROID_HOME
  $env:ANDROID_SDK_ROOT
  ```
- Restart PowerShell after installation

### Log Files

The script creates detailed logs at:
```
%USERPROFILE%\dev-setup-YYYYMMDD-HHMMSS.log
```

### Manual Cleanup

If you need to start fresh:
```powershell
# Uninstall WSL
wsl --unregister Ubuntu

# Remove Chocolatey
Remove-Item -Recurse -Force "$env:ChocolateyInstall"

# Reset PATH if needed
# (Restart PowerShell or reboot)
```

## Development Workflows

### WSL Development (Recommended):
```bash
# Start WSL
wsl

# Navigate to Windows files
cd /mnt/c/Users/YourName/projects

# Use Linux tools
code .                    # VS Code with WSL extension
flutter create my_app     # Flutter in Linux
npm install              # Node.js packages
```

### Native Windows Development:
```powershell
# Use Windows tools directly
code .
flutter create my_app
npm install

# With Git Bash for Claude Code
# (Automatically configured)
```

## Performance Tips

1. **Use WSL 2** for better performance than WSL 1
2. **Store projects in WSL filesystem** (`~/projects`) for faster file access
3. **Use VS Code Remote WSL extension** for seamless development
4. **Configure Windows Defender exclusions** for development folders

## Security Considerations

- Script requires Administrator privileges for system-level installations
- All downloads use HTTPS and official sources
- WSL provides isolated Linux environment
- Consider enabling Windows Developer Mode for easier development

## License

MIT License - Feel free to modify and distribute.

## Contributing

Pull requests welcome! Please test on both Windows 10 and Windows 11.

## Support

For issues:
1. Check the log file for detailed error messages
2. Run verification: Select option 6 from the menu
3. Check Windows version compatibility
4. Ensure running as Administrator

---

**Happy Coding on Windows! 🎉**