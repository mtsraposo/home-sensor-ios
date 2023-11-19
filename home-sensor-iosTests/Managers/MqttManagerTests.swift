import XCTest
@testable import home_sensor_ios

class MqttManagerTests: XCTestCase {
    var mqttManager = MQTTManager()
    var mockCocoaMQTT5 = MockCocoaMQTT5()
    var mockUserNotificationCenter = MockUserNotificationCenter()
    
    override func setUp() {
        super.setUp()
        mqttManager.mqttClient = mockCocoaMQTT5
        mqttManager.userNotificationCenter = mockUserNotificationCenter
    }
    
    func testTriggerLocalNotification_Success() {
        let expectation = self.expectation(description: "Immediately triggers a local notification with a message")
        let message = "Test message"
        let content = UNMutableNotificationContent()
        content.title = "Presence"
        content.body = message
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "home_sensor", content: content, trigger: nil)
        mqttManager.triggerLocalNotification(with: message) { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.mockUserNotificationCenter.notificationRequest, request)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testTriggerLocalNotification_Error() {
        let expectation = self.expectation(description: "Fails to trigger a local notification")
        mqttManager.triggerLocalNotification(with: "error") { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
