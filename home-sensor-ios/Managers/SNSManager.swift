import Foundation

import AWSCore
import AWSSNS

class SNSManager {
    private let sns: SNSService

    init(sns: SNSService? = nil) {
        if let providedSNS = sns {
            self.sns = providedSNS
        } else {
            let credentialsProvider = AWSStaticCredentialsProvider(accessKey: Environment.snsAccessKey, secretKey: Environment.snsSecretKey)
            let configuration = AWSServiceConfiguration(region: .SAEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            self.sns = AWSSNS.default()
        }
    }
    
    func subscribeDeviceToTopic(deviceToken: Data, completion: @escaping (Error?) -> Void) {
        let token = buildToken(deviceToken)
        let subscribeInput = buildSubscribeInput(token)
        
        self.sns.subscribe(subscribeInput!).continueWith { (task) -> Any? in
            if let error = task.error {
                completion(error)
            } else {
                completion(nil)
            }
            return nil
        }
    }
    
    func buildToken(_ deviceToken: Data) -> String {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        return tokenParts.joined()
    }
    
    func buildSubscribeInput(_ token: String) -> AWSSNSSubscribeInput? {
        let subscribeInput = AWSSNSSubscribeInput()
        subscribeInput?.topicArn = Environment.snsTopicArn
        subscribeInput?.protocols = "application"
        subscribeInput?.endpoint = token
        
        return subscribeInput
    }
}
