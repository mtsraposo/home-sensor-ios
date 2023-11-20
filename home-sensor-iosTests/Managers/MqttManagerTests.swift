import XCTest
import CocoaMQTT
@testable import home_sensor_ios

class MqttManagerTests: XCTestCase {
    var mqttManager = MQTTManager.shared
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
    
    func testDidReceiveMessage_Success() {
        let message = "Test message"
        let mqttMessage = CocoaMQTT5Message(topic: "test-mqtt-topic", string: message)
        let decode = MqttDecodePublish()
        mqttManager.didReceiveMessage(mockCocoaMQTT5, didReceiveMessage: mqttMessage, id: 1, decode)
        
        let content = UNMutableNotificationContent()
        content.title = "Presence"
        content.body = message
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "home_sensor", content: content, trigger: nil)
        
        XCTAssertEqual(self.mockUserNotificationCenter.notificationRequest, request)
    }
    
    func testDidReceiveMessage_Error() {
        let message = "error"
        let mqttMessage = CocoaMQTT5Message(topic: "test-mqtt-topic", string: message)
        let decode = MqttDecodePublish()
        mqttManager.didReceiveMessage(mockCocoaMQTT5, didReceiveMessage: mqttMessage, id: 1, decode)
    
        XCTAssertNotNil(self.mockUserNotificationCenter.notificationError)
    }
    
    func testSubscribe_Success() {
        mqttManager.subscribe()
        XCTAssertTrue(mockCocoaMQTT5.subscribed)
    }
    
    func testConnect_Success() {
        mqttManager.connect()
        XCTAssertTrue(mockCocoaMQTT5.connected)
    }
    
    func testExtractP12Data_Success() {
        let p12Data = mqttManager.extractP12Data(certName: Environment.mqttCertificateFileName)
        XCTAssertTrue(p12Data!.length > 0)
    }
    
    func testExtractP12Data_Failure() {
        let p12Data = mqttManager.extractP12Data(certName: "invalid-certificate")
        XCTAssertNil(p12Data)
    }
    
    func testReadP12File_Success() {
        let p12Data = mqttManager.extractP12Data(certName: Environment.mqttCertificateFileName)
        let theArray = mqttManager.readP12File(p12Data: p12Data!, certPassword: Environment.mqttCertificatePassword)
        XCTAssertTrue(CFArrayGetCount(theArray) > 0)
    }
    
    func testReadP12File_Failure() {
        let p12Data = mqttManager.extractP12Data(certName: Environment.mqttCertificateFileName)
        let theArray = mqttManager.readP12File(p12Data: p12Data!, certPassword: "wrong-pass")
        XCTAssertNil(theArray)
    }
    
    func testGetClientCertFromP12File_Success() {
        let clientCertArray = mqttManager.getClientCertFromP12File(
            certName: Environment.mqttCertificateFileName,
            certPassword: Environment.mqttCertificatePassword
        )
        XCTAssertNotNil(clientCertArray)
    }
    
    func testGetClientCertFromP12File_Failure() {
        let clientCertArray = mqttManager.getClientCertFromP12File(
            certName: "wrong-cert",
            certPassword: "wrong-pass"
        )
        XCTAssertNil(clientCertArray)
    }
    
    
    func testAuthenticate_Success() {
        mqttManager.authenticate()
        XCTAssertTrue(mockCocoaMQTT5.enableSSL)
        XCTAssertNotNil(mockCocoaMQTT5.sslSettings)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
