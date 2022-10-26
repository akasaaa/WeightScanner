//
//  main.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import AWSLambdaRuntime

private struct Request: Codable {}

private struct Response: Codable {
  let message: String
}

enum WeightScannerError: Swift.Error {
    case dummy
}

Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
    let url = URL(string: "https://www.google.com")!
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse else {
            callback(.failure(WeightScannerError.dummy))
            return
        }
        callback(.success(Response(message: "statusCode: \(httpResponse.statusCode))")))
    }
    task.resume()
}
