import Foundation

// Görev Modeli
struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var isStarred: Bool = false // 🌟 Yıldızlı görevler için eklendi
    var reminderDate: Date? // 📅 Hatırlatıcı tarihi ve saati
}

// Klasör Modeli
struct Folder: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]
}

