// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftUIAIStarter",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "SwiftUIAIStarter", targets: ["SwiftUIAIStarter"]),
    ],
    targets: [
        .target(
            name: "SwiftUIAIStarter",
            path: "templates",
            exclude: [
                "Localization/Localizable.xcstrings",
                "README.md",
                "Tests",
            ]
        ),
        .testTarget(
            name: "SwiftUIAIStarterTests",
            dependencies: ["SwiftUIAIStarter"],
            path: "templates/Tests/AITests",
            exclude: ["Fixtures"]
        ),
    ]
)
