import Foundation

public struct Experiment {

    public init() {}
    
    public func run() throws {
        
        let path = "/usr/share/dict/words"
        let url = URL(fileURLWithPath: path)
        let dictionary = try Dictionary(url: url)
        guard let word = dictionary.randomWord(minimumLength: 5) else {
            fatalError()
        }
        print(word)
    }

}
