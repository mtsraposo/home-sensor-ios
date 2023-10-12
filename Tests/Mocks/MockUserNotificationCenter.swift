import Foundation
import UserNotifications

class MockUserNotificationCenter: UserNotificationCenter {
    var authorizationGranted: Bool = false
    var authorizationError: Error?
    var notificationSettings: NotificationSettingsProtocol?
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(authorizationGranted, authorizationError)
    }
    
    func fetchNotificationSettings(completionHandler: @escaping (NotificationSettingsProtocol) -> Void) {
        if let settings = notificationSettings {
            completionHandler(settings)
        }
    }
}
