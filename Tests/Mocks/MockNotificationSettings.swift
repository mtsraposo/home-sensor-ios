import Foundation
import UserNotifications

struct MockNotificationSettings: NotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus
    var soundSetting: UNNotificationSetting
    var badgeSetting: UNNotificationSetting
    var lockScreenSetting: UNNotificationSetting
    var carPlaySetting: UNNotificationSetting
    var alertSetting: UNNotificationSetting
    var alertStyle: UNAlertStyle
    
    init(authorizationStatus: UNAuthorizationStatus, soundSetting: UNNotificationSetting, badgeSetting: UNNotificationSetting, lockScreenSetting: UNNotificationSetting, carPlaySetting: UNNotificationSetting, alertSetting: UNNotificationSetting, alertStyle: UNAlertStyle) {
            self.authorizationStatus = authorizationStatus
            self.soundSetting = soundSetting
            self.badgeSetting = badgeSetting
            self.lockScreenSetting = lockScreenSetting
            self.carPlaySetting = carPlaySetting
            self.alertSetting = alertSetting
            self.alertStyle = alertStyle
        }
}
