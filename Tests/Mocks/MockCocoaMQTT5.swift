import Foundation
import CocoaMQTT

class MockCocoaMQTT5: CocoaMQTT5Protocol {
    var connected: Bool = false
    var subscribed: Bool = false
    
    var didReceiveMessage: (CocoaMQTT5, CocoaMQTT5Message, UInt16, MqttDecodePublish?) -> Void
    var enableSSL: Bool
    var sslSettings: [String: NSObject]?
    
    init() {
        didReceiveMessage = { _, _, _, _ in }
        enableSSL = false
        sslSettings = [:]
    }
    
    func subscribe(_ topic: String, qos: CocoaMQTTQoS) {
        subscribed = true
    }
    
    func connect() -> Bool {
        connected = true
        return true
    }
}
