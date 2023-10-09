//
//  NotificationsManager.swift
//  home-sensor-ios
//
//  Created by Matheus Raposo on 09/10/23.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    
    func registerForRemoteNotifications(completion: @escaping (Error?) -> Void) {
        requestAuthorization { granted in
            guard granted else {
                completion(NSError(domain: Environment.appDomain, code: 1, userInfo: [NSLocalizedDescriptionKey : "Authorization not granted"]))
                return
            }
            
            self.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    completion(NSError(domain: Environment.appDomain, code: 2, userInfo: [NSLocalizedDescriptionKey : "Authorization status not authorized"]))
                    return
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    completion(nil)
                }
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
        }
    }
    
    func getNotificationSettings(completion: @escaping (UNNotificationSettings) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings)
        }
    }
}
