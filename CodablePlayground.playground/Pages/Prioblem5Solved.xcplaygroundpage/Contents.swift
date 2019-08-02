//: [Previous](@previous)

import Foundation
import XCTest

//: # Problem 5
/*:
 Just like photos in Problem 4, "photos" are wrapped by a "venue_data" container
 and "photos" may or may not be present. This time you will solve it using
 a custom Codable implementation and not use a `VenueData` model.
 
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

struct Venue: Equatable {
    var name: String
    var photos: [Photo]
}

public struct Photo: Codable, Equatable {
    var url: URL?
    var camera: Camera
    var time: Year
}

extension Venue: Codable {
    
    // create CodingKeys for Venue with cases name = venue_name and venueData = venue_data
    enum CodingKeys: String, CodingKey {
        case name = "venue_name"
        case venueData = "venue_data"
    }
    
    // create VenueDataCodingKeys for VenueData with case photos
    enum VenueDataCodingKeys: String, CodingKey {
        case photos
    }
    
    // implement init(from decoder: Decoder) trowing
    init(from decoder: Decoder) throws {
        // try container from decoder keyedBy CodingKeys self
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // try decode name that is a String
        name = try container.decode(String.self, forKey: .name)
        // try nestedContainer form container keyedBy VenueDataCodingKeys self for .venueData
        let venueDataContainer = try container.nestedContainer(keyedBy: VenueDataCodingKeys.self, forKey: .venueData)
        // try decode if present photos that is an Array of Photos or an empty Array
        photos = try venueDataContainer.decodeIfPresent([Photo].self, forKey: .photos) ?? []
        
    }
    
    // implement func encode(to encoder: Encoder) trowing
    func encode(to encoder: Encoder) throws {
        // create var container from enconder keyedBy CodingKeys self
        var container = encoder.container(keyedBy: CodingKeys.self)
        // try to encode name String from container
        try container.encode(name, forKey: .name)
        // create let optionalPhotos array. If empty then assign nil other wise assign photos
        let optionalPhotos: [Photo]? = photos.isEmpty ? nil : photos
        // create venueDataContainer as a nestedContainer from container keyedBy VenueDataCodingKeys self for .venueData
        var venueDataContainer = container.nestedContainer(keyedBy: VenueDataCodingKeys.self, forKey: .venueData)
        // try encode if present optionalPhotos for key photos from previous container
        try venueDataContainer.encodeIfPresent(optionalPhotos, forKey: .photos)
    }
}

//: ## Run here the tests

class Problem5 : XCTestCase {
    let centralPark = Venue(name: "Central Park", photos:
        [Photo(url: URL(string:"https://bit.ly/2Ya938u"),
               camera: .nikkon,
               time: Year(2019))])
    
    let centralParkJSON = """
{"venue_name":"Central Park","venue_data": {"photos":[{"url":"https://bit.ly/2Ya938u","camera":"nikkon","time":{"year":2019}}]}}
"""
    
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

TestRunner().runTests(testClass:Problem5.self)

//: [Next](@next)
