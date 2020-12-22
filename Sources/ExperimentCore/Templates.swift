//
//  Templates.swift
//  ExperimentCore
//
//  Created by Matthew Hasler on 25/01/2020.
//

import Foundation

let packageTemplate: String = """
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "{{ name }}",
    dependencies: [
        //.package(url: "https://github.com/kylef/Commander.git", .exact("0.9.1")),
        //.package(url: "https://github.com/kareman/SwiftShell.git", .exact("5.1.0")),
    ],
    targets: [
        .target(name: "{{ name }}", dependencies: ["{{ name }}Core"]),
        .target(name: "{{ name }}Core", dependencies: []),
        .testTarget(name: "{{ name }}CoreTests", dependencies: ["{{ name }}Core"]),
    ]
)
"""

let mainTemplate: String = """
import {{ name }}Core

do {
    let {{ name.lower }} = try {{ name }}()
    try {{ name.lower }}.run()
} catch {
    print(error)
}
"""

let coreTemplate: String = """
public struct {{ name }} {

    public init() throws {}

    public func run() throws {
        print("run")
    }

}
"""

let coreTestTemplate: String = """
import XCTest
@testable import {{ name }}Core

final class {{ name }}Tests: XCTestCase {

    func testExample() throws {

        let sut = try {{ name }}()
        try sut.run()
    }

}
"""

let gitignoreText: String = """
.DS_Store
/.build
/Packages
*~
"""
