import Foundation

import UIKit
import UserNotifications
import os
import CocoaMQTT

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let logger = Logger()
    let notificationManager = NotificationManager()
    var mqttManager = MQTTManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        mqttManager.mqttClient.delegate = self
    
        notificationManager.requestAuthorization { granted, error in
            self.authorizationCompletionHandler(granted, error)
        }
        
        return true
    }
    
    func authorizationCompletionHandler(_ granted: Bool, _ error: Error?) -> Void {
        if let error = error {
            logger.error("Failed to register for local notifications: \(error)")
        } else {
            logger.info("Successfully registered for local notifications")
            mqttManager.authenticate()
            mqttManager.connect()
        }
    }
}

extension AppDelegate: CocoaMQTT5Delegate {
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        if ack == .success {
            if(connAckData != nil){
                logger.info("properties maximumPacketSize: \(String(describing: connAckData!.maximumPacketSize))")
                logger.info("properties topicAliasMaximum: \(String(describing: connAckData!.topicAliasMaximum))")
            }
            
            mqtt5.ping()
            mqtt5.subscribe(Environment.mqttTopic, qos: CocoaMQTTQoS.qos0)
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
        if(publishData != nil){
            logger.info("publish.contentType \(String(describing: publishData!.contentType))")
        }
        
        let name = NSNotification.Name(rawValue: "MQTTMessageNotification")

        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        if(subAckData != nil){
            logger.info("subAckData.reasonCodes \(String(describing: subAckData!.reasonCodes))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        logger.info("Disconnected MQTT client")
        let name = NSNotification.Name(rawValue: "MQTTMessageNotificationDisconnect")
        NotificationCenter.default.post(name: name, object: nil)
    }
}
