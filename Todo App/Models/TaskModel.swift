import Foundation

// Görev Modeli
struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var reminderDate: Date? // 📅 Hatırlatıcı tarihi ve saati
}

// Klasör Modeli
struct Folder: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]
}

