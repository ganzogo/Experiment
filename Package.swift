// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Experiment",
    dependencies: [
        .package(url: "https://github.com/kareman/SwiftShell.git", .exact("4.1.2")),
    ],
    targets: [
        .target(name: "Experiment", dependencies: ["ExperimentCore"]),
	.target(name: "ExperimentCore", dependencies: ["SwiftShell"]),
        .testTarget(name: "ExperimentCoreTests", dependencies: ["ExperimentCore"]),
    ]
)
