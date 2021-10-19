import MixboxFoundation
import XCTest
import MixboxInAppServices
import MixboxUiKit

final class GenericSerializationTests: BaseSerializationTestCase {
    private let dataSetForCheckingSr5346: [CGFloat] = [
        // Do not use CGFloat.greatestFiniteMagnitude, see test___dataSetForCheckingSr5346___is_set_up_properly
        1.7976931348623157e+308,
        1.7976931348623155e+308,
        1.7976931348623153e+308,
        1.797693134862315e+308,
        1.7976931348623147e+308,
        1.7976931348623145e+308,
        1.7976931348623143e+308,
        1.7976931348623141e+308,
        1.7976931348623140e+308,
        1.797693134862315e+307,
        1.797693134862315e+306,
        1.797693134862315e+305,
        1.797693134862315e+304,
        1.797693134862315e+303,
        1.797693134862315e+302,
        1.797693134862315e+301,
        1.797693134862315e+300,
        1.797693134862315e+200,
        1.797693134862315e+100,
        0,
        -1.797693134862315e+100,
        -1.7976931348623157e+308
    ]
    
    // NSJSONSerialization fails to encode Double.greatestFiniteMagnitude properly.
    //
    // https://bugs.swift.org/browse/SR-5346
    // The bug is still present on iOS 10.3.
    //
    // (lldb) po JSONDecoder().decode([Double].self, from: JSONEncoder().encode([1.7976931348623157e+308]))
    // ▿ DecodingError
    //   ▿ dataCorrupted : Context
    //     - codingPath : 0 elements
    //     - debugDescription : "The given data was not valid JSON."
    //     ▿ underlyingError : Optional<Error>
    //       - some : Error Domain=NSCocoaErrorDomain Code=3840 "Number wound up as NaN around character 1." UserInfo={NSDebugDescription=Number wound up as NaN around character 1.}
    // (lldb) po String(data: JSONEncoder().encode([1.7976931348623157e+308]), encoding: .utf8)
    // ▿ Optional<String>
    //   - some : "[1.797693134862316e+308]"
    //
    // Test is disabled, because the bug is not fixed in GenericSerialization.
    // Workaround was added to code of providing ViewHierarchy.
    //
    // The ideal fix is to use custom Encoder, custom Encoder will have these advantages:
    // - It will not contain bugs
    // - It can be simple (e.g. binary) and work much faster.
    // Steps to implement it:
    // - Refactor GenericSerialization to use data
    // - See JSONEncoder and https://github.com/mikeash/BinaryCoder/blob/master/BinaryEncoder.swift
    //   to make custom BinaryEncoder (note that we don't need to use custom protocols like in mikeash's code).
    //   The interface of Codable is really enough. It is relatively simple.
    // - Write a lot of tests.
    func disabled_test___deserialize___can_deserialize_values_wounded_up_as_NaN() {
        XCTAssertEqual(Double.greatestFiniteMagnitude, 1.7976931348623157e+308)
        
        dataSetForCheckingSr5346.forEach {
            checkSerialization($0)
        }
    }
    
    func test___deserialize___can_deserialize_values_wounded_up_as_NaN___using_workaround() {
        let patcher = FloatValuesForSr5346PatcherImpl(
            iosVersionProvider: iosVersionProvider
        )
        
        dataSetForCheckingSr5346.forEach {
            checkSerializationConsideringSr5346(
                float: patcher.patched(float: $0)
            )
        }
    }
    
    func test___dataSetForCheckingSr5346___is_set_up_properly() {
        // Note: if numbers mismatch, add numbers that reflect the boundary of Double.greatestFiniteMagnitude
        XCTAssertEqual(CGFloat.greatestFiniteMagnitude, dataSetForCheckingSr5346.first)
    }
    
    private func checkSerializationConsideringSr5346(float: CGFloat) {
        do {
            let serialized = try serialize(object: float)
            let deserialized: CGFloat = try deserialize(string: serialized, object: float)
            
            XCTAssertEqual(
                try convertFloatMimicingEncodingBugInNSJsonSerialization(float: float),
                deserialized,
                "CGFloat doesn't match itself after serialization+deserialization"
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func convertFloatMimicingEncodingBugInNSJsonSerialization(float: CGFloat) throws -> CGFloat {
        if iosVersionProvider.iosVersion().majorVersion <= 10 {
            let stringFromFloat = NSNumber(value: Double(float)).stringValue
            
            let numberFormatter: NumberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale(identifier: "en_US")
            
            guard let number = numberFormatter.number(from: stringFromFloat) else {
                throw ErrorString("Failed to convert \(stringFromFloat) to number")
            }
            
            return CGFloat(truncating: number)
        } else {
            return float
        }
    }
}
