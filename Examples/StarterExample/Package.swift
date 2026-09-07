// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StarterExample",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "StarterExample", targets: ["StarterExample"]),
    ],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        .target(
            name: "StarterExample",
            dependencies: [
                .product(name: "SwiftUIAIStarter", package: "swiftui-ai-starter"),
            ]
        ),
        .testTarget(
            name: "StarterExampleTests",
            dependencies: ["StarterExample"]
        ),
    ]
)
