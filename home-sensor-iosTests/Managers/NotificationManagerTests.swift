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
    
    override func tearDown() {
        notificationManager = nil
        mockUserNotificationCenter = nil
        mockApplication = nil
        super.tearDown()
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
    
    func testRegisterForRemoteNotifications_Unauthorized() {
        mockUserNotificationCenter.authorizationGranted = false
        let expectation = self.expectation(description: "Completion handler invoked")
        notificationManager.registerForRemoteNotifications { error in
            XCTAssertNotNil(error)
            XCTAssertFalse(self.mockApplication.didRegisterForRemoteNotifications)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAuthorizationCompletionHandler_AuthorizationGranted() {
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
        let handler = notificationManager.authorizationCompletionHandler { error in
            XCTAssertNil(error)
            XCTAssertTrue(self.mockApplication.didRegisterForRemoteNotifications)
            expectation.fulfill()
        }

        handler(true)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAuthorizationCompletionHandler_Unauthorized() {
        let expectation = self.expectation(description: "Handler called")
        let handler = notificationManager.authorizationCompletionHandler { error in
            if let error = error as? NSError {
                    XCTAssertEqual(error.code, 1)
                    expectation.fulfill()
                } else {
                    XCTFail("Error should be of type NSError")
                }
        }

        handler(false)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSettingsCompletionHandler_AuthorizationGranted() {
        let expectation = self.expectation(description: "Completion handler called")
        let handler = notificationManager.settingsCompletionHandler {error in
            XCTAssertNil(error)
            XCTAssertTrue(self.mockApplication.didRegisterForRemoteNotifications)
            expectation.fulfill()
        }
        handler(MockNotificationSettings(
            authorizationStatus: .authorized,
            soundSetting: .enabled,
            badgeSetting: .enabled,
            lockScreenSetting: .enabled,
            carPlaySetting: .enabled,
            alertSetting: .enabled,
            alertStyle: .banner
        ))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSettingsCompletionHandler_Unauthorized() {
        let expectation = self.expectation(description: "Completion handler called")
        let handler = notificationManager.settingsCompletionHandler {error in
            if let error = error as? NSError {
                XCTAssertEqual(error.code, 2)
                expectation.fulfill()
            } else {
                XCTFail("Error should be of type NSError")
            }
        }
        handler(MockNotificationSettings(
            authorizationStatus: .denied,
            soundSetting: .enabled,
            badgeSetting: .enabled,
            lockScreenSetting: .enabled,
            carPlaySetting: .enabled,
            alertSetting: .enabled,
            alertStyle: .banner
        ))
        waitForExpectations(timeout: 1, handler: nil)
    }
}
