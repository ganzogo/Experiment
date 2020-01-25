import Foundation

final class Dictionary {
    
    enum Error: Swift.Error {
        case randomWordGenerationFailed
    }
    
    private let words: [String]
    
    init(url: URL) throws {
        
        self.words = try String(contentsOf: url)
            .split(separator: "\n")
            .map(String.init)
    }
    
    func randomWord(minimumLength: Int) -> String? {
        
        return words
            .filter { $0.count >= minimumLength }
            .filter { $0.containsOnlyLetters }
            .randomElement()?
            .lowercased()
    }
    
}

private extension CharacterSet {
    
    static let simpleLetters: CharacterSet = {

        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        return CharacterSet(charactersIn: alphabet + alphabet.uppercased())
    }()

}

private extension String {
    
    var containsOnlyLetters: Bool {
        return self.trimmingCharacters(in: .simpleLetters).isEmpty
    }
    
}

extension Dictionary {
    
    static func randomWord() throws -> String {
        
        let dictionaryPath = "/usr/share/dict/words"
        let dictionaryURL = URL(fileURLWithPath: dictionaryPath)
        let dictionary = try Dictionary(url: dictionaryURL)
        guard let word = dictionary.randomWord(minimumLength: 5) else {
            throw Error.randomWordGenerationFailed
        }
        return word
    }
    
}
