//
//  NotificationManagerTests.swift
//  home-sensor-iosTests
//
//  Created by Matheus Raposo on 09/10/23.
//

import Foundation
import XCTest
@testable import home_sensor_ios

class NotificationManagerTests: XCTestCase {
    
    var notificationManager: NotificationManager!
    
    override func setUp() {
        super.setUp()
        notificationManager = NotificationManager()
    }
    
    override func tearDown() {
        notificationManager = nil
        super.tearDown()
    }
    
    func testRequestAuthorization() {
        // Mock or control the environment to test requestAuthorization
    }
    
    func testGetNotificationSettings() {
        // Mock or control the environment to test getNotificationSettings
    }
    
    // ... other tests ...
}
