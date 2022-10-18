// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeightScanner",
    products: [
        .executable(name: "WeightScanner", targets: ["WeightScanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "WeightScanner", dependencies: [.product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),]),
    ]
)
