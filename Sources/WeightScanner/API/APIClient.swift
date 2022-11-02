//
//  APIClient.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/31.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIRequest {
    associatedtype Response: APIResponse
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var parameters: [String: Any] { get }
}

private extension APIRequest {
    func toURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let body = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        request.httpBody = body
        return request
    }
}

protocol APIResponse {
    associatedtype Result: Codable
    static var decoder: JSONDecoder { get }
    var result: Result { get }
    init(result: Result)
}
extension APIResponse {
    static var decoder: JSONDecoder {
        JSONDecoder()
    }
}

struct APIClient {
    static func exec<Request: APIRequest>(request: Request, handler: @escaping (Result<Request.Response, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request.toURLRequest()) { data, response, error in
            guard error == nil else {
                handler(.failure(.foundationError(error!)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                handler(.failure(.withComment("Status Code is not 200.")))
                return
            }
            guard let data = data else {
                handler(.failure(.withComment("Data is not valid.")))
                return
            }
            do {
                let decoder = Request.Response.decoder
                let result = try decoder.decode(Request.Response.Result.self, from: data)
                let apiResponse = Request.Response(result: result)
                handler(.success(apiResponse))
            } catch {
                handler(.failure(.foundationError(error)))
            }
        }
        task.resume()
    }
}
