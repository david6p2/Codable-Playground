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
    
    // create CompleteResponseCodingKeys
    enum CompleteResponseCodingKeys: String, CodingKey {
        case response
    }
    // create ResponseCodingKeys
    enum ResponseCodingKeys: String, CodingKey {
        case groups
    }
    // create GroupCodingKeys
    enum GroupCodingKeys: String, CodingKey {
        case items
    }
    // create ItemCodingKeys
    enum ItemCodingKeys: String, CodingKey {
        case venue
    }
    // create VenueCodingKeys
    enum VenueCodingKeys: String, CodingKey {
        case name
        case location
        case categories
    }
    
    // create LocationCodingKeys
    enum LocationCodingKeys: String, CodingKey {
        case lat
        case lng
    }
    // create CategoryCodingKeys
    enum CategoryCodingKeys: String, CodingKey {
        case name
        case icon
    }
    // create IconCodingKeys
    enum IconCodingKeys: String, CodingKey {
        case prefix
        case suffix
    }
    
    // implement init(from decoder: Decoder) trowing
    init(from decoder: Decoder) throws {
        // create completeResponseContainer from decoder with CompleteResponseCodingKeys
        let completeResponseContainer = try decoder.container(keyedBy: CompleteResponseCodingKeys.self)
        // create responseContainer with ResponseCodingKeys for response
        let responseContainer = try completeResponseContainer.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
    
        // create groupsContainer with nestedUnkeyedContainer for groups
        var groupsContainer = try responseContainer.nestedUnkeyedContainer(forKey: .groups)
    
        // create groupContainer with GroupCodingKeys
        let groupContainer = try groupsContainer.nestedContainer(keyedBy: GroupCodingKeys.self)
        // create itemsContainer with nestedUnkeyedContainer for items
        var itemsContainer = try groupContainer.nestedUnkeyedContainer(forKey: .items)
    
        // create itemContainer with ItemCodingKeys
        let itemContainer = try itemsContainer.nestedContainer(keyedBy: ItemCodingKeys.self)
        // create venueContainer with VenueCodingKeys for venue
        let venueContainer = try itemContainer.nestedContainer(keyedBy: VenueCodingKeys.self, forKey: .venue)
    
        
        // create the venue name by decoding venueContainer String for key name
        let name = try venueContainer.decode(String.self, forKey: .name)
        
        // create locationContainer with LocationCodingKeys for location
        let locationContainer = try venueContainer.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        
        // create the location lat by decoding locationContainer Double for key lat
        let lat = try locationContainer.decode(Double.self, forKey: .lat)
        // create the location lng by decoding locationContainer Double for key lng
        let lng = try locationContainer.decode(Double.self, forKey: .lng)
        // create the Location object
        let location = Location(lat: lat, lng: lng)
        
        // create categoriesContainer with nestedUnkeyedContainer for categories
        var categoriesContainer = try venueContainer.nestedUnkeyedContainer(forKey: .categories)
        // create categoryContainer with CategoryCodingKeys
        let categoryContainer = try categoriesContainer.nestedContainer(keyedBy: CategoryCodingKeys.self)
        
        // create the category name by decoding categoryContainer String for key name
        let category = try categoryContainer.decode(String.self, forKey: .name)
        
        // create iconContainer with IconCodingKeys for icon
        let iconContainer = try categoryContainer.nestedContainer(keyedBy: IconCodingKeys.self, forKey: .icon)
        
        // create the Icon prefix by decoding iconContainer String for key prefix
        let prefix = try iconContainer.decode(String.self, forKey: .prefix)
        // create the Icon suffix by decoding iconContainer String for key suffix
        let suffix = try iconContainer.decode(String.self, forKey: .suffix)
        
        //Create the VenueImage (icon) Object
        let icon = VenueImage(prefix: prefix, suffix: suffix, size: 100)
        
        // init self with the previous values
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
