//
//  WealthPlanetTokenAPI.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/31.
//

import Foundation

struct WealthPlanetTokenRequest: APIRequest {
    typealias Response = WealthPlanetTokenResponse
    let url = URL(string: "https://www.healthplanet.jp/oauth/token")!
    let httpMethod = HTTPMethod.post
    let parameters: [String : Any]
    init(clientId: String, clientSecret: String, refreshToken: String) {
        parameters = ["client_id": clientId,
                      "client_secret": clientSecret,
                      "refresh_token": refreshToken,
                      "redirect_uri": "https://www.healthplanet.jp/success.html",
                      "grant_type": "refresh_token"]
    }
}

struct WealthPlanetTokenResponse: APIResponse {
    struct Result: Codable {
        let accessToken: String
        let expiresIn: Int
        let refreshToken: String
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case refreshToken = "refresh_token"
        }
    }
    let result: Result
}
