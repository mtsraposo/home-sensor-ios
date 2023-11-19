import Foundation
import UserNotifications
import UIKit

class NotificationManager {

    var userNotificationCenter: UNUserNotificationCenterProtocol = UNUserNotificationCenter.current()

    init() {}

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        self.userNotificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            completion(granted, error)
        }
    }
}
