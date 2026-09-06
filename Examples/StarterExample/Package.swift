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
    targets: [
        .target(name: "StarterExample"),
        .testTarget(
            name: "StarterExampleTests",
            dependencies: ["StarterExample"]
        ),
    ]
)
