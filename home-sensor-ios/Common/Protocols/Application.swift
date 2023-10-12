import Foundation
import UIKit

protocol Application {
    func registerForRemoteNotifications()
}

extension UIApplication: Application { }
