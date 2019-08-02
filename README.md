# Codable-Playground

This playground was created to test the following cases of the Codable Protocol:
- ## Problem 1
Implement Codable and test it with some encoders and decoders.


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
    
 - ## Problem 2
Implement some testing for the `Venue`.

- ## Problem 3
Custom `Codable` implementation of `Venue`.

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
    
- ## Problem 4
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
    
- ## Problem 5

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
    
- ## Problem 6

 Now we are going to Decode the real Foursquare Venue from FoursquareVenues.json file.
 As a user I want to see a list of all the available places, each list item must have at least
 one image, 2 relevant details of each venue and distance to it.
 
 Pieces needed to construct category icons at various sizes. Combine prefix with
 a size (32, 44, 64, 88 and 100 are available) and suffix, e.g.
 https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_64.png. To get an
 image with a gray background, use bg_ before the size,
 e.g.https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_bg_64.png.
 
 - ## Problem 7 [https://benscheirman.com/2018/02/swift-4-1-keydecodingstrategy/]
 
 We are going to try the SnakeCase case that was symplyfied in Swift 4.1 by the introduction of the `keyDecodingStrategy for SnakeCase
 
 - ## Problem 8
 
 Here we study a simple case of Date parsing by using a `dateEncodingStrategy` with a custom Date Formatter
 
  ### References
  - [https://benscheirman.com/2017/06/swift-json/]
  - [https://www.fivestars.blog/code/swift-decodable.html]
  - [https://benscheirman.com/2018/02/swift-4-1-keydecodingstrategy/]
  - [https://www.raywenderlich.com/5157-swift-4-serialization]
