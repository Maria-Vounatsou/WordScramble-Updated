import Foundation
import SwiftUI


//Define a struct to hold both the score and the associated word
struct ScoreEntry: Codable, Identifiable {
    var id: UUID
    let word: String
    let score: Int
    let date: Date
    
    init(word: String, score: Int, id: UUID? = nil) {
            self.word = word
            self.score = score
            self.id = id ?? UUID()
            self.date = Date()
        }
    
    enum CodingKeys: String, CodingKey {
        case id, word, score, date
    }
}

extension Date {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()

    var formattedShort: String {
        return Date.dateFormatter.string(from: self)
    }
}

class ScoreViewModel: ObservableObject {
    //
       private var recentlyDeletedItem: ScoreEntry? // Store the last deleted item
       private var deleteIndex: Int?   // Store the index for undo purposes
    
    @Published var scores: [ScoreEntry] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(scores) {
                UserDefaults.standard.set(encoded, forKey: "SavedScores")
            }
        }
    }
    
    init() {
        if let savedScores = UserDefaults.standard.data(forKey: "SavedScores") {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([ScoreEntry].self, from: savedScores) {
                self.scores = loadedScores
            }
        }
    }
    
    func addScore(newScore: Int, word: String) {
        let entry = ScoreEntry(word: word, score: newScore)
        scores.append(entry)
    }
    
    
    func deleteScores(at offsets: IndexSet) {
           guard let index = offsets.first else { return }
           recentlyDeletedItem = scores[index] // Save the deleted item
           deleteIndex = index   // Save the index
           scores.remove(atOffsets: offsets)
       }
    
    func undoDelete() {
            guard let undoItem = recentlyDeletedItem, let index = deleteIndex else { return }
            scores.insert(undoItem, at: index)  // Reinsert the item at the original index
            recentlyDeletedItem = nil           // Reset temporary state
            deleteIndex = nil
        }
    }
