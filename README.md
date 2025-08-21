# 🚀 Universal Development Environment Installer

**One-click installation scripts for complete mobile/web development environment on macOS and Windows**

[![macOS](https://img.shields.io/badge/macOS-Big%20Sur%2B-blue?logo=apple)](./macos/)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?logo=windows)](./windows/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.1-blue?logo=flutter)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)](https://python.org)
[![Claude](https://img.shields.io/badge/Claude-Code%20%2B%2074%20Agents-orange)](https://claude.ai)

## 🎯 Quick Install

### macOS Installation
```bash
# Download and run
curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh
```

### Windows Installation
**⚠️ Important: Use PowerShell as Administrator (NOT Command Prompt)**

1. **Right-click Start menu** → **"Windows PowerShell (Admin)"**
2. **Run this command:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1'))
```

## 📦 What Gets Installed

### 🔧 **Core Development Tools**
- **Git** - Version control system
- **GitHub Desktop** - Graphical Git interface
- **Node.js & npm** - Via NVM for version management  
- **Python 3.12** - Programming language with pip
- **Package Managers** - Homebrew (macOS) / Chocolatey (Windows)

### 🎨 **IDEs & Editors**
- **Android Studio** - Official Android IDE with SDK
- **Visual Studio Code** - With essential extensions
- **Cursor Editor** - AI-powered VS Code fork

### 📱 **Mobile Development Stack**
- **Flutter SDK 3.35.1** - Cross-platform UI toolkit
- **Android SDK** - Android development platform
- **Firebase CLI** - Backend services
- **Fastlane** - Deployment automation
- **Scrcpy** - Android device mirroring (macOS)

### 🤖 **AI Coding Assistants**
- **Claude Desktop App** - Anthropic's AI assistant
- **Claude Code CLI** - Command-line interface
- **74+ Specialized Agents** - Expert AI assistants for every task
- **Qwen Coder** - 7B parameter coding model via Ollama
- **GitHub Copilot** - AI pair programmer

### 🐳 **Additional Tools**
- **Docker Desktop** - Containerization
- **MAMP** - Local development server (Apache, MySQL, PHP)
- **Databases** - PostgreSQL, MySQL (via MAMP), Redis, MongoDB
- **WSL 2 + Ubuntu** - Linux environment (Windows only)

## 🖥️ Platform-Specific Features

| Feature | macOS | Windows |
|---------|-------|---------|
| **Flutter Development** | ✅ Native | ✅ Native |
| **iOS Development** | ✅ Xcode + CocoaPods | ❌ Not supported |
| **Android Development** | ✅ Full support | ✅ Full support |
| **Claude Code** | ✅ Native terminal | ✅ WSL + Git Bash |
| **Docker** | ✅ Native | ✅ WSL 2 backend |
| **Package Manager** | 🍺 Homebrew | 🍫 Chocolatey |
| **Linux Environment** | 🍎 macOS Terminal | 🐧 WSL 2 Ubuntu |

## 🚀 Getting Started

### Option 1: Quick One-Liner (Recommended)

**macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh)"
```

**Windows (PowerShell as Administrator):**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1'))
```

### Option 2: Manual Download

**macOS:**
```bash
# Download
curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh -o dev-setup.sh

# Make executable
chmod +x dev-setup.sh

# Run
./dev-setup.sh
```

**Windows:**
```powershell
# Download
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1" -OutFile "dev-setup.ps1"

# Run as Administrator
.\dev-setup.ps1
```

### Option 3: Clone Repository
```bash
git clone https://github.com/AmigoUK/dev-environment-installer.git
cd dev-environment-installer

# macOS
./macos/dev-environment-setup.sh

# Windows (as Administrator)
.\windows\windows-dev-environment-setup.ps1
```

## 🎛️ Installation Options

Both scripts offer flexible installation modes:

### macOS Options:
1. **Full Installation** (Recommended) - Everything
2. **Core Tools Only** - Essential development tools
3. **AI Assistants Only** - Claude Code + agents
4. **Mobile Development Tools Only** - Flutter stack
5. **Verify Existing Installation** - Check current setup

### Windows Options:
1. **Full Installation with WSL** (Recommended) - Everything + Linux
2. **Native Windows Installation Only** - Windows tools only
3. **WSL Development Environment Only** - Linux setup only
4. **AI Assistants Only** - Claude Code + agents
5. **Mobile Development Tools Only** - Flutter stack
6. **Verify Existing Installation** - Check current setup

## 🤖 Claude Code Setup

### macOS - Native Terminal Support
```bash
# After installation
claude
# Uses native macOS terminal
```

### Windows - Dual Support
```powershell
# Option 1: WSL (Recommended)
wsl
claude

# Option 2: Git Bash (Auto-configured)
# Uses: $env:CLAUDE_CODE_GIT_BASH_PATH
claude
```

## 🧠 AI Agents Collection

Both scripts install **74+ specialized AI agents** that work automatically with Claude Code:

| Category | Examples |
|----------|----------|
| **Architecture** | `architect`, `backend-architect`, `frontend-developer` |
| **Languages** | `python-pro`, `javascript-pro`, `rust-pro`, `golang-pro` |
| **Mobile** | `flutter-expert`, `ios-developer`, `react-native-pro` |
| **DevOps** | `deployment-engineer`, `terraform-specialist`, `docker-expert` |
| **Security** | `security-auditor`, `penetration-tester` |
| **Data** | `data-scientist`, `ml-engineer`, `database-optimizer` |

Simply describe what you want to do, and Claude Code automatically delegates to the appropriate specialist!

## 📱 Quick Commands After Installation

```bash
# Mobile Development
flutter create my_app          # Create new Flutter app
flutter run                   # Run on connected device
flutter doctor               # Check Flutter setup

# AI Assistants  
claude                        # Claude Code CLI
ollama run qwen2.5-coder:7b  # Qwen Coder
code .                       # VS Code with Claude extensions

# Development
git status                   # Check git status
npm init                     # Initialize Node.js project
python --version             # Check Python version

# GitHub and Local Development
github                       # Open GitHub Desktop
open /Applications/MAMP      # Start MAMP (macOS)

# Platform Specific
# macOS
scrcpy                       # Mirror Android device

# Windows  
wsl                         # Enter Linux environment
```

## 🔧 System Requirements

### macOS Requirements:
- **macOS 11 (Big Sur)** or later
- **Intel or Apple Silicon** Mac
- **Administrator privileges**
- **~10GB free space**

### Windows Requirements:
- **Windows 10 (2004+)** or **Windows 11**
- **Administrator privileges**
- **~15GB free space**
- **Virtualization support** (for WSL)

## ⚡ Post-Installation

### macOS:
```bash
# Restart terminal or reload profile
source ~/.zshrc

# Verify installation
flutter doctor
```

### Windows:
```powershell
# Restart computer (required)
# Then verify:
flutter doctor
wsl --list --verbose
```

## 🆘 Troubleshooting

### Common Issues:

**Permission Denied (macOS):**
```bash
chmod +x dev-setup.sh
```

**Execution Policy (Windows):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Flutter Doctor Issues:**
```bash
flutter doctor --android-licenses  # Accept Android licenses
flutter doctor -v                   # Verbose output
```

### Log Files:
- **macOS**: `~/dev-setup-YYYYMMDD-HHMMSS.log`
- **Windows**: `%USERPROFILE%\dev-setup-YYYYMMDD-HHMMSS.log`

## 📁 Repository Structure

```
dev-environment-installer/
├── README.md                    # This file
├── LICENSE                      # MIT License
├── macos/
│   └── dev-environment-setup.sh # macOS installer
├── windows/
│   ├── windows-dev-environment-setup.ps1  # Windows installer
│   └── install-dev-environment.bat        # Windows launcher
└── docs/
    ├── README-macos.md          # Detailed macOS docs
    └── README-windows.md        # Detailed Windows docs
```

## 🌟 Why Use These Scripts?

### ✅ **Benefits:**
- **One-Click Setup** - Complete environment in minutes
- **Cross-Platform** - Works on macOS and Windows
- **AI-First** - Claude Code with 74+ specialized agents
- **Mobile Ready** - Full Flutter development stack
- **Production Ready** - Used by professional developers
- **Extensible** - Easy to modify for your needs

### 🎯 **Perfect For:**
- **New Developers** - Get started without complexity
- **Team Onboarding** - Standardize development environments
- **Machine Migration** - Quickly setup new computers
- **Bootcamps** - Educational environments
- **Open Source Projects** - Consistent contributor setup

## 🤝 Contributing

We welcome contributions! Please:

1. **Fork the repository**
2. **Create a feature branch**
3. **Test on both platforms**
4. **Submit a pull request**

### Development Guidelines:
- Test on both Intel and Apple Silicon Macs
- Test on Windows 10 and Windows 11
- Include error handling and logging
- Update documentation

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- **Claude Code** by Anthropic
- **Flutter** by Google
- **AI Agents Collection** by [wshobson](https://github.com/wshobson/agents) - amazing collection! I love most of them!
- **Open Source Community** for all the amazing tools

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/AmigoUK/dev-environment-installer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/AmigoUK/dev-environment-installer/discussions)
- **Documentation**: [Wiki](https://github.com/AmigoUK/dev-environment-installer/wiki)

---

**🚀 Start your development journey with one command!**

```bash
# macOS
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh)"

# Windows (PowerShell as Admin)
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1'))
```
