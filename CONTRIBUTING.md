# Contributing to Development Environment Installer

Thank you for your interest in contributing! This guide will help you get started.

## 🎯 How to Contribute

### 1. **Report Issues**
- Use [GitHub Issues](https://github.com/tomaszlewandowski/dev-environment-installer/issues)
- Include your OS version and error logs
- Provide steps to reproduce the problem

### 2. **Suggest Features**
- Open a [GitHub Discussion](https://github.com/tomaszlewandowski/dev-environment-installer/discussions)
- Describe the feature and its use case
- Explain how it fits with the project goals

### 3. **Submit Code Changes**
- Fork the repository
- Create a feature branch
- Test thoroughly on both platforms
- Submit a pull request

## 🛠️ Development Setup

### Prerequisites
- **macOS**: macOS 11+ (for testing macOS script)
- **Windows**: Windows 10/11 (for testing Windows script)
- **Git**: For version control
- **Testing Environment**: Virtual machines recommended

### Testing Guidelines

#### macOS Script Testing:
```bash
# Test on clean system (VM recommended)
./macos/dev-environment-setup.sh

# Test individual functions
# (Modify script to call specific functions)

# Verify installations
./macos/dev-environment-setup.sh
# Select option 5 (Verify Installation)
```

#### Windows Script Testing:
```powershell
# Test on clean system (VM recommended)
# Run as Administrator
.\windows\windows-dev-environment-setup.ps1

# Test WSL installation
# Test native Windows installation
# Verify all components work
```

## 📋 Code Standards

### Shell Script (macOS)
- Use `#!/bin/bash` shebang
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Include error handling: `set -e`
- Use meaningful function names
- Add comments for complex logic

### PowerShell (Windows)
- Use `#Requires -RunAsAdministrator`
- Follow [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)
- Include error handling
- Use approved verbs for functions
- Test on both PowerShell 5.1 and 7+

### General Guidelines
- **Logging**: All operations must be logged
- **Idempotent**: Scripts should handle re-runs gracefully
- **User Feedback**: Provide clear status messages
- **Error Recovery**: Handle failures gracefully
- **Documentation**: Update README files

## 🧪 Testing Checklist

### Before Submitting PR:

#### macOS Testing:
- [ ] Test on Intel Mac
- [ ] Test on Apple Silicon Mac
- [ ] Test on macOS 11 (Big Sur)
- [ ] Test on macOS 12+ (Monterey/Ventura/Sonoma)
- [ ] Verify all installation options work
- [ ] Check that PATH modifications work
- [ ] Test Flutter project creation
- [ ] Verify Claude Code installation

#### Windows Testing:
- [ ] Test on Windows 10
- [ ] Test on Windows 11
- [ ] Test WSL 2 installation
- [ ] Test native Windows installation
- [ ] Verify PowerShell execution policy handling
- [ ] Check environment variable setup
- [ ] Test both Git Bash and WSL Claude Code setups

#### Cross-Platform:
- [ ] All tools install correctly
- [ ] Version verification works
- [ ] Error logging is comprehensive
- [ ] User experience is consistent
- [ ] Documentation is updated

## 📝 Pull Request Process

### 1. **Prepare Your PR**
```bash
# Fork and clone
git clone https://github.com/yourusername/dev-environment-installer.git
cd dev-environment-installer

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and test thoroughly
# ...

# Commit with descriptive message
git add .
git commit -m "Add: Description of your changes"

# Push to your fork
git push origin feature/your-feature-name
```

### 2. **PR Requirements**
- **Clear Title**: Describe what the PR does
- **Description**: Explain the changes and why they're needed
- **Testing**: Document what testing was done
- **Breaking Changes**: Note any breaking changes
- **Documentation**: Update docs if needed

### 3. **PR Template**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Refactoring

## Testing Done
- [ ] macOS Intel
- [ ] macOS Apple Silicon  
- [ ] Windows 10
- [ ] Windows 11
- [ ] WSL testing
- [ ] All installation options

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 🎨 Adding New Tools

### Guidelines for Adding Tools:
1. **Popular & Stable**: Tool should be widely used
2. **Cross-Platform**: Prefer tools available on both platforms
3. **Official Sources**: Use official installation methods
4. **Error Handling**: Handle installation failures gracefully
5. **Verification**: Include verification steps

### Example Addition:
```bash
# macOS function
install_new_tool() {
    print_header "Installing New Tool"
    
    if command_exists newtool; then
        print_success "New Tool already installed"
        return
    fi
    
    print_step "Installing New Tool..."
    brew install newtool
    
    # Verify installation
    if command_exists newtool; then
        print_success "New Tool installed successfully"
    else
        print_error "Failed to install New Tool"
    fi
}
```

## 🐛 Bug Reports

### Good Bug Report Includes:
- **OS Version**: macOS 12.3, Windows 11, etc.
- **Architecture**: Intel, Apple Silicon, x64
- **Script Version**: Version number from script
- **Error Message**: Exact error text
- **Log File**: Relevant portions of log file
- **Steps to Reproduce**: Clear steps
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happened

### Bug Report Template:
```markdown
**OS/Version**: macOS 13.1 / Apple Silicon

**Script Version**: 1.0.0

**Error Message**:
```
❌ Failed to install Flutter
```

**Steps to Reproduce**:
1. Run ./macos/dev-environment-setup.sh
2. Select option 1 (Full Installation)
3. Error occurs during Flutter installation

**Expected**: Flutter should install successfully

**Actual**: Installation fails with permission error

**Log File**:
```
[ERROR] 2025-08-18 15:30:22: Permission denied: /opt/homebrew/share/flutter
```
```

## 🎯 Project Goals

### Primary Goals:
- **Simplicity**: One-click installation
- **Reliability**: Works consistently across systems
- **Completeness**: Full development environment
- **AI-First**: Modern AI-powered development tools

### Non-Goals:
- **Heavy Customization**: Keep it simple and opinionated
- **Legacy Support**: Focus on modern systems
- **Every Tool**: Include popular, essential tools only

## 📞 Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/tomaszlewandowski/dev-environment-installer/discussions)
- **Issues**: Use [GitHub Issues](https://github.com/tomaszlewandowski/dev-environment-installer/issues)
- **Development**: Contact maintainers directly

## 🙏 Recognition

Contributors will be:
- Listed in README acknowledgments
- Credited in release notes
- Invited as collaborators (for significant contributions)

Thank you for helping make development environment setup easier for everyone! 🚀