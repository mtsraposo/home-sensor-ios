import Foundation
import UserNotifications

class MockUserNotificationCenter: UNUserNotificationCenter {
    var authorizationGranted: Bool = false
    var authorizationError: Error?
    var notificationSettings: NotificationSettingsProtocol?
    
    public init() {
    }
    
    override func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(authorizationGranted, authorizationError)
    }
}
