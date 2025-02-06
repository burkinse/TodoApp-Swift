import Foundation

// Görev Modeli
struct Task: Identifiable, Codable { // ✅ JSON için Codable ekledik
    let id: UUID
    var title: String
    var isCompleted: Bool
    var isStarred: Bool // 🌟 Yıldızlı görevler için eklendi
    var reminderDate: Date? // 📅 Hatırlatıcı tarihi ve saati

    // Varsayılan değerler için bir init fonksiyonu ekledik
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, isStarred: Bool = false, reminderDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isStarred = isStarred
        self.reminderDate = reminderDate
    }
}

// Klasör Modeli
struct Folder: Identifiable, Codable { // ✅ JSON için Codable ekledik
    let id: UUID
    var name: String
    var tasks: [Task]

    init(id: UUID = UUID(), name: String, tasks: [Task] = []) {
        self.id = id
        self.name = name
        self.tasks = tasks
    }
}

