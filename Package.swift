// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Tooltips",
    platforms: [
        .macOS("14.0"),
        .iOS("17.0"),
        .tvOS("17.0"),
        .watchOS("10.0"),
        .macCatalyst("17.0")
    ],
    products: [
        .library(
            name: "Tooltips",
            targets: ["Tooltips"]
        ),
        .iOSApplication(
            name: "Tooltips_Tests",
            targets: ["Tooltips_Tests"],
            teamIdentifier: "VKFDYMU9HJ",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .leaf),
            accentColor: .presetColor(.red),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .target(
            name: "Tooltips",
            path: "Tooltips"
        ),
        .executableTarget(
            name: "Tooltips_Tests",
            dependencies: [
                "Tooltips"
            ],
            path: "Tooltips_Tests"
        )
    ]
)
