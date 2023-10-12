import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    
    private let userNotificationCenter: UserNotificationCenter
    private let application: Application
    
    init(userNotificationCenter: UserNotificationCenter = UNUserNotificationCenter.current(),
         application: Application = UIApplication.shared) {
        self.userNotificationCenter = userNotificationCenter
        self.application = application
    }
    
    func registerForRemoteNotifications(completion: @escaping (Error?) -> Void) {
        self.requestAuthorization(
            completion: self.authorizationCompletionHandler(
                completion: completion
            )
        )
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        self.userNotificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) {
            granted, error in
            completion(granted)
        }
    }

    func authorizationCompletionHandler(completion: @escaping (Error?) -> Void) -> (Bool) -> Void {
        return { granted in
            guard granted else {
                completion(
                    NSError(
                        domain: Environment.appDomain,
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey : "Authorization not granted"]
                    )
                )
                return
            }
            self.getNotificationSettings(
                completion: self.settingsCompletionHandler(
                    completion: completion
                )
            )
        }
    }
    
    func getNotificationSettings(completion: @escaping (NotificationSettingsProtocol) -> Void) {
        self.userNotificationCenter.fetchNotificationSettings { settings in
            completion(settings)
        }
    }

    func settingsCompletionHandler(completion: @escaping (Error?) -> Void) -> (NotificationSettingsProtocol) -> Void {
        return { settings in
            guard settings.authorizationStatus == .authorized else {
                completion(NSError(domain: Environment.appDomain, code: 2, userInfo: [NSLocalizedDescriptionKey : "Authorization status not authorized"]))
                return
            }
            DispatchQueue.main.async {
                self.application.registerForRemoteNotifications()
                completion(nil)
            }
        }
    }
}
