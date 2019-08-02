import Foundation

// test data

public enum TestError: Error {
    case notEqual
    case dataCorrupt
}

public func archiveTest<T: Decodable & Equatable>(json: String, expected: T) throws {
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
    //    print("*****JSON*****")
    //    print(String(decoding: data, as: UTF8.self))
    print("*****Expected*****")
    dump(expected)
    print("*****Actual*****")
    dump(restored)
    if expected != restored {
        throw TestError.notEqual
    }
}

