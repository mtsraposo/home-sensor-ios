import Foundation

class MockApplication: Application {
    var didRegisterForRemoteNotifications = false
    
    func registerForRemoteNotifications() {
        didRegisterForRemoteNotifications = true
    }
}
