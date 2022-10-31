//
//  StatusInnerScanAPI.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/31.
//

import Foundation

struct WealthPlanetStatusInnerScanRequest: APIRequest {
    typealias Response = WealthPlanetStatusInnerScanResponse
    let url = URL(string: "https://www.healthplanet.jp/status/innerscan.json")!
    let httpMethod = HTTPMethod.post
    var parameters: [String : Any]
    init(accessToken: String, from: String = "") {
        parameters = ["access_token": accessToken,
                      "date": 1]
        if !from.isEmpty {
            // yyyyMMddHHmmss
            parameters["from"] = from
        }
    }
}

struct WealthPlanetStatusInnerScanResponse: APIResponse {
    struct Result: Codable {
        let birth_date: String
        let data: [Data]
        let height: String
        let sex: String
    }
    struct Data: Codable {
        let date: String
        let keydata: String
        let model: String
        let tag: String
    }
    let result: Result
}
