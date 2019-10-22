import XCTest
import MixboxFoundation

// TODO: Replace XCTestCase with TestCase for every test.
class TestCase: XCTestCase {
    func checkSerialization<T>(_ object: T)
        where
        T: Codable,
        T: Equatable
    {
        guard let serialized = GenericSerialization.serialize(value: object) else {
            XCTFail("Failed to serialize \(object)")
            return
        }
        
        guard let deserialized: T = GenericSerialization.deserialize(string: serialized) else {
            XCTFail("Failed to deserialize \(object) from \(serialized)")
            return
        }
        
        XCTAssertEqual(
            object,
            deserialized,
            "Object doesn't match itself after serialization+deserialization"
        )
    }
}
