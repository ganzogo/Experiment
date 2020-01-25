import Foundation
import SwiftShell

public struct Experiment {
    
    enum Error: Swift.Error {
        case projectNameNotAvailable
        case randomWordGenerationFailed
    }

    public let name: String
    public let projectURL: URL
    
    public init(path: String, name: String?) throws {
        
        let url = URL(fileURLWithPath: path)
        
        if let name = name {
            
            let projectURL = url.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: projectURL.path) {
                throw Error.projectNameNotAvailable
            }
            
            self.name = name
            self.projectURL = projectURL
            
        } else {

            var name = try Dictionary.randomWord().titlecased()
            var projectURL = url.appendingPathComponent(name)
            
            while FileManager.default.fileExists(atPath: projectURL.path) {
                name = try Dictionary.randomWord().titlecased()
                projectURL = url.appendingPathComponent(try Dictionary.randomWord())
            }
            
            self.name = name
            self.projectURL = projectURL
        }
    }

    public func generate() throws {
        
        try FileManager.default.createDirectory(at: projectURL, withIntermediateDirectories: false, attributes: nil)
        FileManager.default.changeCurrentDirectoryPath(projectURL.path)
        run("swift", "package", "init", "--type", "executable")
        
        let packageURL = projectURL.appendingPathComponent("Package.swift")
        let packageSwift = packageTemplate.replacingOccurrences(of: "{{ name }}", with: name)
        try packageSwift.write(to: packageURL, atomically: true, encoding: .utf8)
        
        let mainURL = projectURL.appendingPathComponent("Sources").appendingPathComponent(name).appendingPathComponent("main.swift")
        let mainSwift = mainTemplate
            .replacingOccurrences(of: "{{ name }}", with: name)
            .replacingOccurrences(of: "{{ name.lower }}", with: name.lowercased())
        try mainSwift.write(to: mainURL, atomically: true, encoding: .utf8)
        
        let coreURL = projectURL.appendingPathComponent("Sources").appendingPathComponent("\(name)Core")
        try FileManager.default.createDirectory(at: coreURL, withIntermediateDirectories: false, attributes: nil)
        let coreFileURL = coreURL.appendingPathComponent("\(name).swift")
        let coreFileSwift = coreTemplate.replacingOccurrences(of: "{{ name }}", with: name)
        try coreFileSwift.write(to: coreFileURL, atomically: true, encoding: .utf8)
        
        try FileManager.default.removeItem(at: projectURL.appendingPathComponent("Tests").appendingPathComponent("\(name)Tests"))
        try FileManager.default.removeItem(at: projectURL.appendingPathComponent("Tests").appendingPathComponent("LinuxMain.swift"))
        let coreTestURL = projectURL.appendingPathComponent("Tests").appendingPathComponent("\(name)CoreTests")
        try FileManager.default.createDirectory(at: coreTestURL, withIntermediateDirectories: false, attributes: nil)
        let coreTestFileURL = coreTestURL.appendingPathComponent("\(name)Tests.swift")
        let coreTestFileSwift = coreTestTemplate.replacingOccurrences(of: "{{ name }}", with: name)
        try coreTestFileSwift.write(to: coreTestFileURL, atomically: true, encoding: .utf8)
    }

}

private extension String {

    func titlecased() -> String {
        
        if self.count <= 1 {
            return self.uppercased()
        }
        
        let regex = try! NSRegularExpression(pattern: "(?=\\S)[A-Z]", options: [])
        let range = NSMakeRange(1, self.count - 1)
        var titlecased = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " $0")
        
        for i in titlecased.indices {
            if i == titlecased.startIndex || titlecased[titlecased.index(before: i)] == " " {
                titlecased.replaceSubrange(i...i, with: String(titlecased[i]).uppercased())
            }
        }
        return titlecased
    }

}
