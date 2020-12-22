// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Experiment",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", .exact("0.9.1")),
        .package(url: "https://github.com/kareman/SwiftShell.git", .exact("5.1.0")),
    ],
    targets: [
        .target(name: "Experiment", dependencies: ["ExperimentCore", "Commander"]),
        .target(name: "ExperimentCore", dependencies: ["SwiftShell"]),
    ]
)
