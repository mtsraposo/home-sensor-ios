import Foundation
import UserNotifications

protocol NotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus { get }
    var soundSetting: UNNotificationSetting { get }
    var badgeSetting: UNNotificationSetting { get }
    var lockScreenSetting: UNNotificationSetting { get }
    var carPlaySetting: UNNotificationSetting { get }
    var alertSetting: UNNotificationSetting { get }
    var alertStyle: UNAlertStyle { get }
}
