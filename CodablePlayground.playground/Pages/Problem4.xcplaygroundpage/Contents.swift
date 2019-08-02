//: [Previous](@previous)

import Foundation
import XCTest

//: # Problem 4
/*:
 Another custom `Codable` implementation of `Venue`. This time "photos"
 is wrapped by a "venue_data" container and "photos" may or may not be
 present.  You will solve this by creating a new type `VenueData`.
 
    {
        "venue_name": "Central Park",
        "venue_data": {
            "photos": [{
                "url": "https://bit.ly/2Ya938u",
                "camera": "nikkon",
                "time": {
                    "year": 2019
                }
            }]
        }
    }
 */


//: ## Foursquare Venue Implementation
public struct Photo: Codable, Equatable {
    var url: URL?
    var camera: Camera
    var time: Year
}

struct Venue: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case name = "venue_name"
        // Add coding key venueData = "venue_data"
        
    }
    
    var name: String
    
    // create struct VenueData that is Codable and Equatable
    // and contains an optional array of Photos
    
    // Add a var venueData with the previoulsy created struct
}

//: ## Run here the tests

class MyTests : XCTestCase {
    let centralPark = Venue(name: "Central Park", venueData: Venue.VenueData(photos:
        [Photo(url: URL(string:"https://bit.ly/2Ya938u"),
               camera: .nikkon,
               time: Year(2019))]))
    
    let centralParkJSON = """
{"venue_name":"Central Park","venue_data": {"photos":[{"url":"https://bit.ly/2Ya938u","camera":"nikkon","time":{"year":2019}}]}}
"""
    
    func testCodable() throws {
        XCTFail()
//        try roundTripTest(item: centralPark)
//        try archiveTest(json: centralParkJSON, expected: centralPark)
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
