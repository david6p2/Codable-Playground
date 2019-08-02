//: [Previous](@previous)

import Foundation
import XCTest

//: Implement Codable and test it with some encoders and decoders.

/*:
 ## This is the JSON we are going to use:
    {
        "name": "Central Park",
        "photos": [{
            "url": "https://fastly.4sqi.net/img/general/width960/655018_Zp3vA90Sy4IIDApvfAo5KnDItoV0uEDZeST7bWT-qzk.jpg",
            "camera": "nikkon",
            "time": {
                "value": 2019
            }
        }]
    }
*/

//: ## Foursquare Venue Implementation

struct Year: Codable {
    var value: Double
    init(_ value: Double) {
        self.value = value
    }
}

enum Camera: String, Codable {
    case nikkon, canon, sony, samsung
}

struct Photo: Codable {
    var url: URL?
    var camera: Camera
    var time: Year
}

struct Venue: Codable {
    var name: String
    var photos: [Photo]
}

//: ## Run here the tests

class MyTests : XCTestCase {
    
    let centralPark = Venue(name: "Central Park", photos:
        [Photo(url: URL(string:"https://fastly.4sqi.net/img/general/width960/655018_Zp3vA90Sy4IIDApvfAo5KnDItoV0uEDZeST7bWT-qzk.jpg"),
               camera: .nikkon,
               time: Year(2019))])
    
    func testEncodeDecodeJSON() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(centralPark)
        print(String(data: data, encoding: .utf8)!)
        
        let decoder = JSONDecoder()
        let restored = try decoder.decode(Venue.self, from: data)
        dump(restored)
    }
    
    func testEncodeDecodePlist() throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let data = try encoder.encode(centralPark)
        print(String(data: data, encoding: .utf8)!)
        
        let decoder = PropertyListDecoder()
        let restored = try decoder.decode(Venue.self, from: data)
        dump(restored)
    }
}

class PlaygroundTestObserver : NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("Test failed on line \(lineNumber): \(testCase.name ), \(description)")
    }
}

let observer = PlaygroundTestObserver()
let center = XCTestObservationCenter.shared
center.addTestObserver(observer)

struct TestRunner {
    
    func runTests(testClass:AnyClass) {
        print("Running test suite \(testClass)")
        
        let tests = testClass as! XCTestCase.Type
        let testSuite = tests.defaultTestSuite
        testSuite.run()
        let run = testSuite.testRun as! XCTestSuiteRun
        
        print("Ran \(run.executionCount) tests in \(run.testDuration)s with \(run.totalFailureCount) failures")
    }
}

TestRunner().runTests(testClass:MyTests.self)

//: [Next](@next)
