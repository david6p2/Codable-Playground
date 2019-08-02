//: [Previous](@previous)

import Foundation

struct ReadMe: Codable {
    var title: String
    var content: String
}
struct PlaygroundPage: Codable {
    var code: String
}
struct Playground: Codable {
    var pages: [PlaygroundPage]
}
struct PlaygroundSample: Codable {
    var playgroundName: String
    var readMe: ReadMe
    var playground: Playground
}
let readme = ReadMe(title: "Codable", content: "Example of nested types using codable")
let page = PlaygroundPage(code: "encode(self) - decode(self)")
let playgroundSample = PlaygroundSample(playgroundName: "Codable",
                                        readMe: readme,
                                        playground: .init(pages: [page]))

let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
jsonEncoder.keyEncodingStrategy = .useDefaultKeys

let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .useDefaultKeys

//: Nested Types
let normalData = try playgroundSample.encode(using: jsonEncoder)
print("- Normal JSON:")
normalData.toString().print()

//: Snake_Case
jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
let snakeData = try playgroundSample.encode(using: jsonEncoder)
print("- Snake_Case JSON:")
snakeData.toString().print()

// Decoding
jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
let snakeSample = try PlaygroundSample.decode(from: snakeData, using: jsonDecoder)
snakeSample.readMe
dump(snakeSample)


//: [Next](@next)
