import Foundation
import AWSSNS

protocol SNSService {
    func subscribe(_ input: AWSSNSSubscribeInput) -> AWSTask<AWSSNSSubscribeResponse>
}

extension AWSSNS: SNSService {}


