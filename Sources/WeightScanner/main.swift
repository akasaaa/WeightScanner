//
//  main.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/18.
//

import AWSLambdaRuntime

private struct Request: Codable {
  let name: String
}

private struct Response: Codable {
  let message: String
}

//Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
Lambda.run { (_, _, callback) in
    callback(.success("Hello, AWS Server!"))
//    callback(.success(Response(message: "Hello! from AWS server.")))
}
