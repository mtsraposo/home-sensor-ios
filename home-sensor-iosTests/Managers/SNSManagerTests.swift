import XCTest
@testable import home_sensor_ios

class SNSManagerTests: XCTestCase {

    var snsManager: SNSManager!
    var mockSNSService: MockSNSService!
    var tokenData: Data!
    
    override func setUp() {
        super.setUp()
        mockSNSService = MockSNSService()
        snsManager = SNSManager(sns: mockSNSService)
        
        let tokenString = "fake-token"
        tokenData = Data(tokenString.utf8)
    }
    
    func testSubscribeDeviceToTopic_Success() {
        let expectation = self.expectation(description: "Completion handler invoked")
        snsManager.subscribeDeviceToTopic(deviceToken: tokenData) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSubscribeDeviceToTopic_Failure() {
        mockSNSService.shouldFail = true
        let expectation = self.expectation(description: "Completion handler invoked")
        snsManager.subscribeDeviceToTopic(deviceToken: tokenData) { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testBuildToken() {
        let token = snsManager.buildToken(tokenData)
        XCTAssertEqual(token, "66616b652d746f6b656e")
    }
    
    func testBuildSubscribeInput() {
        let token = "66616b652d746f6b656e"
        let subscribeInput = snsManager.buildSubscribeInput(token)
        
        XCTAssertNotNil(subscribeInput, "Subscribe input should not be nil")
        XCTAssertEqual(subscribeInput?.topicArn, "test.topic.json.v1", "The topic ARN should be correctly set")
        XCTAssertEqual(subscribeInput?.protocols, "application", "The protocol should be 'application'")
        XCTAssertEqual(subscribeInput?.endpoint, token, "The endpoint should be the provided token")
    }
    
    override func tearDown() {
        snsManager = nil
        mockSNSService = nil
        super.tearDown()
    }
}
