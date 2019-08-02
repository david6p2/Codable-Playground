//: [Previous](@previous)

import Foundation
import XCTest

//: # Problem 1
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
// Conform to Codable protocol
struct Year: Codable {
    var value: Double
    init(_ value: Double) {
        self.value = value
    }
}
// Conform to Codable protocol
enum Camera: String, Codable {
    
    case nikkon, canon, sony, samsung
}
// Conform to Codable protocol
struct Photo: Codable {
    var url: URL?
    var camera: Camera
    var time: Year
}
// Conform to Codable protocol
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
        // create JSONEncoder()
        let encoder = JSONEncoder()
        // set encoder outputFormatting as prettyPrinted
        encoder.outputFormatting = .prettyPrinted
        
        
        // create data by encoding centralPark object with the previous created encoder
        let data = try encoder.encode(centralPark)
        // print encoded data as String using .utf8 encoding
        print(String(data: data, encoding: .utf8)!)
        
        // create JSONDecoder()
        let decoder = JSONDecoder()
        
        // restore the Venue from data by decoding using the previously created decoder
        let restored = try decoder.decode(Venue.self, from: data)
        // dump the restored object
        dump(restored)
    }
    
    func testEncodeDecodePlist() throws {
        // create PropertyListEncoder()
        let encoder = PropertyListEncoder()
        
        // set encoder outputFormat as xml
        encoder.outputFormat = .xml
        // create data by encoding centralPark object with the previous created encoder
        let data = try encoder.encode(centralPark)
        
        // print encoded data as String using .utf8 encoding
        print(String(data: data, encoding: .utf8)!)
        
        // create PropertyListDecoder()
        let decoder = PropertyListDecoder()
        // restore the Venue from data by decoding using the previously created decoder
        let restored = try decoder.decode(Venue.self, from: data)
         // dump the restored object
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
