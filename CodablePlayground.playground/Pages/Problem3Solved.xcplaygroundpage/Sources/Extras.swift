import Foundation

// test data
public let centralParkJSON = """
{"venue_name":"Central Park","photos":[{"url":"https://bit.ly/2Ya938u","camera":"nikkon","time":{"year":2019}}]}
"""



public enum TestError: Error {
    case notEqual
    case dataCorrupt
}

public func roundTripTest<T: Codable & Equatable>(item: T) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(item)
    let decoder = JSONDecoder()
    let restored = try decoder.decode(T.self, from: data)
    print("*****JSON*****")
    print(String(decoding: data, as: UTF8.self))
    print("*****Expected*****")
    dump(item)
    print("*****Actual*****")
    dump(restored)
    if item != restored {
        throw TestError.notEqual
    }
}

public func archiveTest<T: Codable & Equatable>(json: String, expected: T) throws {
    guard let data = json.data(using: .utf8) else {
        throw TestError.dataCorrupt
    }
    let decoder = JSONDecoder()
    let restored: T
    do {
        restored = try decoder.decode(T.self, from: data)
    }
    catch {
        dump(error)
        throw error
    }
    print("*****JSON*****")
    print(String(decoding: data, as: UTF8.self))
    print("*****Expected*****")
    dump(expected)
    print("*****Actual*****")
    dump(restored)
    if expected != restored {
        throw TestError.notEqual
    }
}
