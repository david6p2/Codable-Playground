//: [Previous](@previous)

import Foundation
import XCTest

//: # Problem 3
//: Custom `Codable` implementation of `Venue`.

/*:
 This will handle a change of "name" to "venue_name" and "value" to "year".
 
 {
 "venue_name":"Central Park",
 "photos":[{
 "url":"https://bit.ly/2Ya938u",
 "camera":"nikkon",
 "time": {
 "year":2019
 }
 }]
 }
 */


//: ## Foursquare Venue Implementation

struct Year: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case value = "year"
    }
    
    var value: Double
    init(_ value: Double) {
        self.value = value
    }
}

enum Camera: String, Codable, Equatable {
    case nikkon, canon, sony, samsung
}

struct Photo: Codable, Equatable {
    var url: URL?
    var camera: Camera
    var time: Year
}

struct Venue: Equatable {
    var name: String
    var photos: [Photo]
}

extension Venue: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "venue_name"
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        photos = try container.decode([Photo].self, forKey: .photos)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(photos, forKey: .photos)
    }
}


//: ## Run here the tests

class MyTests : XCTestCase {
    
    let centralPark = Venue(name: "Central Park", photos:
        [Photo(url: URL(string:"https://bit.ly/2Ya938u"),
               camera: .nikkon,
               time: Year(2019))])
    
    func testCodable() throws {
        try roundTripTest(item: centralPark)
        try archiveTest(json: centralParkJSON, expected: centralPark)
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
