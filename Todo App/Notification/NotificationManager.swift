import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()

    // 📌 **Request notification permission (checks on each startup)**
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                if granted {
                    print("📢 Notification permission granted!")
                } else {
                    print("❌ User did not grant notification permission!")
                }
            }
        }
    }

    // 📌 **Schedule Notification**
    func scheduleNotification(for task: Task) {
        guard let reminderDate = task.reminderDate else {
            print("⚠️ Reminder date is not set!")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "\(task.title)"
        content.sound = UNNotificationSound.default
        content.badge = NSNumber(value: 1) // 📌 Adding badge to force the notification

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error adding notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification successfully scheduled: \(task.title) - \(reminderDate)")
                self.listPendingNotifications() // 📌 Automatically list pending notifications
            }
        }
    }

    // 📌 **Check Pending Notifications**
    func listPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📌 Pending Notifications: \(requests.map { $0.identifier })")
        }
    }
}

