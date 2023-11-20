import Foundation

struct Environment {
    static var appDomain: String {
        guard let appDomain = ProcessInfo.processInfo.environment["APP_DOMAIN"] else {
            fatalError("Missing APP_DOMAIN environment variable")
        }
        return appDomain
    }
    static let mqttCertificateFileName: String = ProcessInfo.processInfo.environment["MQTT_CERTIFICATE_FILE_NAME"] ?? ""
    static let mqttCertificatePassword: String = ProcessInfo.processInfo.environment["MQTT_CERTIFICATE_PASSWORD"] ?? ""
    static let mqttClientId: String = ProcessInfo.processInfo.environment["MQTT_CLIENT_ID"] ?? ""
    static let mqttPort: UInt16? = UInt16(ProcessInfo.processInfo.environment["MQTT_PORT"] ?? "8883")
    static let mqttServer: String = ProcessInfo.processInfo.environment["MQTT_SERVER"] ?? ""
    static let mqttTopic: String = ProcessInfo.processInfo.environment["MQTT_TOPIC"] ?? ""
}
