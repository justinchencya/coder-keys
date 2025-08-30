#!/usr/bin/env python3
"""
Programmer Keyboard Demo
This script demonstrates the keyboard layout and color coding visually in the terminal.
"""

import os

def print_colored(text, color, background=None):
    """Print text with specified color and background."""
    if background:
        return f"{color}{background}{text}\033[0m"
    return f"{color}{text}\033[0m"

def demo_keyboard_layout():
    """Demonstrate the programmer keyboard layout with colors."""
    
    print("🎹 Programmer Keyboard Layout Demo")
    print("=" * 50)
    print()
    
    # Alphabet rows
    print("📝 Alphabet Keys (Standard Gray):")
    print("Q W E R T Y U I O P")
    print(" A S D F G H J K L")
    print("  Z X C V B N M")
    print()
    
    # Numbers (Orange)
    print("🔢 Numbers (Orange):")
    numbers = "0 1 2 3 4 5 6 7 8 9"
    colored_numbers = " ".join([print_colored(n, "\033[37m", "\033[43m") for n in numbers.split()])
    print(colored_numbers)
    print()
    
    # Operators (Red)
    print("➕ Operators (Red):")
    operators = "+ - * / ="
    colored_operators = " ".join([print_colored(op, "\033[37m", "\033[41m") for op in operators.split()])
    print(colored_operators)
    print()
    
    # Brackets (Blue)
    print("🔗 Brackets (Blue):")
    brackets = "( ) [ ] { } < >"
    colored_brackets = " ".join([print_colored(bracket, "\033[37m", "\033[44m") for bracket in brackets.split()])
    print(colored_brackets)
    print()
    
    # Punctuation (Purple)
    print("📝 Punctuation (Purple):")
    punctuation = ". , ; :"
    colored_punctuation = " ".join([print_colored(p, "\033[37m", "\033[45m") for p in punctuation.split()])
    print(colored_punctuation)
    print()
    
    # Special characters
    print("✨ Special Characters:")
    special = "_ \" '"
    colored_special = " ".join([
        print_colored("_", "\033[37m", "\033[42m"),
        print_colored("\"", "\033[37m", "\033[43m"),
        print_colored("'", "\033[37m", "\033[43m")
    ])
    print(colored_special)
    print()
    
    # Function keys
    print("🔧 Function Keys (Gray):")
    print("🌐 [    space    ] ⌫ ↵")
    print()
    
    print("=" * 50)
    print("🎯 Key Features:")
    print("• All programming symbols on one page")
    print("• Python-inspired color coding")
    print("• Standard iOS keyboard appearance")
    print("• Easy access to numbers and operators")
    print("• No need to switch between keyboard pages")

def demo_color_coding():
    """Demonstrate the color coding system."""
    
    print("\n🎨 Color Coding System:")
    print("=" * 30)
    
    color_examples = [
        ("Numbers (0-9)", "\033[43m", "Orange"),
        ("Operators (+-*/=)", "\033[41m", "Red"),
        ("Brackets ([{<>}])", "\033[44m", "Blue"),
        ("Punctuation (.,;:)", "\033[45m", "Purple"),
        ("Underscore (_)", "\033[42m", "Green"),
        ("Quotes (\", ')", "\033[43m", "Yellow")
    ]
    
    for description, color, name in color_examples:
        print(f"{color} {description} \033[0m = {name}")

def main():
    """Main demo function."""
    try:
        demo_keyboard_layout()
        demo_color_coding()
        
        print("\n🚀 To use this keyboard:")
        print("1. Run: ./create_xcode_project.sh")
        print("2. Open ProgrammerKeyboard.xcodeproj in Xcode")
        print("3. Build and run on your iOS device")
        print("4. Enable the keyboard in Settings > Keyboard")
        
    except Exception as e:
        print("❌ Error occurred. Running without colors...")
        print(f"Error: {e}")
        
        # Fallback without colors
        print("🎹 Programmer Keyboard Layout Demo")
        print("=" * 50)
        print("\n📝 Alphabet Keys:")
        print("Q W E R T Y U I O P")
        print(" A S D F G H J K L")
        print("  Z X C V B N M")
        print("\n🔢 Numbers: 0 1 2 3 4 5 6 7 8 9")
        print("➕ Operators: + - * / =")
        print("🔗 Brackets: ( ) [ ] { } < >")
        print("📝 Punctuation: . , ; :")
        print("✨ Special: _ \" '")
        print("🔧 Function Keys: 🌐 [space] ⌫ ↵")
        
        print("\n🚀 To use this keyboard:")
        print("1. Run: ./create_xcode_project.sh")
        print("2. Open ProgrammerKeyboard.xcodeproj in Xcode")
        print("3. Build and run on your iOS device")
        print("4. Enable the keyboard in Settings > Keyboard")

if __name__ == "__main__":
    main()
