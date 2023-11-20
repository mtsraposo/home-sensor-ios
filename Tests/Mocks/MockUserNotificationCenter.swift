import Foundation
import UserNotifications

class MockUserNotificationCenter: UNUserNotificationCenterProtocol {
    var authorizationGranted: Bool = false
    var authorizationError: Error?
    var notificationError: Error?
    var notificationRequest: UNNotificationRequest?
    var notificationSettings: NotificationSettingsProtocol?
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        if !authorizationGranted {
            authorizationError = NSError(domain: "Test", code: 1, userInfo: nil)
        }
        completionHandler(authorizationGranted, authorizationError)
    }
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        notificationRequest = request
        if request.content.body == "error" {
            notificationError = NSError(domain: "Test", code: 1, userInfo: nil)
            completionHandler?(notificationError)
        } else {
            completionHandler?(nil)
        }
    }
}
