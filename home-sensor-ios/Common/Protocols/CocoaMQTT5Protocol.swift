import Foundation
import CocoaMQTT

protocol CocoaMQTT5Protocol: AnyObject {
    var didReceiveMessage: (CocoaMQTT5, CocoaMQTT5Message, UInt16, MqttDecodePublish?) -> Void {get set}
    var enableSSL: Bool {get set}
    var sslSettings: [String: NSObject]? {get set}
    
    func connect() -> Bool
    func subscribe(_ topic: String, qos: CocoaMQTTQoS)
}

extension CocoaMQTT5: CocoaMQTT5Protocol {}
