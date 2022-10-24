//
//  main.swift
//  
//
//  Created by 赤迫亮太 on 2022/10/18.
//

import AWSLambdaRuntime

private struct Request: Codable {}

private struct Response: Codable {
  let message: String
}

Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
    let envValue = Lambda.env("TEST_ENV_KEY")
    callback(.success(Response(message: "Hello, AWS Server! Environment value is \(envValue ?? "not found").")))
}
