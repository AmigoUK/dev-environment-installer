#!/bin/bash

#######################################################################################
# macOS Complete Development Environment Setup Script
# Version: 1.0.0
# Author: Development Environment Automation
# Description: One-click installation for complete mobile/web development environment
#              Including: Android Studio, VS Code, Claude Code with agents, 
#              Qwen Code, Flutter, and all essential development tools
#######################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script configuration
SCRIPT_VERSION="1.0.0"
LOG_FILE="$HOME/dev-setup-$(date +%Y%m%d-%H%M%S).log"
ERRORS_FOUND=0

#######################################################################################
# Helper Functions
#######################################################################################

print_header() {
    echo -e "\n${BLUE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}  $1${NC}"
    echo -e "${BLUE}${BOLD}═══════════════════════════════════════════════════════════════${NC}\n"
}

print_step() {
    echo -e "${YELLOW}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
    ERRORS_FOUND=$((ERRORS_FOUND + 1))
}

print_info() {
    echo -e "${BLUE}ℹ️${NC}  $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC}  $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Log output
log_output() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check macOS version
check_macos_version() {
    print_step "Checking macOS version..."
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d '.' -f 1)
    
    if [ "$MACOS_MAJOR" -lt 11 ]; then
        print_error "This script requires macOS 11 (Big Sur) or later. Current version: $MACOS_VERSION"
        exit 1
    fi
    print_success "macOS $MACOS_VERSION detected"
}

# Check if running on Apple Silicon or Intel
check_architecture() {
    print_step "Checking system architecture..."
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        print_success "Apple Silicon (M1/M2/M3) detected"
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        print_success "Intel processor detected"
        HOMEBREW_PREFIX="/usr/local"
    fi
}

#######################################################################################
# Prerequisites Installation
#######################################################################################

install_xcode_tools() {
    print_header "Installing Xcode Command Line Tools"
    
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools already installed"
    else
        print_step "Installing Xcode Command Line Tools..."
        xcode-select --install
        print_info "Please complete the Xcode tools installation in the popup window"
        print_info "Press any key to continue after installation completes..."
        read -n 1 -s
    fi
}

install_homebrew() {
    print_header "Installing Homebrew Package Manager"
    
    if command_exists brew; then
        print_success "Homebrew already installed"
        print_step "Updating Homebrew..."
        brew update
    else
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        echo "eval \"$($HOMEBREW_PREFIX/bin/brew shellenv)\"" >> "$HOME/.zprofile"
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    fi
}

install_rosetta() {
    print_header "Checking Rosetta 2 (for Apple Silicon)"
    
    if [[ "$ARCH" == "arm64" ]]; then
        if /usr/bin/pgrep oahd >/dev/null 2>&1; then
            print_success "Rosetta 2 already installed"
        else
            print_step "Installing Rosetta 2..."
            softwareupdate --install-rosetta --agree-to-license
        fi
    else
        print_info "Rosetta 2 not needed on Intel Macs"
    fi
}

#######################################################################################
# Development Tools Installation
#######################################################################################

install_git() {
    print_header "Installing Git Version Control"
    
    if command_exists git; then
        print_success "Git already installed: $(git --version)"
    else
        print_step "Installing Git..."
        brew install git
    fi
}

install_android_studio() {
    print_header "Installing Android Studio"
    
    if [ -d "/Applications/Android Studio.app" ]; then
        print_success "Android Studio already installed"
    else
        print_step "Installing Android Studio..."
        brew install --cask android-studio
        print_success "Android Studio installed"
    fi
    
    # Setup Android SDK environment variables
    print_step "Setting up Android SDK environment variables..."
    ANDROID_HOME="$HOME/Library/Android/sdk"
    
    if ! grep -q "ANDROID_HOME" "$HOME/.zshrc" 2>/dev/null; then
        cat >> "$HOME/.zshrc" << EOF

# Android SDK
export ANDROID_HOME="$ANDROID_HOME"
export PATH="\$PATH:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/cmdline-tools/latest/bin"
EOF
        print_success "Android environment variables added to .zshrc"
    fi
}

install_vscode() {
    print_header "Installing Visual Studio Code"
    
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        print_success "VS Code already installed"
    else
        print_step "Installing VS Code..."
        brew install --cask visual-studio-code
        print_success "VS Code installed"
    fi
    
    # Install essential VS Code extensions
    if command_exists code; then
        print_step "Installing VS Code extensions..."
        code --install-extension dart-code.dart-code
        code --install-extension dart-code.flutter
        code --install-extension ms-python.python
        code --install-extension esbenp.prettier-vscode
        code --install-extension dbaeumer.vscode-eslint
        code --install-extension eamodio.gitlens
        print_success "VS Code extensions installed"
    fi
}

install_flutter() {
    print_header "Installing Flutter SDK"
    
    if command_exists flutter; then
        print_success "Flutter already installed: $(flutter --version | head -1)"
    else
        print_step "Installing Flutter..."
        brew install --cask flutter
        
        # Add Flutter to PATH
        if ! grep -q "flutter/bin" "$HOME/.zshrc" 2>/dev/null; then
            echo 'export PATH="/opt/homebrew/share/flutter/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        
        print_step "Accepting Android licenses..."
        yes | flutter doctor --android-licenses 2>/dev/null || true
    fi
    
    # Install Flutter dependencies
    print_step "Installing Flutter dependencies..."
    brew install cocoapods 2>/dev/null || true
}

install_nodejs() {
    print_header "Installing Node.js and npm"
    
    if command_exists node; then
        print_success "Node.js already installed: $(node --version)"
    else
        print_step "Installing Node.js..."
        brew install node
    fi
    
    # Install NVM for Node version management
    if [ ! -d "$HOME/.nvm" ]; then
        print_step "Installing NVM (Node Version Manager)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    fi
}

install_python() {
    print_header "Installing Python"
    
    if command_exists python3; then
        print_success "Python already installed: $(python3 --version)"
    else
        print_step "Installing Python..."
        brew install python
    fi
    
    # Install pip packages
    print_step "Installing essential Python packages..."
    pip3 install --user requests numpy pandas jupyter
}

#######################################################################################
# AI Coding Assistants Installation
#######################################################################################

install_claude_code() {
    print_header "Installing Claude Code Desktop"
    
    print_step "Checking for Claude Code..."
    
    # Install Claude Desktop App
    if [ -d "/Applications/Claude.app" ]; then
        print_success "Claude Desktop app already installed"
    else
        print_step "Installing Claude Desktop app..."
        brew install --cask claude
        print_success "Claude Desktop app installed"
    fi
    
    # Install Claude Code CLI
    if [ ! -f "$HOME/.claude/local/claude" ]; then
        print_step "Installing Claude Code CLI..."
        mkdir -p "$HOME/.claude/local"
        curl -fsSL https://storage.googleapis.com/anthropic-public-scripts/claude-cli/install.sh | sh
    fi
    
    # Add alias to .zshrc if not exists
    if ! grep -q "alias claude=" "$HOME/.zshrc" 2>/dev/null; then
        echo 'alias claude="$HOME/.claude/local/claude"' >> "$HOME/.zshrc"
    fi
    
    print_success "Claude Code installed"
}

install_claude_agents() {
    print_header "Installing Claude Code Subagents Collection"
    
    print_step "Installing 74+ specialized agents from wshobson/agents..."
    
    if [ -d "$HOME/.claude/agents" ]; then
        print_step "Updating existing agents..."
        cd "$HOME/.claude/agents"
        git pull origin main
    else
        print_step "Cloning agents repository..."
        cd "$HOME/.claude"
        git clone https://github.com/wshobson/agents.git
    fi
    
    print_success "Claude agents installed successfully"
    print_info "Available agent categories:"
    echo "  • Development & Architecture agents"
    echo "  • Language-specific specialists (Python, JS, Go, Rust, etc.)"
    echo "  • Infrastructure & DevOps agents"
    echo "  • Security & Quality agents"
    echo "  • Data Science & AI agents"
    echo "  • Business & Marketing agents"
}

install_qwen_code() {
    print_header "Installing Qwen Coder"
    
    print_step "Installing Ollama for running Qwen models..."
    
    if command_exists ollama; then
        print_success "Ollama already installed"
    else
        brew install ollama
        print_step "Starting Ollama service..."
        brew services start ollama
    fi
    
    print_step "Pulling Qwen2.5-Coder model..."
    ollama pull qwen2.5-coder:7b
    
    print_success "Qwen Coder installed via Ollama"
    print_info "Access Qwen: ollama run qwen2.5-coder:7b"
}

install_github_copilot() {
    print_header "Installing GitHub Copilot"
    
    if command_exists code; then
        print_step "Installing GitHub Copilot VS Code extension..."
        code --install-extension GitHub.copilot
        code --install-extension GitHub.copilot-chat
        print_success "GitHub Copilot extensions installed"
        print_info "Note: GitHub Copilot requires a subscription. Sign in through VS Code."
    else
        print_warning "VS Code not found. Install VS Code first to use GitHub Copilot."
    fi
}

install_cursor() {
    print_header "Installing Cursor Editor (AI-powered fork of VS Code)"
    
    if [ -d "/Applications/Cursor.app" ]; then
        print_success "Cursor already installed"
    else
        print_step "Installing Cursor..."
        brew install --cask cursor
        print_success "Cursor Editor installed"
    fi
}

install_github_desktop() {
    print_header "Installing GitHub Desktop"
    
    if [ -d "/Applications/GitHub Desktop.app" ]; then
        print_success "GitHub Desktop already installed"
    else
        print_step "Installing GitHub Desktop..."
        brew install --cask github
        print_success "GitHub Desktop installed"
    fi
    
    print_info "GitHub Desktop provides a graphical interface for Git operations"
    print_info "You can sign in with your GitHub account after installation"
}

install_mamp() {
    print_header "Installing MAMP (Local Development Server)"
    
    if [ -d "/Applications/MAMP" ]; then
        print_success "MAMP already installed"
    else
        print_step "Installing MAMP..."
        brew install --cask mamp
        print_success "MAMP installed"
    fi
    
    print_info "MAMP provides Apache, MySQL, and PHP for local web development"
    print_info "Access MAMP control panel from Applications folder"
}

#######################################################################################
# Additional Development Tools
#######################################################################################

install_docker() {
    print_header "Installing Docker Desktop"
    
    if [ -d "/Applications/Docker.app" ]; then
        print_success "Docker Desktop already installed"
    else
        print_step "Installing Docker Desktop..."
        brew install --cask docker
        print_success "Docker Desktop installed"
    fi
}

install_database_tools() {
    print_header "Installing Database Tools"
    
    print_step "Installing PostgreSQL..."
    brew install postgresql@16
    
    print_step "Installing MySQL..."
    brew install mysql
    
    print_step "Installing Redis..."
    brew install redis
    
    print_step "Installing MongoDB..."
    brew tap mongodb/brew
    brew install mongodb-community
    
    print_success "Database tools installed"
}

install_mobile_dev_tools() {
    print_header "Installing Mobile Development Tools"
    
    print_step "Installing Scrcpy (Android screen mirroring)..."
    brew install scrcpy
    
    print_step "Installing Firebase CLI..."
    npm install -g firebase-tools
    
    print_step "Installing Fastlane..."
    brew install fastlane
    
    print_step "Installing FVM (Flutter Version Manager)..."
    brew tap leoafarias/fvm
    brew install fvm
    
    print_step "Installing Mason CLI..."
    dart pub global activate mason_cli
    
    # Add pub cache to PATH
    if ! grep -q ".pub-cache/bin" "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> "$HOME/.zshrc"
    fi
    
    print_success "Mobile development tools installed"
}

#######################################################################################
# Configuration and Testing
#######################################################################################

configure_git() {
    print_header "Configuring Git"
    
    print_step "Setting up Git configuration..."
    
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    
    print_success "Git configured"
}

verify_installations() {
    print_header "Verifying Installations"
    
    echo -e "\n${BOLD}Development Environment Status:${NC}\n"
    
    # Core Tools
    echo -e "${CYAN}Core Tools:${NC}"
    command_exists brew && echo "  ✅ Homebrew: $(brew --version | head -1)" || echo "  ❌ Homebrew: Not installed"
    command_exists git && echo "  ✅ Git: $(git --version)" || echo "  ❌ Git: Not installed"
    command_exists node && echo "  ✅ Node.js: $(node --version)" || echo "  ❌ Node.js: Not installed"
    command_exists python3 && echo "  ✅ Python: $(python3 --version)" || echo "  ❌ Python: Not installed"
    
    # IDEs
    echo -e "\n${CYAN}IDEs and Editors:${NC}"
    [ -d "/Applications/Android Studio.app" ] && echo "  ✅ Android Studio: Installed" || echo "  ❌ Android Studio: Not installed"
    [ -d "/Applications/Visual Studio Code.app" ] && echo "  ✅ VS Code: Installed" || echo "  ❌ VS Code: Not installed"
    [ -d "/Applications/Cursor.app" ] && echo "  ✅ Cursor: Installed" || echo "  ❌ Cursor: Not installed"
    
    # Mobile Development
    echo -e "\n${CYAN}Mobile Development:${NC}"
    command_exists flutter && echo "  ✅ Flutter: $(flutter --version | head -1)" || echo "  ❌ Flutter: Not installed"
    command_exists scrcpy && echo "  ✅ Scrcpy: Installed" || echo "  ❌ Scrcpy: Not installed"
    command_exists firebase && echo "  ✅ Firebase CLI: $(firebase --version)" || echo "  ❌ Firebase: Not installed"
    command_exists fastlane && echo "  ✅ Fastlane: Installed" || echo "  ❌ Fastlane: Not installed"
    command_exists fvm && echo "  ✅ FVM: $(fvm --version)" || echo "  ❌ FVM: Not installed"
    
    # AI Assistants
    echo -e "\n${CYAN}AI Coding Assistants:${NC}"
    [ -d "/Applications/Claude.app" ] && echo "  ✅ Claude Desktop: Installed" || echo "  ❌ Claude: Not installed"
    [ -f "$HOME/.claude/local/claude" ] && echo "  ✅ Claude Code CLI: Installed" || echo "  ❌ Claude Code CLI: Not installed"
    [ -d "$HOME/.claude/agents" ] && echo "  ✅ Claude Agents: Installed" || echo "  ❌ Claude Agents: Not installed"
    command_exists ollama && echo "  ✅ Ollama (Qwen): Installed" || echo "  ❌ Ollama: Not installed"
    
    # Additional Tools
    echo -e "\n${CYAN}Additional Tools:${NC}"
    [ -d "/Applications/Docker.app" ] && echo "  ✅ Docker Desktop: Installed" || echo "  ❌ Docker: Not installed"
    [ -d "/Applications/GitHub Desktop.app" ] && echo "  ✅ GitHub Desktop: Installed" || echo "  ❌ GitHub Desktop: Not installed"
    [ -d "/Applications/MAMP" ] && echo "  ✅ MAMP: Installed" || echo "  ❌ MAMP: Not installed"
    command_exists psql && echo "  ✅ PostgreSQL: Installed" || echo "  ❌ PostgreSQL: Not installed"
    command_exists mysql && echo "  ✅ MySQL: Installed" || echo "  ❌ MySQL: Not installed"
    command_exists redis-cli && echo "  ✅ Redis: Installed" || echo "  ❌ Redis: Not installed"
}

create_test_project() {
    print_header "Creating Test Flutter Project"
    
    print_step "Creating test project to verify setup..."
    
    TEST_DIR="$HOME/flutter_test_project"
    if [ ! -d "$TEST_DIR" ]; then
        flutter create "$TEST_DIR"
        cd "$TEST_DIR"
        flutter pub get
        print_success "Test project created at $TEST_DIR"
    else
        print_info "Test project already exists at $TEST_DIR"
    fi
}

#######################################################################################
# Main Installation Flow
#######################################################################################

main_menu() {
    clear
    echo -e "${MAGENTA}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║     macOS Complete Development Environment Installer v$SCRIPT_VERSION     ║"
    echo "║                                                                ║"
    echo "║  This script will install:                                    ║"
    echo "║  • Core development tools (Git, Node.js, Python)              ║"
    echo "║  • Android Studio & Flutter SDK                               ║"
    echo "║  • VS Code & Cursor Editor                                    ║"
    echo "║  • Claude Code with 74+ specialized agents                    ║"
    echo "║  • Qwen Coder & GitHub Copilot                               ║"
    echo "║  • GitHub Desktop & MAMP local server                         ║"
    echo "║  • Docker, databases, and mobile dev tools                    ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "\n${YELLOW}Installation Options:${NC}"
    echo "  1) Full Installation (Recommended)"
    echo "  2) Core Tools Only"
    echo "  3) AI Assistants Only"
    echo "  4) Mobile Development Tools Only"
    echo "  5) Verify Existing Installation"
    echo "  6) Exit"
    echo ""
    read -p "Select option (1-6): " choice
    
    case $choice in
        1)
            full_installation
            ;;
        2)
            core_tools_installation
            ;;
        3)
            ai_assistants_installation
            ;;
        4)
            mobile_tools_installation
            ;;
        5)
            verify_installations
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            main_menu
            ;;
    esac
}

full_installation() {
    print_header "Starting Full Installation"
    
    # System checks
    check_macos_version
    check_architecture
    
    # Prerequisites
    install_xcode_tools
    install_homebrew
    install_rosetta
    
    # Core tools
    install_git
    install_nodejs
    install_python
    
    # IDEs
    install_android_studio
    install_vscode
    install_cursor
    
    # Mobile development
    install_flutter
    install_mobile_dev_tools
    
    # AI Assistants
    install_claude_code
    install_claude_agents
    install_qwen_code
    install_github_copilot
    
    # Additional tools
    install_docker
    install_github_desktop
    install_mamp
    install_database_tools
    
    # Configuration
    configure_git
    
    # Testing
    create_test_project
    verify_installations
    
    print_completion_message
}

core_tools_installation() {
    print_header "Installing Core Development Tools"
    
    check_macos_version
    check_architecture
    install_xcode_tools
    install_homebrew
    install_git
    install_nodejs
    install_python
    install_vscode
    install_github_desktop
    install_mamp
    configure_git
    verify_installations
}

ai_assistants_installation() {
    print_header "Installing AI Coding Assistants"
    
    check_macos_version
    install_claude_code
    install_claude_agents
    install_qwen_code
    install_github_copilot
    install_cursor
    verify_installations
}

mobile_tools_installation() {
    print_header "Installing Mobile Development Tools"
    
    check_macos_version
    check_architecture
    install_homebrew
    install_android_studio
    install_flutter
    install_mobile_dev_tools
    create_test_project
    verify_installations
}

print_completion_message() {
    echo -e "\n${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}     🎉 Installation Complete! 🎉${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════════${NC}\n"
    
    if [ $ERRORS_FOUND -gt 0 ]; then
        print_warning "Installation completed with $ERRORS_FOUND errors. Check log: $LOG_FILE"
    else
        print_success "All components installed successfully!"
    fi
    
    echo -e "\n${CYAN}${BOLD}Next Steps:${NC}"
    echo "  1. Restart Terminal or run: source ~/.zshrc"
    echo "  2. Run 'flutter doctor' to verify Flutter setup"
    echo "  3. Open Android Studio to complete SDK setup"
    echo "  4. Sign in to Claude Desktop app"
    echo "  5. Configure GitHub Copilot in VS Code"
    
    echo -e "\n${CYAN}${BOLD}Quick Commands:${NC}"
    echo "  • Start coding:        code ."
    echo "  • Use Claude Code:     claude"
    echo "  • Run Qwen Coder:      ollama run qwen2.5-coder:7b"
    echo "  • Create Flutter app:  flutter create my_app"
    echo "  • Mirror Android:      scrcpy"
    
    echo -e "\n${BLUE}Installation log saved to: $LOG_FILE${NC}"
}

#######################################################################################
# Script Entry Point
#######################################################################################

# Trap errors and cleanup
trap 'print_error "Script interrupted. Check log: $LOG_FILE"' INT TERM

# Start logging
log_output "Starting development environment setup - Version $SCRIPT_VERSION"
log_output "System: $(uname -a)"

# Run main menu
main_menu