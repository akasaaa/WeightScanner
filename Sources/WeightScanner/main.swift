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

private var callbackHandler: ((Result<LambdaResponse, Swift.Error>) -> Void)?

private let lambdaCodableClosure: Lambda.CodableClosure<LambdaRequest, LambdaResponse> = { context, request, callback in
    callbackHandler = callback
    getToken()
}
    
Lambda.run(lambdaCodableClosure)


// MARK: - HealthPlanet API

private func getToken() {
    guard let clientId = env(.healthPlanetClientId),
          let clientSecret = env(.healthPlanetClientSecret),
          let refreshToken = env(.healthPlanetRefreshToken) else {
        callbackHandler?(.failure(Error.withComment("Please check EnvironmentValues.")))
        callbackHandler = nil
        return
    }
    
    let request = WealthPlanetOAuthTokenRequest(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken)
    APIClient.exec(request: request) { result in
        switch result {
        case .success(let response):
            getInnerScanData(accessToken: response.result.accessToken)
        case .failure(let error):
            callbackHandler?(.failure(error))
            callbackHandler = nil
        }
    }
}

private func getInnerScanData(accessToken: String) {
    let request = WealthPlanetStatusInnerScanRequest(accessToken: accessToken)
    APIClient.exec(request: request) { result in
        switch result {
        case .success(let response):
            guard !response.result.data.isEmpty else {
                callbackHandler?(.failure(Error.withComment("Empty Data Response")))
                callbackHandler = nil
                return
            }
            let date = response.result.data.map(\.date).max()!
            let sorted = response.result.data.sorted { $0.date < $1.date }
            let weight = sorted.filter { $0.tag == "6021" }.last!.keydata
            let fat = sorted.filter { $0.tag == "6022" }.last!.keydata
            
            callbackHandler?(.success(LambdaResponse(message: "date: \(date), weight: \(weight), fat: \(fat)")))
            
        case .failure(let error):
            callbackHandler?(.failure(error))
            callbackHandler = nil
        }
    }
}
