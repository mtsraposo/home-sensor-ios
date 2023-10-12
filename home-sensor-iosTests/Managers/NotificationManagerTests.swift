import XCTest
@testable import home_sensor_ios

class NotificationManagerTests: XCTestCase {
    
    var notificationManager: NotificationManager!
    var mockUserNotificationCenter: MockUserNotificationCenter!
    var mockApplication: MockApplication!

    override func setUp() {
        super.setUp()
        mockUserNotificationCenter = MockUserNotificationCenter()
        mockApplication = MockApplication()
        notificationManager = NotificationManager(
            userNotificationCenter: mockUserNotificationCenter,
            application: mockApplication
        )
    }
    
    func testRegisterForRemoteNotifications_AuthorizationGranted() {
        mockUserNotificationCenter.authorizationGranted = true
        mockUserNotificationCenter.notificationSettings = MockNotificationSettings(
            authorizationStatus: .authorized,
            soundSetting: .enabled,
            badgeSetting: .enabled,
            lockScreenSetting: .enabled,
            carPlaySetting: .enabled,
            alertSetting: .enabled,
            alertStyle: .banner
        )

        
        let expectation = self.expectation(description: "Completion handler invoked")
        notificationManager.registerForRemoteNotifications { error in
            XCTAssertNil(error)
            XCTAssertTrue(self.mockApplication.didRegisterForRemoteNotifications)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
