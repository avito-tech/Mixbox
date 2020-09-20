#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation
import CommonCrypto

public final class TestabilityElementFromAnyConverter {
    private init() {
    }
    
    // TODO (non-view elements): Test with: NSObject, non-NSObject, UIView, UIAccessibilityContainer.
    public static func testabilityElement(anyElement: Any) -> TestabilityElement {
        if let testabilityElement = anyElement as? TestabilityElement {
            return testabilityElement
        } else {
            // TODO (non-view elements): Make it not cause crash (e.g. forward to tests).
            assertionFailure("Unknown accessibility element type: \(type(of: anyElement)), description of object: \(anyElement)")
            
            return testabilityElementForUnknownClass(anyElement: anyElement)
        }
    }
    
    // MARK: - Private
    
    private static func testabilityElementForUnknownClass(anyElement: Any) -> TestabilityElement {
        return DtoTestabilityElement(
            accessibilityIdentifier: nil,
            accessibilityLabel: nil,
            accessibilityPlaceholderValue: nil,
            accessibilityValue: nil,
            parent: nil,
            children: [],
            customClass: String(describing: type(of: anyElement)),
            elementType: .other,
            frame: .null,
            frameRelativeToScreen: .null,
            hasKeyboardFocus: false,
            isDefinitelyHidden: false,
            isEnabled: false,
            text: nil,
            uniqueIdentifier: uniqueIdentifierForObjectWithoutUuidBasesUniqueIdentifier(anyElement: anyElement)
        )
    }

    // NOTE: This may cause collisions
    private static func uniqueIdentifierForObjectWithoutUuidBasesUniqueIdentifier(anyElement: Any) -> String {
        let object = anyElement as AnyObject
        
        let data = Data(String(describing: object).utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let descriptionHash = digest.map({ String(format: "%02hhx", $0) }).joined()
        let objectId = ObjectIdentifier(object)
        
        return "objectId:\(objectId),descriptionHash:\(descriptionHash)"
    }
}

#endif
