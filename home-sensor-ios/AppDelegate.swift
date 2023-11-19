import Foundation

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
    
        notificationManager.requestAuthorization { granted, error in
            if let error = error {
                print("Failed to register for local notifications: \(error)")
            } else {
                print("Successfully registered for local notifications")
            }
        }
        
        return true
    }
}
