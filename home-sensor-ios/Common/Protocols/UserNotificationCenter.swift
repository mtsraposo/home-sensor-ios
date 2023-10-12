import Foundation

import UserNotifications

protocol UserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    func fetchNotificationSettings(completionHandler: @escaping (NotificationSettingsProtocol) -> Void)
}

extension UNUserNotificationCenter: UserNotificationCenter {
    func fetchNotificationSettings(completionHandler: @escaping (NotificationSettingsProtocol) -> Void) {
        getNotificationSettings { settings in
                completionHandler(settings)
            }
        }
}
