//
//  SNSManager.swift
//  home-sensor-iosTests
//
//  Created by Matheus Raposo on 11/10/23.
//

import Foundation

import AWSCore
import AWSSNS

class SNSManager {
    private let sns: AWSSNS
    
    init() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: Environment.snsAccessKey, secretKey: Environment.snsSecretKey)
        let configuration = AWSServiceConfiguration(region: .SAEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        sns = AWSSNS.default()
    }
    
    func subscribeDeviceToTopic(deviceToken: Data, completion: @escaping (Error?) -> Void) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        let subscribeInput = AWSSNSSubscribeInput()
        subscribeInput?.topicArn = Environment.snsTopicArn
        subscribeInput?.protocols = "application"
        subscribeInput?.endpoint = token
        
        sns.subscribe(subscribeInput!).continueWith { (task) -> Any? in
            if let error = task.error {
                completion(error)
            } else {
                completion(nil)
            }
            return nil
        }
    }
}

