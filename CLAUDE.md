# Claude Code Project Context

This file contains development context and common commands for the Programmer Keyboard iOS project.

## Project Overview

**Goal**: Create a custom iOS keyboard extension optimized for programmers
**Current State**: Restoration phase - basic SwiftUI app exists, keyboard extension needs implementation
**Key Feature**: Single-page keyboard layout with all programming symbols accessible

## Development Environment

- **Working Directory**: `/Users/justinchencya/Documents/AI Apps/programmer-keyboard`
- **Xcode Project**: `ProgrammerKeyboard/ProgrammerKeyboard.xcodeproj`
- **Bundle ID**: `nerdyStuff.ProgrammerKeyboard`
- **Deployment Target**: iOS 17.0+
- **Architecture**: SwiftUI + Core Data

## Common Commands

### Building & Testing
```bash
# Build the main app
cd ProgrammerKeyboard && xcodebuild -project ProgrammerKeyboard.xcodeproj -scheme ProgrammerKeyboard -sdk iphoneos build

# Build for simulator (for main app only - keyboard extensions don't work in simulator)
cd ProgrammerKeyboard && xcodebuild -project ProgrammerKeyboard.xcodeproj -scheme ProgrammerKeyboard -sdk iphonesimulator build

# Clean build artifacts
cd ProgrammerKeyboard && xcodebuild clean
```

### Project Management
```bash
# Check git status
git status

# Stage and commit changes
git add .
git commit -m "Your commit message"

# View recent commits
git log --oneline -5

# Check project structure
tree -I 'build|DerivedData|*.xcuserstate'
```

### File Operations
```bash
# List project files
find ProgrammerKeyboard -name "*.swift" -not -path "*/DerivedData/*"

# Search for specific code patterns
grep -r "UIInputViewController" ProgrammerKeyboard/
grep -r "keyboard" ProgrammerKeyboard/
```

## Development Phases

### Phase 1: Foundation ✅
- [x] Git cleanup and documentation
- [x] Build verification
- [x] Project structure establishment

### Phase 2: Keyboard Extension 🚧
- [ ] Add keyboard extension target to Xcode project
- [ ] Create `KeyboardViewController` inheriting from `UIInputViewController`
- [ ] Implement custom keyboard layout with programming symbols
- [ ] Configure app groups for data sharing between main app and extension

### Phase 3: Programming Features ⏳
- [ ] Design single-page layout with color-coded keys
- [ ] Implement symbol shortcuts and common programming patterns
- [ ] Add code snippet functionality
- [ ] Create theme system

## Key Files to Implement

### Keyboard Extension Files (Missing)
```
ProgrammerKeyboard/
└── ProgrammerKeyboardExtension/
    ├── KeyboardViewController.swift      # Main keyboard controller
    ├── KeyboardView.swift               # Custom keyboard UI
    ├── ProgrammerKeyboard.swift         # Key layout definitions
    └── Info.plist                      # Extension configuration
```

### Main App Enhancements (Future)
```
ProgrammerKeyboard/ProgrammerKeyboard/
├── Views/
│   ├── SettingsView.swift              # Keyboard settings
│   ├── SnippetManagerView.swift        # Code snippet management
│   └── StatisticsView.swift            # Usage statistics
├── Models/
│   ├── KeyboardSettings.swift          # Settings data model
│   ├── CodeSnippet.swift               # Snippet data model
│   └── UsageStatistics.swift           # Statistics tracking
└── Services/
    ├── SettingsService.swift           # Settings management
    └── SnippetService.swift             # Snippet operations
```

## Keyboard Layout Design

### Planned Layout Structure
```
Row 1: Q W E R T Y U I O P
Row 2: A S D F G H J K L
Row 3: Z X C V B N M ⌫
Row 4: 0 1 2 3 4 5 6 7 8 9
Row 5: + - * / = ( ) [ ] { }
Row 6: < > . , ; : _ " '
Row 7: 🌐 [space] ↵
```

### Color Coding
- **Numbers (0-9)**: Orange
- **Operators (+, -, *, /, =)**: Red  
- **Brackets/Braces**: Blue
- **Punctuation**: Purple
- **Quotes**: Yellow
- **Underscore**: Green

## Testing Strategy

### Manual Testing Checklist
- [ ] Keyboard appears when tapped in text fields
- [ ] All symbols insert correctly
- [ ] Color coding is visible and consistent
- [ ] Keyboard responds to orientation changes
- [ ] Settings sync between main app and extension
- [ ] Performance is smooth during typing

### Test Apps for Keyboard
- Notes app
- Xcode (for real-world programming test)
- Safari address bar
- Mail compose
- Any third-party code editor

## App Store Requirements

### When Ready for Distribution
- [ ] App screenshots showing keyboard in use
- [ ] Privacy policy explaining keyboard data usage
- [ ] Clear description of "Allow Full Access" requirement
- [ ] Proper app metadata and keywords
- [ ] Compliance with Apple's keyboard extension guidelines

## Known Technical Considerations

1. **Keyboard Extensions Limitations**:
   - Must run on actual iOS device (not simulator)
   - Require "Allow Full Access" for network/data sharing
   - Memory constraints are stricter than main apps
   - Limited access to some iOS APIs

2. **Data Sharing**:
   - Use App Groups for sharing data between main app and extension
   - Core Data container must be in shared App Group container

3. **Performance**:
   - Keyboard responsiveness is critical
   - Minimize memory footprint
   - Efficient view rendering

## Debugging Tips

1. **Extension Debugging**:
   - Attach debugger to keyboard extension target
   - Use `os_log` for logging in extensions
   - Check device logs for crash reports

2. **Common Issues**:
   - Provisioning profile issues with extensions
   - App Group configuration problems
   - Core Data container path issues

## Next Steps Priority

1. **Immediate**: Add keyboard extension target to Xcode project
2. **Phase 2**: Implement basic keyboard with standard layout
3. **Phase 3**: Add programmer-specific symbol layout
4. **Phase 4**: Implement settings and customization
5. **Final**: Polish, testing, and App Store preparation