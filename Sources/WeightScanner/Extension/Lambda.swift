//
//  File.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/31.
//

import AWSLambdaRuntimeCore

enum EnvKey: String {
    case healthPlanetClientId = "HEALTH_PLANET_CLIENT_ID"
    case healthPlanetClientSecret = "HEALTH_PLANET_CLIENT_SECRET"
    case healthPlanetRefreshToken = "HEALTH_PLANET_REFRESH_TOKEN"
}

extension Lambda {
    static func env(_ key: EnvKey) -> String? {
        env(key.rawValue)
    }
}
