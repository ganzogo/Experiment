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
