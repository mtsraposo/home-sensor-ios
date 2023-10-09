//
//  AppDelegate+Notification.swift
//  home-sensor-ios
//
//  Created by Matheus Raposo on 09/10/23.
//

import Foundation
import UserNotifications

extension AppDelegate {

    // When a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // handle the notification
        completionHandler([.alert, .sound, .badge])  // modify this to your needs
    }
    
    // When the user responds to a notification (for example by tapping on it)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // handle the response
        completionHandler()
    }
}
