#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import CommonCrypto
import Foundation

public final class NonTestabilityElementFallbackTestabilityElement: BaseTestabilityElement {
    private let anyElement: Any
    
    public  init(anyElement: Any) {
        self.anyElement = anyElement
        
        super.init(
            uniqueIdentifier: Self.uniqueIdentifierForObjectWithoutUuidBasesUniqueIdentifier(anyElement: anyElement)
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
