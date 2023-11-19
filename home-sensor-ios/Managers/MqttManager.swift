import Foundation
import CocoaMQTT
import Security

class MQTTManager {
    var mqttClient: CocoaMQTT5 = CocoaMQTT5(
        clientID: Environment.mqttClientId,
        host: Environment.mqttServer,
        port: Environment.mqttPort!
    )
    var userNotificationCenter: UNUserNotificationCenterProtocol = UNUserNotificationCenter.current()

    init() {
        self.authenticate();
        mqttClient.didReceiveMessage = self.didReceiveMessage
    }

    func authenticate() {
        mqttClient.enableSSL = true
        let clientCertArray = getClientCertFromP12File(
            certName: Environment.mqttCertificateFileName, 
            certPassword: Environment.mqttCertificatePassword
        )
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        mqttClient.sslSettings = sslSettings
    }
    
    func getClientCertFromP12File(certName: String, certPassword: String) -> CFArray? {
       guard let theArray = readP12File(certName: certName, certPassword: certPassword), 
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
    
    func readP12File(certName: String, certPassword: String) -> CFArray? {
        guard let p12Data = extractP12Data(certName: certName) else {
            return nil
        }

        let key = kSecImportExportPassphrase as String
        let options : NSDictionary = [key: certPassword]
        
        var items : CFArray?
        let securityError = SecPKCS12Import(p12Data, options, &items)
        
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                print("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                print("Failed to open the certificate file: \(certName).p12")
            }
            return nil
        }
        
        return items
    }
    
    func extractP12Data(certName: String) -> NSData? {
        let resourcePath = Bundle.main.path(forResource: certName, ofType: "p12")
        
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            print("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        
        return p12Data
    }

    func connect() {
        if !mqttClient.connect() {
            print("Failed to connect MQTT client.")
            return
        }
    }

    func subscribe() {
        mqttClient.subscribe(Environment.mqttTopic)
    }
    
    func didReceiveMessage(_ mqtt: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, _ decode: MqttDecodePublish?) {
        self.triggerLocalNotification(with: message.string) { error in
            if let error = error {
                print("Error scheduling local notification: \(error)")
            } else {
                print("Successfully triggered local notification")
            }
        }
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
}
