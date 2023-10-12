import Foundation
import AWSSNS

class MockSNSService: SNSService {
    var shouldFail = false
    
    func subscribe(_ input: AWSSNSSubscribeInput) -> AWSTask<AWSSNSSubscribeResponse> {
        if shouldFail {
            return AWSTask(error: NSError(domain: "Test", code: 1, userInfo: nil))
        } else {
            return AWSTask(result: AWSSNSSubscribeResponse())
        }
    }
}
