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
    init(accessToken: String, from: String = "", to: String = "") {
        parameters = ["access_token": accessToken,
                      "date": 1]
        if !from.isEmpty {
            // yyyyMMddHHmmss
            parameters["from"] = from
        }
        if !to.isEmpty {
            parameters["to"] = to
        }
    }
}

struct WealthPlanetStatusInnerScanResponse: APIResponse {
    enum Tag: String, Codable {
        case weight = "6021"
        case fatPercentage = "6022"
    }
    struct Result: Codable {
        let birthDate: String
        let data: [Data]
        let height: Decimal
        let sex: String
        enum CodingKeys: String, CodingKey {
            case birthDate = "birth_date"
            case data, height, sex
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.birthDate = try container.decode(String.self, forKey: .birthDate)
            self.data = try container.decode([Data].self, forKey: .data)
            self.height = Decimal(string: try container.decode(String.self, forKey: .height)) ?? .zero
            self.sex = try container.decode(String.self, forKey: .sex)
        }
    }
    struct Data: Codable {
        let date: Date
        let keydata: Decimal
        let model: String
        let tag: Tag
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.date = try container.decode(Date.self, forKey: .date)
            self.keydata = Decimal(string: try container.decode(String.self, forKey: .keydata)) ?? .zero
            self.model = try container.decode(String.self, forKey: .model)
            self.tag = try container.decode(Tag.self, forKey: .tag)
        }
    }
    let result: Result
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
