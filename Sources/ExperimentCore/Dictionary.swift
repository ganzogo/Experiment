import Foundation

final class Dictionary {
    
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
