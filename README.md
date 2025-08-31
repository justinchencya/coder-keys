# Programmer Keyboard iOS App

A custom iOS keyboard extension designed specifically for programmers, featuring easy access to programming symbols and code snippets.

## Current State

This project is currently in **restoration phase** after being restructured. The current codebase contains:

- ✅ **Main App**: SwiftUI-based iOS app with Core Data integration
- ✅ **Project Structure**: Clean Xcode project with proper organization  
- ✅ **Build System**: Functional build configuration
- ❌ **Keyboard Extension**: Currently missing - needs to be restored

## Project Structure

```
programmer-keyboard/
├── ProgrammerKeyboard/                    # Main Xcode project directory
│   ├── ProgrammerKeyboard.xcodeproj/     # Xcode project file
│   ├── ProgrammerKeyboard/               # Main app source
│   │   ├── ProgrammerKeyboardApp.swift   # App entry point
│   │   ├── ContentView.swift             # Main SwiftUI view
│   │   ├── Persistence.swift             # Core Data stack
│   │   └── Assets.xcassets/              # App resources
│   ├── ProgrammerKeyboardTests/          # Unit tests
│   └── ProgrammerKeyboardUITests/        # UI tests
├── README.md                             # This file
└── CLAUDE.md                            # Development context & commands
```

## Planned Features

### Keyboard Extension Features
- **Single-page layout** - All programming symbols on main keyboard
- **Color-coded keys** - Visual distinction for different symbol types:
  - Numbers (0-9): Orange
  - Operators (+, -, *, /, =): Red
  - Brackets/Braces: Blue
  - Punctuation: Purple
  - Quotes: Yellow

### Main App Features
- **Settings interface** - Customize keyboard behavior
- **Snippet management** - Create and edit code snippets
- **Usage statistics** - Track most-used keys
- **Theme selection** - Multiple visual themes

## Development Status

### ✅ Phase 1: Project Foundation (Complete)
- [x] Git state cleanup
- [x] Build verification
- [x] Documentation creation

### 🚧 Phase 2: Keyboard Extension (In Progress) 
- [ ] Add keyboard extension target
- [ ] Create keyboard view controller
- [ ] Configure app groups
- [ ] Set up Info.plist

### ⏳ Phase 3: Programmer Features (Planned)
- [ ] Design programmer-friendly layout
- [ ] Add code snippet functionality  
- [ ] Implement symbol shortcuts
- [ ] Add theme support

### ⏳ Phase 4: Main App Enhancement (Planned)
- [ ] Replace Core Data template with settings
- [ ] Add keyboard customization screens
- [ ] Implement snippet management
- [ ] Add usage statistics

### ⏳ Phase 5: Testing & Polish (Planned)
- [ ] Comprehensive testing
- [ ] Performance optimization
- [ ] UI/UX refinement
- [ ] App Store preparation

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- Apple Developer account (for testing on device)

### Building the Project

1. Open the project:
   ```bash
   cd ProgrammerKeyboard
   open ProgrammerKeyboard.xcodeproj
   ```

2. Select your development team in project settings

3. Build and run on your iOS device (keyboard extensions don't work in simulator)

### Testing the Keyboard (Once Restored)
1. Install the app on your device
2. Go to **Settings > General > Keyboard > Keyboards**
3. Tap **Add New Keyboard**  
4. Select **Programmer Keyboard**
5. Enable **Allow Full Access**
6. Switch to the keyboard using the globe button (🌐)

## Contributing

This project is currently being restored from a previous implementation. Key areas for contribution:

- Keyboard extension implementation
- UI/UX design for programming workflow
- Symbol layout optimization
- Code snippet functionality
- Theme and customization features

## Technical Details

- **Platform**: iOS 17.0+
- **Language**: Swift 5.0
- **UI Framework**: SwiftUI
- **Data Storage**: Core Data
- **Architecture**: MVVM with SwiftUI

## License

This project is available for educational and personal use. Please check with the original authors before commercial use.