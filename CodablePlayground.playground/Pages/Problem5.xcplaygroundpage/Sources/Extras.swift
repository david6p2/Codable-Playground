import Foundation

// test data

public struct Year: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case value = "year"
    }
    
    var value: Double
    public init(_ value: Double) {
        self.value = value
    }
}

public enum Camera: String, Codable, Equatable {
    case nikkon, canon, sony, samsung
}

public struct Photo: Codable, Equatable {
    var url: URL?
    var camera: Camera
    var time: Year
}


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
