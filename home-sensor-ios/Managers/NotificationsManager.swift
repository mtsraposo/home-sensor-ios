import Foundation
import UserNotifications
import UIKit

class NotificationManager {

    private let userNotificationCenter: UNUserNotificationCenter

    init(userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.userNotificationCenter = userNotificationCenter
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        self.userNotificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            completion(granted, error)
        }
    }
}
