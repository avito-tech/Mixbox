import XCTest
import MixboxFoundation

class BaseSerializationTestCase: TestCase {
    func checkSerialization<T>(_ object: T)
        where
        T: Codable,
        T: Equatable
    {
        do {
            let serialized = try serialize(object: object)
            let deserialized: T = try deserialize(string: serialized, object: object)
            
            XCTAssertEqual(
                object,
                deserialized,
                "Object doesn't match itself after serialization+deserialization"
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func serialize<T: Codable>(object: T) throws -> String {
        do {
            return try GenericSerialization.serialize(value: object)
        } catch {
            throw ErrorString("Failed to serialize \(object): \(error)")
        }
    }
    
    func deserialize<T: Codable>(string: String, object: T) throws -> T {
        do {
            return try GenericSerialization.deserialize(string: string)
        } catch {
            throw ErrorString("Failed to deserialize \(object) from \(string): \(error)")
        }
    }
}
