# ⚡ Quick Installation Reference

**One-click installation commands for AmigoUK/dev-environment-installer**

## 🚀 One-Click Installation

### macOS
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh)"
```

### Windows (PowerShell as Administrator)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1'))
```

## 📥 Manual Download

### macOS
```bash
# Download
curl -fsSL https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/macos/dev-environment-setup.sh -o dev-setup.sh

# Make executable and run
chmod +x dev-setup.sh && ./dev-setup.sh
```

### Windows
```powershell
# Download
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AmigoUK/dev-environment-installer/main/windows/windows-dev-environment-setup.ps1" -OutFile "dev-setup.ps1"

# Run as Administrator
.\dev-setup.ps1
```

## 📋 What Gets Installed

- **Core Tools**: Git, GitHub Desktop, Node.js, Python, Package Managers
- **IDEs**: Android Studio, VS Code, Cursor Editor  
- **Mobile Dev**: Flutter SDK, Firebase CLI, Android SDK
- **AI Assistants**: Claude Code + 74 agents, Qwen Coder, GitHub Copilot
- **Local Development**: MAMP (Apache, MySQL, PHP)
- **Additional**: Docker, Databases (PostgreSQL, MySQL, Redis, MongoDB)
- **Platform Specific**: WSL2 + Ubuntu (Windows), Homebrew (macOS)

## 🎯 Installation Options

Both scripts offer:
1. **Full Installation** (Recommended)
2. **Core Tools Only**
3. **AI Assistants Only** 
4. **Mobile Development Only**
5. **Verify Installation**

## ⚡ Post-Installation Commands

```bash
# Verify everything works
flutter doctor                    # Check Flutter setup
claude                            # Start Claude Code
ollama run qwen2.5-coder:7b      # Run Qwen Coder
code .                           # Open VS Code

# Create your first Flutter app
flutter create my_awesome_app
cd my_awesome_app
flutter run
```

## 🔧 Requirements

- **macOS**: macOS 11+ (Intel or Apple Silicon)
- **Windows**: Windows 10 (2004+) or Windows 11
- **Admin privileges** required for installation
- **Internet connection** for downloads

---

**🌟 Star the repository if this helped you!**
**🐛 Report issues**: [GitHub Issues](https://github.com/AmigoUK/dev-environment-installer/issues)
**💬 Discussions**: [GitHub Discussions](https://github.com/AmigoUK/dev-environment-installer/discussions)