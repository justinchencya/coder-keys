# Programmer Keyboard for iOS

A custom iOS keyboard extension designed specifically for programmers, featuring easy access to numbers, brackets, operators, and common programming symbols on the same page as alphabets.

## Features

- **Single Page Layout**: All commonly used programming keys are accessible without switching between keyboard pages
- **Python-Inspired Color Coding**: 
  - Numbers (0-9): Orange
  - Operators (+, -, *, /, =): Red
  - Brackets ([, ], (, ), {, }, <, >): Blue
  - Punctuation (., ,, ;, :): Purple
  - Underscore (_): Green
  - Quotes (", '): Yellow
- **Standard iOS Appearance**: Maintains the familiar iOS keyboard look and feel
- **Full Access Support**: Enables advanced features like autocorrect and predictive text

## Keyboard Layout

The keyboard is organized in the following layout:

```
Q W E R T Y U I O P
 A S D F G H J K L
  Z X C V B N M

0 1 2 3 4 5 6 7 8 9
+ - * / = ( ) [ ] { }
< > . , ; : _ " '
🌐 [    space    ] ⌫ ↵
```

## Quick Start

### Option 1: Use the Project Generator (Recommended)

1. **Generate the Xcode Project**:
   ```bash
   ./create_xcode_project.sh
   ```

2. **Open in Xcode**:
   - Open `ProgrammerKeyboard.xcodeproj` in Xcode
   - Select your development team in project settings
   - Build and run on your device

### Option 2: Manual Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd programmer-keyboard
   ```

2. **Generate the Xcode project**:
   ```bash
   ./create_xcode_project.sh
   ```

3. **Open in Xcode** and configure your development team

## Installation & Setup

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- iOS Developer Account (for device testing)

### Building the Project

1. Open `ProgrammerKeyboard.xcodeproj` in Xcode
2. Select your development team in the project settings
3. Build and run the project on your device (keyboard extensions cannot be tested in the simulator)

### Enabling the Keyboard

1. Install the app on your device
2. Go to **Settings** > **General** > **Keyboard** > **Keyboards**
3. Tap **Add New Keyboard**
4. Select **Programmer Keyboard**
5. Tap on **Programmer Keyboard** and enable **Allow Full Access**
6. Switch to the keyboard in any text field using the globe button (🌐)

## Project Structure

```
programmer-keyboard/
├── Sources/                           # Source code directory
│   ├── ProgrammerKeyboard/           # Main app source files
│   │   ├── AppDelegate.swift         # App delegate
│   │   ├── SceneDelegate.swift       # Scene delegate
│   │   ├── ViewController.swift      # Main view controller
│   │   ├── Main.storyboard          # Main app interface
│   │   ├── LaunchScreen.storyboard  # Launch screen
│   │   ├── Info.plist               # Main app configuration
│   │   └── Assets.xcassets/         # App assets
│   └── ProgrammerKeyboardExtension/ # Keyboard extension source files
│       ├── KeyboardViewController.swift # Keyboard controller
│       ├── KeyboardView.swift       # Custom keyboard layout
│       └── Info.plist               # Extension configuration
├── ProgrammerKeyboard.xcodeproj/     # Xcode project (generated)
├── Package.swift                     # Swift Package Manager file
├── create_xcode_project.sh          # Project generation script
├── build.sh                         # Build script
└── README.md                        # This file
```

## Technical Details

### Main App
- **Target**: iOS Application
- **Deployment Target**: iOS 17.0
- **Language**: Swift
- **Interface**: Storyboard-based

### Keyboard Extension
- **Target**: Custom Keyboard Extension
- **Deployment Target**: iOS 17.0
- **Language**: Swift
- **Interface**: Programmatic UI

### Key Features
- **Protocol-Based Design**: Clean separation between keyboard view and controller
- **Auto Layout**: Responsive design that adapts to different screen sizes
- **Visual Feedback**: Button animations for better user experience
- **Accessibility**: Proper button sizing and touch targets

## Customization

### Adding New Keys
To add new programming symbols, modify the `programmerKeys` array in `Sources/ProgrammerKeyboardExtension/KeyboardView.swift`:

```swift
private let programmerKeys = [
    ("new_symbol", UIColor.systemColor),
    // ... existing keys
]
```

### Changing Colors
Modify the color assignments in the `programmerKeys` array to match your preferred color scheme.

### Layout Adjustments
Adjust the layout constants in `Sources/ProgrammerKeyboardExtension/KeyboardView.swift`:
- `keyHeight`: Height of each key
- `keySpacing`: Horizontal spacing between keys
- `rowSpacing`: Vertical spacing between rows

## Development Workflow

1. **Make changes** to Swift files in the `Sources/` directory
2. **Regenerate the Xcode project** if you add/remove files:
   ```bash
   ./create_xcode_project.sh
   ```
3. **Build and test** in Xcode

## Troubleshooting

### Common Issues

1. **Keyboard not appearing**: Ensure "Allow Full Access" is enabled in Settings
2. **Build errors**: Check that your development team is properly configured
3. **Keyboard crashes**: Verify that all required permissions are granted
4. **Project won't open**: Regenerate the project using `./create_xcode_project.sh`

### Debugging
- Use Xcode's console to view keyboard extension logs
- Test on physical device (keyboard extensions don't work in simulator)
- Check device logs for any crash reports

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve the keyboard.

### Development Guidelines
1. Make changes in the `Sources/` directory
2. Test your changes thoroughly
3. Update documentation as needed
4. Submit a pull request with clear description of changes

## License

This project is open source and available under the MIT License.

## Support

For support or questions, please open an issue in the project repository.
