import XCTest
@testable import home_sensor_ios

class NotificationManagerTests: XCTestCase {
    
    var notificationManager = NotificationManager()
    var mockUserNotificationCenter = MockUserNotificationCenter()

    override func setUp() {
        super.setUp()
        notificationManager.userNotificationCenter = mockUserNotificationCenter
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRequestAuthorization_AuthorizationGranted() {
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
        notificationManager.requestAuthorization { granted, error in
            XCTAssertNil(error)
            XCTAssertTrue(granted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRequestAuthorization_Unauthorized() {
        mockUserNotificationCenter.authorizationGranted = false
        let expectation = self.expectation(description: "Completion handler invoked")
        notificationManager.requestAuthorization { granted, error in
            XCTAssertFalse(granted)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
