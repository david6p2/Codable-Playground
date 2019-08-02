//: [Previous](@previous)

import Foundation
import XCTest

//: # Problem 2
//: Implement some testing for the `Venue`.

//: ## Foursquare Venue Implementation

struct Year: Codable, Equatable {
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

struct Venue: Codable, Equatable {
    var name: String
    var photos: [Photo]
}

//: ## Test Utilities


enum TestError: Error {
    case notEqual
    case dataCorrupt
}



func roundTripTest<T: Codable & Equatable>(item: T) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(item)
    let decoder = JSONDecoder()
    let restored = try decoder.decode(T.self, from: data)

    if item != restored {
        NSLog("Expected")
        dump(item)
        NSLog("Actual")
        dump(restored)
        throw TestError.notEqual
    }
}



func archiveTest<T: Codable & Equatable>(json: String, expected: T) throws {
    guard let data = json.data(using: .utf8) else {
        throw TestError.dataCorrupt
    }
    let decoder = JSONDecoder()
    let restored = try decoder.decode(T.self, from: data)
    if expected != restored {
        NSLog("Expected")
        dump(expected)
        NSLog("Actual")
        dump(restored)
        throw TestError.notEqual
    }
}


//: ## Run here the tests

class MyTests : XCTestCase {
    
    let centralPark = Venue(name: "Central Park", photos:
        [Photo(url: URL(string:"https://fastly.4sqi.net/img/general/width960/655018_Zp3vA90Sy4IIDApvfAo5KnDItoV0uEDZeST7bWT-qzk.jpg"),
               camera: .nikkon,
               time: Year(2019))])
    
    let centralParkJSON = """
{"name":"Central Park","photos":[{"url":"https://fastly.4sqi.net/img/general/width960/655018_Zp3vA90Sy4IIDApvfAo5KnDItoV0uEDZeST7bWT-qzk.jpg","camera":"nikkon","time":{"value":2019}}]}
"""
    
    func testCodable() throws {
        XCTFail()
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
