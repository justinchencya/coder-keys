// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProgrammerKeyboard",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ProgrammerKeyboard",
            targets: ["ProgrammerKeyboard"]),
        .library(
            name: "ProgrammerKeyboardExtension",
            targets: ["ProgrammerKeyboardExtension"]),
    ],
    targets: [
        .target(
            name: "ProgrammerKeyboard",
            dependencies: []),
        .target(
            name: "ProgrammerKeyboardExtension",
            dependencies: []),
    ]
)
