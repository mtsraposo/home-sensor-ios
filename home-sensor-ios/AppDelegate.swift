import Foundation

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationManager = NotificationManager()
    let snsManager = SNSManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
    
        notificationManager.registerForRemoteNotifications { error in
            if let error = error {
                print("Failed to register for remote notifications: \(error)")
            } else {
                print("Successfully registered for remote notifications")
            }
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        snsManager.subscribeDeviceToTopic(deviceToken: deviceToken) { error in
            if let error = error {
                print("Error subscribing to topic: \(error)")
            } else {
                print("Successfully subscribed to topic")
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

