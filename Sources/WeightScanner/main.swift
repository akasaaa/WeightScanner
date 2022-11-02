//
//  main.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/18.
//

import Foundation
import AWSLambdaRuntime

private struct LambdaRequest: Codable {
    let from: String?
    let to: String?
}
private struct LambdaResponse: Codable {
    let date: Double?
    let weight: Decimal?
    let fatPercentage: Decimal?
}

private var callbackHandler: ((Result<LambdaResponse, Swift.Error>) -> Void)?

private let lambdaCodableClosure: Lambda.CodableClosure<LambdaRequest, LambdaResponse> = { context, request, callback in
    callbackHandler = callback
    getToken(from: request.from ?? "", to: request.to ?? "")
}
    
Lambda.run(lambdaCodableClosure)


// MARK: - HealthPlanet API

private func getToken(from: String = "", to: String = "") {
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
            getInnerScanData(accessToken: response.result.accessToken, from: from, to: to)
        case .failure(let error):
            callbackHandler?(.failure(error))
            callbackHandler = nil
        }
    }
}

private func getInnerScanData(accessToken: String, from: String = "", to: String = "") {
    let request = WealthPlanetStatusInnerScanRequest(accessToken: accessToken, from: from, to: to)
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
            let weight = sorted.filter { $0.tag == .weight }.last!.keydata
            let fatPercentage = sorted.filter { $0.tag == .fatPercentage }.last!.keydata
            callbackHandler?(.success(LambdaResponse(date: date.timeIntervalSince1970,
                                                     weight: weight,
                                                     fatPercentage: fatPercentage)))
            
        case .failure(let error):
            callbackHandler?(.failure(error))
            callbackHandler = nil
        }
    }
}
