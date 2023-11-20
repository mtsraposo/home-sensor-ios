import Foundation
import CocoaMQTT
import Security
import os

class MQTTManager {
    static let shared = MQTTManager()
    var mqttClient: CocoaMQTT5Protocol = CocoaMQTT5(
        clientID: Environment.mqttClientId,
        host: Environment.mqttServer,
        port: Environment.mqttPort!
    )
    
    let logger = Logger()
    var userNotificationCenter: UNUserNotificationCenterProtocol = UNUserNotificationCenter.current()

    init() {
        self.mqttClient.didReceiveMessage = self.didReceiveMessage
        self.mqttClient.autoReconnect = true
        self.mqttClient.keepAlive = 90
        self.mqttClient.logLevel = .debug
    }
    
    func didReceiveMessage(_ mqtt: CocoaMQTT5Protocol, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, _ decode: MqttDecodePublish?) {
        logger.info("Received message: \(message.string!)")
        guard let presenceMessage = decodePayload(message) else { return }
        self.triggerLocalNotification(with: presenceMessage.body) { error in
            if let error = error {
                self.logger.error("Error scheduling local notification: \(error)")
            } else {
                self.logger.info("Successfully triggered local notification")
            }
        }
    }
    
    func decodePayload(_ message: CocoaMQTT5Message) -> PresenceMessage?  {
        guard let data = message.string!.data(using: .utf8)
        else {
            logger.error("Payload received is not a UTF-8 string")
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: [])
        else {
            logger.error("Payload received is not a JSON")
            return nil
        }
        guard let message = PresenceMessage(json: json as! [String : Any])
        else {
            logger.error("Malformed payload")
            return nil
        }
        return message
    }

    func triggerLocalNotification(with message: String?, completion: @escaping (Error?) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Presence"
        content.body = message ?? ""
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "home_sensor", content: content, trigger: nil)
        self.userNotificationCenter.add(request) { error in
            completion(error)
        }
    }
    
    func connect() {
        if !self.mqttClient.connect() {
            logger.error("Failed to connect MQTT client.")
            return
        }
        logger.info("Successfully connected to MQTT client.")
    }

    func subscribe() {
        self.mqttClient.subscribe(Environment.mqttTopic, qos: .qos0)
        logger.info("Successfully subscribed to MQTT topic.")
    }

    func authenticate() {
        self.mqttClient.enableSSL = true
        let clientCertArray = getClientCertFromP12File(
            certName: Environment.mqttCertificateFileName, 
            certPassword: Environment.mqttCertificatePassword
        )
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        self.mqttClient.sslSettings = sslSettings
    }
    
    func getClientCertFromP12File(certName: String, certPassword: String) -> CFArray? {
        guard let p12Data = extractP12Data(certName: certName) else {
            return nil
        }
        
       guard let theArray = readP12File(p12Data: p12Data, certPassword: certPassword),
                CFArrayGetCount(theArray) > 0 else {
           return nil
       }
       
       let dictionary = (theArray as NSArray).object(at: 0)
       guard let identity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) else {
           return nil
       }
       let certArray = [identity] as CFArray
       
       return certArray
   }
    
    func extractP12Data(certName: String) -> NSData? {
        let resourcePath = Bundle.main.path(forResource: certName, ofType: "p12")
        
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            logger.error("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        
        return p12Data
    }
    
    func readP12File(p12Data: NSData, certPassword: String) -> CFArray? {
        let key = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key: certPassword]
        
        var items : CFArray?
        let securityError = SecPKCS12Import(p12Data, options, &items)
        
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                logger.error("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                logger.error("Failed to open the certificate file")
            }
            return nil
        }
        
        return items
    }
}

struct PresenceMessage {
    let body: String
    let detectedAt: NSDate
}

extension PresenceMessage {
    init?(json: [String: Any]) {
        let logger = Logger()

        guard let body = json["message"] as? String
        else {
            logger.error("Missing message in payload")
            return nil
        }
        
        guard let detectedAtString = json["detectedAt"] as? String
        else {
            logger.error("Missing detectedAt in payload")
            return nil
        }
        
        guard let detectedAtUnix = Double(detectedAtString)
        else {
            logger.error("Invalid detectedAt: not a double")
            return nil
        }
        
        let detectedAt = NSDate(timeIntervalSince1970: detectedAtUnix)
        self.body = body
        self.detectedAt = detectedAt
    }
}
