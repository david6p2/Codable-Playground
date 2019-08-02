//: [Previous](@previous)

import Foundation
import XCTest
import PlaygroundSupport

//: # Problem 6
/*:
 Now we are going to Decode the real Foursquare Venue from FoursquareVenues.json file.
 As a user I want to see a list of all the available places, each list item must have at least
 one image, 2 relevant details of each venue and distance to it.
 
 Pieces needed to construct category icons at various sizes. Combine prefix with
 a size (32, 44, 64, 88 and 100 are available) and suffix, e.g.
 https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_64.png. To get an
 image with a gray background, use bg_ before the size,
 e.g.https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_bg_64.png.
 */


//: ## Foursquare Venue Implementation

struct Venue: Equatable {
    var name: String
    var category: String
    var location: Location
    var icon: VenueImage
}

struct Location: Decodable, Equatable {
    var lat: Double
    var lng: Double
}

struct VenueImage: Decodable, Equatable {
    var prefix: String
    var suffix: String
    var size: Int
    
    func getIconURL() -> URL {
        return URL(string: prefix + "\(size)" + suffix)!
    }
}

extension Venue: Decodable {
    
    enum CompleteResponseCodingKeys: String, CodingKey {
        case response
    }
    
    enum ResponseCodingKeys: String, CodingKey {
        case groups
    }
    
    enum GroupCodingKeys: String, CodingKey {
        case items
    }
    
    enum ItemCodingKeys: String, CodingKey {
        case venue
    }
    
    enum VenueCodingKeys: String, CodingKey {
        case name
        case location
        case categories
    }
    
    enum LocationCodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    enum CategoryCodingKeys: String, CodingKey {
        case name
        case icon
    }
    
    enum IconCodingKeys: String, CodingKey {
        case prefix
        case suffix
    }
    
    // implement init(from decoder: Decoder) trowing
    init(from decoder: Decoder) throws {
        let completeResponseContainer = try decoder.container(keyedBy: CompleteResponseCodingKeys.self)
        let responseContainer = try completeResponseContainer.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        var groupsContainer = try responseContainer.nestedUnkeyedContainer(forKey: .groups)
        let groupContainer = try groupsContainer.nestedContainer(keyedBy: GroupCodingKeys.self)
        var itemsContainer = try groupContainer.nestedUnkeyedContainer(forKey: .items)
        let itemContainer = try itemsContainer.nestedContainer(keyedBy: ItemCodingKeys.self)
        let venueContainer = try itemContainer.nestedContainer(keyedBy: VenueCodingKeys.self, forKey: .venue)
        
        let name = try venueContainer.decode(String.self, forKey: .name)
        
        let locationContainer = try venueContainer.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        
        let lat = try locationContainer.decode(Double.self, forKey: .lat)
        let lng = try locationContainer.decode(Double.self, forKey: .lng)
        let location = Location(lat: lat, lng: lng)
        
        var categoriesContainer = try venueContainer.nestedUnkeyedContainer(forKey: .categories)
        let categoryContainer = try categoriesContainer.nestedContainer(keyedBy: CategoryCodingKeys.self)
        
        let category = try categoryContainer.decode(String.self, forKey: .name)
        
        let iconContainer = try categoryContainer.nestedContainer(keyedBy: IconCodingKeys.self, forKey: .icon)
        
        let prefix = try iconContainer.decode(String.self, forKey: .prefix)
        let suffix = try iconContainer.decode(String.self, forKey: .suffix)
        
        let icon = VenueImage(prefix: prefix, suffix: suffix, size: 100)
        
        self.init(name: name, category: category, location: location, icon: icon)
    }
}

//: ## Run here the tests

class Problem6 : XCTestCase {
    var jsonString: String?
    
    let centralPark = Venue(name: "Central Park",
                            category: "Park",
                            location: Location(lat: 40.78408342593807, lng: -73.96485328674316),
                            icon: VenueImage(prefix: "https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_",
                                             suffix: ".png",
                                             size: 100)
    )
    
    func getJsonStringFromFile() -> String {
        let path = playgroundSharedDataDirectory.appendingPathComponent("FoursquareVenues.json")
        var jsonData: Data?
        do {
            jsonData = try Data(contentsOf: path)
        } catch {
            print("Error reading contents of: \(error)")
        }
        print("Path: \(path)")
        return String(decoding: jsonData!, as: UTF8.self)
    }
    
    func testCodable() throws {
        jsonString = getJsonStringFromFile()
        try archiveTest(json: jsonString ?? "No JSON String", expected: centralPark)
        print("Icon URL: \(centralPark.icon.getIconURL())")
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

TestRunner().runTests(testClass:Problem6.self)

//: [Next](@next)
