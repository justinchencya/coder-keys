#!/bin/bash

# Programmer Keyboard iOS Build Script
# This script helps build the iOS project from the command line

echo "🚀 Building Programmer Keyboard iOS Project..."

# Check if Xcode is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or not in PATH"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "ProgrammerKeyboard.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Clean build directory
echo "🧹 Cleaning build directory..."
xcodebuild clean -project ProgrammerKeyboard.xcodeproj -scheme ProgrammerKeyboard

# Build the project
echo "🔨 Building project..."
xcodebuild build -project ProgrammerKeyboard.xcodeproj -scheme ProgrammerKeyboard -destination generic/platform=iOS

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📱 To install on device:"
    echo "1. Open ProgrammerKeyboard.xcodeproj in Xcode"
    echo "2. Select your development team"
    echo "3. Build and run on your device"
    echo ""
    echo "🔧 To enable the keyboard:"
    echo "1. Install the app"
    echo "2. Go to Settings > General > Keyboard > Keyboards"
    echo "3. Add 'Programmer Keyboard'"
    echo "4. Enable 'Allow Full Access'"
else
    echo "❌ Build failed!"
    exit 1
fi
