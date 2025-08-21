# macOS Complete Development Environment Setup

🚀 **One-click installation script for complete mobile/web development environment on macOS**

## What it installs

### 🔧 Core Development Tools
- **Homebrew** - Package manager for macOS
- **Xcode Command Line Tools** - Essential development utilities
- **Git** - Version control system
- **Node.js & npm** - JavaScript runtime and package manager
- **Python 3** - Programming language with pip
- **NVM** - Node Version Manager

### 🎨 IDEs & Editors
- **Android Studio** - Official Android IDE with SDK
- **Visual Studio Code** - Microsoft's code editor with extensions:
  - Flutter & Dart
  - Python
  - GitLens
  - Prettier
  - ESLint
- **Cursor Editor** - AI-powered VS Code fork

### 📱 Mobile Development
- **Flutter SDK** - Google's UI toolkit
- **Android SDK** - Android development platform
- **CocoaPods** - iOS dependency manager
- **Scrcpy** - Android device mirroring
- **Firebase CLI** - Google's backend platform
- **Fastlane** - App deployment automation
- **FVM** - Flutter Version Manager
- **Mason CLI** - Code generation tool

### 🤖 AI Coding Assistants
- **Claude Desktop App** - Anthropic's AI assistant
- **Claude Code CLI** - Command-line interface
- **74+ Specialized Agents** - From [wshobson/agents](https://github.com/wshobson/agents):
  - Development & Architecture specialists
  - Language-specific experts (Python, JS, Go, Rust, etc.)
  - Infrastructure & DevOps agents
  - Security & Quality agents
  - Data Science & AI agents
- **Qwen Coder** - Via Ollama (7B parameter model)
- **GitHub Copilot** - AI pair programmer (requires subscription)

### 🐳 Additional Tools
- **Docker Desktop** - Containerization platform
- **PostgreSQL** - Relational database
- **MySQL** - Popular database system
- **Redis** - In-memory data store
- **MongoDB** - NoSQL database

## Quick Start

### Option 1: Direct Download & Run
```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/yourusername/dev-setup/main/dev-environment-setup.sh -o dev-setup.sh

# Make executable
chmod +x dev-setup.sh

# Run the installation
./dev-setup.sh
```

### Option 2: Clone Repository
```bash
git clone https://github.com/yourusername/dev-setup.git
cd dev-setup
chmod +x dev-environment-setup.sh
./dev-environment-setup.sh
```

### Option 3: One-liner Installation
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yourusername/dev-setup/main/dev-environment-setup.sh)"
```

## Installation Options

The script provides several installation modes:

1. **Full Installation** (Recommended) - Installs everything
2. **Core Tools Only** - Just the essential development tools
3. **AI Assistants Only** - Claude Code, agents, and Qwen Coder
4. **Mobile Development Tools Only** - Flutter, Android Studio, mobile tools
5. **Verify Existing Installation** - Check what's already installed
6. **Exit** - Quit the installer

## System Requirements

- **macOS 11 (Big Sur)** or later
- **Internet connection** for downloads
- **Administrator privileges** for some installations
- **~10GB free disk space** for full installation

## What happens during installation?

1. **System Checks** - Verifies macOS version and architecture (Intel/Apple Silicon)
2. **Prerequisites** - Installs Xcode tools, Homebrew, Rosetta 2 (if needed)
3. **Core Tools** - Installs development essentials
4. **IDEs** - Sets up Android Studio and VS Code with extensions
5. **Mobile Dev** - Configures Flutter, Android SDK, and mobile tools
6. **AI Assistants** - Installs Claude Code with 74+ agents and Qwen Coder
7. **Additional Tools** - Sets up Docker, databases, etc.
8. **Configuration** - Configures Git, environment variables
9. **Verification** - Tests installations and creates sample project

## Post-Installation Steps

After running the script:

1. **Restart Terminal** or run `source ~/.zshrc`
2. **Run Flutter Doctor**: `flutter doctor` to verify setup
3. **Open Android Studio** to complete SDK configuration
4. **Sign in to Claude Desktop** app
5. **Configure GitHub Copilot** in VS Code (requires subscription)

## Quick Commands

After installation, you can use these commands:

```bash
# Code editing
code .                              # Open VS Code
cursor .                            # Open Cursor Editor

# AI Assistants
claude                              # Use Claude Code CLI
ollama run qwen2.5-coder:7b        # Run Qwen Coder

# Mobile Development  
flutter create my_app               # Create Flutter app
flutter run                        # Run Flutter app
scrcpy                             # Mirror Android device
firebase init                      # Initialize Firebase

# Version Management
fvm list                           # List Flutter versions
nvm list                           # List Node.js versions

# Code Generation
mason init                         # Initialize Mason templates
```

## Claude Agents Usage

The script installs 74+ specialized agents that Claude Code can use automatically:

- **Architecture agents**: `architect`, `backend-architect`, `frontend-developer`
- **Language specialists**: `python-pro`, `javascript-pro`, `rust-pro`, `golang-pro`
- **Mobile experts**: `flutter-expert`, `ios-developer`, `android-developer`
- **DevOps agents**: `deployment-engineer`, `docker-specialist`, `terraform-specialist`
- **Security agents**: `security-auditor`, `penetration-tester`
- **Data agents**: `data-scientist`, `ml-engineer`, `database-optimizer`

Simply mention what you want to do, and Claude Code will automatically delegate to the appropriate specialist!

## Troubleshooting

### Common Issues

**Permission Denied**
```bash
chmod +x dev-environment-setup.sh
```

**Homebrew Installation Fails**
- Ensure you have administrator privileges
- Check internet connection
- Try running: `xcode-select --install`

**Flutter Doctor Issues**
```bash
flutter doctor --android-licenses    # Accept Android licenses
flutter doctor -v                    # Verbose output for debugging
```

**Android SDK Not Found**
- Restart terminal after installation
- Check environment variables: `echo $ANDROID_HOME`

### Log Files

The script creates detailed logs at:
```bash
~/dev-setup-YYYYMMDD-HHMMSS.log
```

### Getting Help

1. Check the log file for detailed error messages
2. Run verification: `./dev-environment-setup.sh` → Option 5
3. Manually run individual installation steps if needed

## License

MIT License - Feel free to modify and distribute.

## Contributing

Pull requests welcome! Please ensure all installations work on both Intel and Apple Silicon Macs.

---

**Happy Coding! 🎉**