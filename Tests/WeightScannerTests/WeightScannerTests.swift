import XCTest
@testable import WeightScanner
@testable import AWSLambdaTesting

final class WeightScannerTests: XCTestCase {
    
    func testExample() {
        try Lambda.withLocalServer {
            Lambda.run { (_, _, callback) in
                callback(.success("Hello, Lambda. by Swift"))
            }
        }
    }
}
