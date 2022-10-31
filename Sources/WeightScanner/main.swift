//
//  main.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/18.
//

import AWSLambdaRuntime

private struct LambdaRequest: Codable {}
private struct LambdaResponse: Codable {
    let message: String
    init(message: String = "") {
        self.message = message
    }
}

Lambda.run { (context, request: LambdaRequest, callback: @escaping (Result<LambdaResponse, Swift.Error>) -> Void) in
    guard let clientId = Lambda.env(.healthPlanetClientId),
          let clientSecret = Lambda.env(.healthPlanetClientSecret),
          let refreshToken = Lambda.env(.healthPlanetRefreshToken) else {
        callback(.failure(Error.withComment("Please check EnvironmentValues.")))
        return
    }
    
    let request = WealthPlanetTokenRequest(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
    APIClient.exec(request: request) { result in
        switch result {
        case .success(let response):
            callback(.success(LambdaResponse(message: "accessToken is \(response.result.accessToken)")))
        case .failure(let error):
            callback(.failure(error))
        }
    }
}
