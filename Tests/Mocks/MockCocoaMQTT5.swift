import Foundation
import CocoaMQTT

class MockCocoaMQTT5: CocoaMQTT5Protocol {
    var delegate: CocoaMQTT5Delegate?
    var keepAlive: UInt16
    var logLevel: CocoaMQTTLoggerLevel
    var willMessage: CocoaMQTT5Message?
    
    var connected: Bool = false
    var subscribed: Bool = false
    
    var didReceiveMessage: (CocoaMQTT5, CocoaMQTT5Message, UInt16, MqttDecodePublish?) -> Void
    var enableSSL: Bool
    var sslSettings: [String: NSObject]?
    
    init() {
        keepAlive = 90
        logLevel = .debug
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
