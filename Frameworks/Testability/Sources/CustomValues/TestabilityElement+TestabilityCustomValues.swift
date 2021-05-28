#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation

private var testability_customValues_associatedObjectKey = 0

extension TestabilityElement {
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

#else

extension NSObject {
    public var mb_testability_customValues: TestabilityCustomValues {
        return TestabilityCustomValues.dummy
    }
}

#endif
