#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)

extension NSObject {
    public var mb_testability_customValues: TestabilityCustomValues {
        return TestabilityCustomValues.dummy
    }
}

#else

import Foundation
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif

private var testability_customValues_associatedObjectKey = 0

extension TestabilityElement {
    // Associated custom values.
    public var mb_testability_customValues: TestabilityCustomValues {
        if let value = objc_getAssociatedObject(self, &testability_customValues_associatedObjectKey) as? TestabilityCustomValues {
            return value
        } else {
            let newValue = TestabilityCustomValues()
            objc_setAssociatedObject(
                self,
                &testability_customValues_associatedObjectKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return newValue
        }
    }
}

#endif
