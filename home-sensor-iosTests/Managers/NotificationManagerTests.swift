import XCTest
@testable import home_sensor_ios

class NotificationManagerTests: XCTestCase {
    
    var notificationManager: NotificationManager!
    var mockUserNotificationCenter: MockUserNotificationCenter!

    override func setUp() {
        super.setUp()
        notificationManager = NotificationManager(
            userNotificationCenter: mockUserNotificationCenter
        )
        mockUserNotificationCenter = MockUserNotificationCenter()
    }
    
    override func tearDown() {
        notificationManager = nil
        mockUserNotificationCenter = nil
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
            XCTAssertNotNil(error)
            XCTAssertFalse(granted)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
