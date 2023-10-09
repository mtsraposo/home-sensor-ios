//
//  Environment.swift
//  home-sensor-ios
//
//  Created by Matheus Raposo on 09/10/23.
//

import Foundation

struct Environment {
    static var appDomain: String {
        guard let appDomain = ProcessInfo.processInfo.environment["APP_DOMAIN"] else {
            fatalError("Missing APP_DOMAIN environment variable")
        }
        return appDomain
    }
}
