import Foundation

// Task Model
struct Task: Identifiable, Codable { // ✅ Added Codable for JSON support
    let id: UUID
    var title: String
    var isCompleted: Bool
    var isStarred: Bool // 🌟 Added for starred tasks
    var reminderDate: Date? // 📅 Reminder date and time

    // Added an init function for default values
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, isStarred: Bool = false, reminderDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isStarred = isStarred
        self.reminderDate = reminderDate
    }
}

// Folder Model
struct Folder: Identifiable, Codable { // ✅ Added Codable for JSON support
    let id: UUID
    var name: String
    var tasks: [Task]

    init(id: UUID = UUID(), name: String, tasks: [Task] = []) {
        self.id = id
        self.name = name
        self.tasks = tasks
    }
}

