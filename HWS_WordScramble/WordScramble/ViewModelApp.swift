import SwiftUI

class ViewModelApp: ObservableObject {
    
    @Published var usedWords = [String]()
    @Published var rootWord = ""
    @Published var newWord = ""
    
    @Published var errorTitle = ""
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var currentWord: String?
    
    @Published var score = 0
    @Published var hasInitialized = false
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard shortWord(word: answer) else {
            wordError(title: "That's obvious", message: "Try a bettet combination")
            return
        }
        
        withAnimation {
            score += answer.count
            usedWords.insert(answer, at: 0)
        }
        newWord = " "
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                currentWord = rootWord

                // If we are here everything has worked, so we can exit
                return
            }
//            guard !hasInitialized else { return }
//            print("guard.hasInitialized: \(hasInitialized)")
        }
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var  tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func shortWord(word: String) -> Bool {
        let  temp = rootWord
        
        return !(word.count <= 2 || word == temp)
    }
    
    func startOver() {
        usedWords = [String]()
        newWord = ""
        score = 0
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func initializeIfNeeded() {
        guard !hasInitialized else { return }
        startGame()  // As an example, starting the game
        hasInitialized = true
    }
}
