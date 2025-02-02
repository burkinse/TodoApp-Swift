import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()

    // 📌 **Bildirim izni isteme (her açılışta kontrol eder)**
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Bildirim izni hatası: \(error.localizedDescription)")
                }
                if granted {
                    print("📢 Bildirim izni verildi!")
                } else {
                    print("❌ Kullanıcı bildirim izni vermedi!")
                }
            }
        }
    }

    // 📌 **Bildirim Planlama**
    func scheduleNotification(for task: Task) {
        guard let reminderDate = task.reminderDate else {
            print("⚠️ Hatırlatma tarihi ayarlanmadı!")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Hatırlatma"
        content.body = "\(task.title)"
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: 1) // 📌 Bildirimi zorlamak için badge ekliyoruz

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("✅ Bildirim başarıyla planlandı: \(task.title) - \(reminderDate)")
                self.listPendingNotifications() // 📌 Bekleyen bildirimleri otomatik listele
            }
        }
    }

    // 📌 **Bekleyen Bildirimleri Kontrol Et**
    func listPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📌 Bekleyen Bildirimler: \(requests.map { $0.identifier })")
        }
    }
}

