import FirebaseFirestoreSwift
import Foundation

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var isAdmin: Bool
    var roomCode: String?
    var settings: UserSettings
    
    struct UserSettings: Codable {
        var reminders: [Reminder]
        var treatmentTimerEnabled: Bool
    }
}

struct Cycle: Identifiable, Codable {
    @DocumentID var id: String?
    var patientName: String
    var number: Int
    var startDate: Date
    var challengeDate: Date
    var items: [CycleItem]
    
    var weeksDuration: Int {
        Calendar.current.dateComponents([.weekOfYear], from: startDate, to: challengeDate).weekOfYear ?? 0
    }
}

struct CycleItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: ItemCategory
    var baseDose: Double?
    var unit: String?
    var weeklyDoses: [Int: Double]?
    var isCompleted = false
    
    enum ItemCategory: String, CaseIterable, Codable {
        case medicine, maintenance, treatment, recommended
    }
}

struct LogEntry: Identifiable, Codable {
    @DocumentID var id: String?
    var itemId: String
    var timestamp: Date
    var userId: String
    var category: CycleItem.ItemCategory
}

struct Reminder: Identifiable, Codable {
    var id = UUID().uuidString
    var isEnabled: Bool
    var time: Date
    var category: CycleItem.ItemCategory
}
