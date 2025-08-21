# Development Environment Installer Upgrade Plan
## Adding GitHub Desktop and MAMP Support

### 📋 EXECUTION PLAN
═══════════════════════════════════════════════════════════════════════════

**Classification**: Complex Mission  
**Project**: dev-environment-installer GitHub Desktop & MAMP Integration  
**Priority**: High  
**Architecture Impact**: Moderate - Adding new tools without breaking existing structure

---

## 🎯 PROJECT OVERVIEW

This plan upgrades the existing macOS development environment installer to include:
1. **GitHub Desktop** - Git GUI client for visual repository management
2. **MAMP** - Local web development server stack (Apache, MySQL, PHP)

Both tools will be integrated seamlessly into the existing installer architecture while maintaining the current user experience and installation options.

---

## 🔍 CURRENT ARCHITECTURE ANALYSIS

### Existing Structure:
```
dev-environment-installer/
├── macos/dev-environment-setup.sh    # Main macOS installer script
├── README.md                         # Main documentation
├── QUICK-INSTALL.md                  # Quick reference
├── docs/README-macos.md              # Detailed macOS docs
└── docs/README-windows.md            # Windows documentation
```

### Current Installation Categories:
1. **Core Development Tools** (Git, Node.js, Python)
2. **IDEs & Editors** (Android Studio, VS Code, Cursor)
3. **Mobile Development** (Flutter, Android SDK, Firebase CLI)
4. **AI Assistants** (Claude Code, Qwen Coder, GitHub Copilot)
5. **Additional Tools** (Docker, Databases)

### Installation Options:
1. Full Installation (Recommended)
2. Core Tools Only
3. AI Assistants Only
4. Mobile Development Tools Only
5. Verify Existing Installation

---

## 🏗️ IMPLEMENTATION STRATEGY

### Strategic Decisions:

1. **Integration Approach**: Add GitHub Desktop and MAMP as part of "Core Development Tools"
2. **Installation Method**: Use Homebrew casks for both tools (standard pattern)
3. **Menu Structure**: Maintain existing options, enhance descriptions
4. **Documentation**: Update all relevant documentation files consistently
5. **Verification**: Add checks to existing verification functions

### Architectural Principles Applied:

- **SLON**: Simple addition without overengineering
- **DRY**: Reuse existing installation patterns and functions
- **KISS**: Follow established conventions in the codebase
- **Occam's Razor**: Minimal changes to achieve maximum functionality

---

## 📝 DETAILED IMPLEMENTATION PLAN

### Phase 1: Core Script Modifications

#### Task 1: Add GitHub Desktop Installation Function
**File**: `/Users/tomaszlewandowski/dev-environment-installer/macos/dev-environment-setup.sh`
**Location**: After `install_git()` function (around line 160)

```bash
install_github_desktop() {
    print_header "Installing GitHub Desktop"
    
    if [ -d "/Applications/GitHub Desktop.app" ]; then
        print_success "GitHub Desktop already installed"
    else
        print_step "Installing GitHub Desktop..."
        brew install --cask github
        print_success "GitHub Desktop installed"
    fi
    
    print_info "GitHub Desktop provides a visual interface for Git repositories"
}
```

#### Task 2: Add MAMP Installation Function
**File**: `/Users/tomaszlewandowski/dev-environment-installer/macos/dev-environment-setup.sh`
**Location**: After `install_database_tools()` function (around line 403)

```bash
install_mamp() {
    print_header "Installing MAMP (Apache, MySQL, PHP Stack)"
    
    if [ -d "/Applications/MAMP" ]; then
        print_success "MAMP already installed"
    else
        print_step "Installing MAMP..."
        brew install --cask mamp
        print_success "MAMP installed"
    fi
    
    print_info "MAMP provides a local web server environment"
    print_info "Access MAMP control panel at: /Applications/MAMP/MAMP.app"
}
```

#### Task 3: Update Installation Flow Functions
**Modifications needed in these functions**:

1. **`full_installation()`** (line 567):
   - Add `install_github_desktop` after `install_git` (line 580)
   - Add `install_mamp` after `install_database_tools` (line 601)

2. **`core_tools_installation()`** (line 613):
   - Add `install_github_desktop` after `install_git` (line 620)

#### Task 4: Update Verification Function
**File**: `/Users/tomaszlewandowski/dev-environment-installer/macos/dev-environment-setup.sh`
**Location**: `verify_installations()` function (line 452)

Add to Core Tools section (around line 460):
```bash
[ -d "/Applications/GitHub Desktop.app" ] && echo "  ✅ GitHub Desktop: Installed" || echo "  ❌ GitHub Desktop: Not installed"
```

Add to Additional Tools section (around line 490):
```bash
[ -d "/Applications/MAMP" ] && echo "  ✅ MAMP: Installed" || echo "  ❌ MAMP: Not installed"
```

#### Task 5: Update Menu Descriptions
**File**: `/Users/tomaszlewandowski/dev-environment-installer/macos/dev-environment-setup.sh`
**Location**: `main_menu()` function (line 513)

Update the description box (lines 520-525):
```bash
echo "║  • Core development tools (Git, GitHub Desktop, Node.js, Python) ║"
echo "║  • Local web server (MAMP with Apache, MySQL, PHP)               ║"
```

---

### Phase 2: Documentation Updates

#### Task 6: Update Main README.md
**File**: `/Users/tomaszlewandowski/dev-environment-installer/README.md`

**Changes required**:

1. **Line 27-32**: Update "Core Development Tools" section:
```markdown
### 🔧 **Core Development Tools**
- **Git** - Version control system
- **GitHub Desktop** - Git GUI client for visual repository management
- **Node.js & npm** - JavaScript runtime and package manager  
- **Python 3** - Programming language with pip
- **Package Managers** - Homebrew (macOS) / Chocolatey (Windows)
```

2. **Line 52-56**: Update "Additional Tools" section:
```markdown
### 🐳 **Additional Tools**
- **Docker Desktop** - Containerization
- **MAMP** - Local web server stack (Apache, MySQL, PHP)
- **Databases** - PostgreSQL, MySQL, Redis, MongoDB
- **WSL 2 + Ubuntu** - Linux environment (Windows only)
```

3. **Line 172-196**: Update "Quick Commands After Installation" section:
```bash
# Version Control
git status                   # Check git status
github                       # Open GitHub Desktop

# Web Development
# Start MAMP from Applications or:
open /Applications/MAMP/MAMP.app

# Mobile Development
flutter create my_app          # Create new Flutter app
flutter run                   # Run on connected device
flutter doctor               # Check Flutter setup
```

#### Task 7: Update QUICK-INSTALL.md
**File**: `/Users/tomaszlewandowski/dev-environment-installer/QUICK-INSTALL.md`

**Changes required**:

1. **Line 39**: Update "What Gets Installed" section:
```markdown
- **Core Tools**: Git, GitHub Desktop, Node.js, Python, Package Managers
```

2. **Line 43**: Update additional tools:
```markdown
- **Additional**: Docker, MAMP (Apache/MySQL/PHP), Databases (PostgreSQL, MySQL, Redis, MongoDB)
```

3. **Line 57-68**: Update "Post-Installation Commands":
```bash
# Verify everything works
flutter doctor                    # Check Flutter setup
claude                            # Start Claude Code
ollama run qwen2.5-coder:7b      # Run Qwen Coder
code .                           # Open VS Code
github                           # Open GitHub Desktop

# Start local web server
open /Applications/MAMP/MAMP.app  # Start MAMP

# Create your first Flutter app
flutter create my_awesome_app
cd my_awesome_app
flutter run
```

#### Task 8: Update docs/README-macos.md
**File**: `/Users/tomaszlewandowski/dev-environment-installer/docs/README-macos.md`

**Changes required**:

1. **Line 7-14**: Update "Core Development Tools" section:
```markdown
### 🔧 Core Development Tools
- **Homebrew** - Package manager for macOS
- **Xcode Command Line Tools** - Essential development utilities
- **Git** - Version control system
- **GitHub Desktop** - Git GUI client with visual interface
- **Node.js & npm** - JavaScript runtime and package manager
- **Python 3** - Programming language with pip
- **NVM** - Node Version Manager
```

2. **Line 47-53**: Update "Additional Tools" section:
```markdown
### 🐳 Additional Tools
- **Docker Desktop** - Containerization platform
- **MAMP** - Local web server stack (Apache, MySQL, PHP)
- **PostgreSQL** - Relational database
- **MySQL** - Popular database system
- **Redis** - In-memory data store
- **MongoDB** - NoSQL database
```

3. **Line 125-146**: Update "Quick Commands" section:
```bash
# Code editing
code .                              # Open VS Code
cursor .                            # Open Cursor Editor

# Version Control
git status                          # Check git status
github                              # Open GitHub Desktop

# Web Development
open /Applications/MAMP/MAMP.app    # Start MAMP server

# AI Assistants
claude                              # Use Claude Code CLI
ollama run qwen2.5-coder:7b        # Run Qwen Coder
```

---

### Phase 3: Testing and Validation

#### Task 9: Test Installation Process
**Actions required**:

1. **Backup current script** before modifications
2. **Test GitHub Desktop installation**:
   - Verify `brew install --cask github` works
   - Confirm application appears in `/Applications/GitHub Desktop.app`
   - Test application launches correctly

3. **Test MAMP installation**:
   - Verify `brew install --cask mamp` works
   - Confirm MAMP directory appears in `/Applications/MAMP`
   - Test MAMP control panel launches

4. **Test verification function**:
   - Run verification with both tools installed
   - Run verification with tools not installed
   - Confirm output formatting is consistent

5. **Test full installation flow**:
   - Run complete installation on clean system (if possible)
   - Verify all existing functionality still works
   - Confirm new tools are installed in correct order

#### Task 10: Create Git Commits
**Commit strategy**:

1. **Commit 1**: Script modifications
   ```bash
   git add macos/dev-environment-setup.sh
   git commit -m "Add GitHub Desktop and MAMP installation support

   - Add install_github_desktop() function with Homebrew cask installation
   - Add install_mamp() function for local web server stack
   - Update installation flows (full and core tools)
   - Update verification function to check new installations
   - Update menu descriptions to reflect new tools

   Fixes: Enhances development environment with Git GUI and local server"
   ```

2. **Commit 2**: Documentation updates
   ```bash
   git add README.md QUICK-INSTALL.md docs/README-macos.md
   git commit -m "Update documentation for GitHub Desktop and MAMP support

   - Update main README.md with new tools in core and additional sections
   - Update QUICK-INSTALL.md reference with new installation items
   - Update docs/README-macos.md with detailed tool descriptions
   - Add quick commands for GitHub Desktop and MAMP usage

   Documentation reflects new installer capabilities"
   ```

3. **Commit 3**: Final testing and cleanup
   ```bash
   git add .
   git commit -m "Final cleanup and testing for GitHub Desktop and MAMP

   - Verified installation process on test system
   - Confirmed documentation accuracy
   - Tested verification functions
   - All new tools integrate seamlessly with existing installer"
   ```

---

## 🎯 SUCCESS CRITERIA

### Functional Requirements:
✅ GitHub Desktop installs via Homebrew cask  
✅ MAMP installs via Homebrew cask  
✅ Both tools appear in verification output  
✅ Installation integrates with existing menu system  
✅ All documentation accurately reflects new capabilities  

### Quality Requirements:
✅ No breaking changes to existing functionality  
✅ Consistent coding patterns with existing script  
✅ Error handling follows established patterns  
✅ Log output maintains existing format  
✅ User experience remains intuitive  

### Documentation Requirements:
✅ All relevant files updated consistently  
✅ Quick commands provided for new tools  
✅ Installation descriptions are accurate  
✅ Troubleshooting information available  

---

## 🚨 RISK ASSESSMENT

### Low Risk:
- **Homebrew cask availability**: Both `github` and `mamp` casks are well-established
- **Integration complexity**: Following existing patterns minimizes risk
- **User impact**: Optional tools don't affect core functionality

### Mitigation Strategies:
- **Test installations** on clean system before deployment
- **Backup original script** before modifications
- **Verify cask names** are current and correct
- **Test error handling** for failed installations

---

## 📋 IMPLEMENTATION CHECKLIST

### Pre-Implementation:
- [ ] Backup current dev-environment-setup.sh
- [ ] Verify Homebrew cask names for both tools
- [ ] Test manual installations to confirm process

### Implementation:
- [ ] Add `install_github_desktop()` function
- [ ] Add `install_mamp()` function  
- [ ] Update `full_installation()` flow
- [ ] Update `core_tools_installation()` flow
- [ ] Update `verify_installations()` function
- [ ] Update menu descriptions
- [ ] Update README.md documentation
- [ ] Update QUICK-INSTALL.md documentation
- [ ] Update docs/README-macos.md documentation

### Post-Implementation:
- [ ] Test GitHub Desktop installation
- [ ] Test MAMP installation
- [ ] Test verification function output
- [ ] Test complete installation flow
- [ ] Verify documentation accuracy
- [ ] Create appropriate git commits

---

## 🔧 TECHNICAL SPECIFICATIONS

### GitHub Desktop Installation:
- **Homebrew cask**: `github`
- **Installation path**: `/Applications/GitHub Desktop.app`
- **Verification method**: Directory existence check
- **Integration point**: Core tools section

### MAMP Installation:
- **Homebrew cask**: `mamp`
- **Installation path**: `/Applications/MAMP`
- **Verification method**: Directory existence check
- **Integration point**: Additional tools section

### Code Quality Standards:
- **Function naming**: Follow existing `install_*()` pattern
- **Output formatting**: Use existing `print_*()` functions
- **Error handling**: Follow existing patterns with `set -e`
- **Documentation**: Maintain existing style and formatting

---

## 📊 ESTIMATED TIMELINE

**Total Estimated Time**: 3-4 hours

- **Script modifications**: 1.5 hours
- **Documentation updates**: 1 hour  
- **Testing and validation**: 1 hour
- **Git commits and cleanup**: 30 minutes

---

## 🎉 EXPECTED OUTCOMES

Upon completion, the development environment installer will:

1. **Seamlessly install GitHub Desktop** as part of core development tools
2. **Provide MAMP local server environment** for web development
3. **Maintain all existing functionality** without breaking changes
4. **Offer enhanced development capabilities** with visual Git management and local web server
5. **Present consistent user experience** with clear documentation and verification

The enhanced installer will better serve developers who need:
- **Visual Git interface** for repository management
- **Local web development environment** for PHP/MySQL projects
- **Complete development stack** in a single installation

This upgrade maintains the installer's core philosophy of providing a complete, one-click development environment while expanding its capabilities to cover more development scenarios.

---

**📋 Ready for implementation with comprehensive planning and risk mitigation strategies in place.**