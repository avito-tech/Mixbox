#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

public final class OverridingChildrenTestabilityElementViewHierarchyElement: TestabilityElementViewHierarchyElement {
    private let testabilityElement: TestabilityElement
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let overrideChildren: (_ parent: TestabilityElement, _ children: [TestabilityElement]) -> [ViewHierarchyElement]
    
    public init(
        testabilityElement: TestabilityElement,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        overrideChildren: @escaping (_ parent: TestabilityElement, _ children: [TestabilityElement]) -> [ViewHierarchyElement]
    ) {
        self.testabilityElement = testabilityElement
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.overrideChildren = overrideChildren
        
        super.init(
            testabilityElement: testabilityElement,
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
        )
    }
    
    public convenience init(
        testabilityElement: TestabilityElement,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        overrideChild: @escaping (TestabilityElement) -> ViewHierarchyElement?
    ) {
        self.init(
            testabilityElement: testabilityElement,
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
            overrideChildren: { _, children in
                children.lazy.map { [overrideChild, floatValuesForSr5346Patcher] childTestabilityElement in
                    if let overridenChild = overrideChild(childTestabilityElement) {
                        return overridenChild
                    } else {
                        return OverridingChildrenTestabilityElementViewHierarchyElement(
                            testabilityElement: childTestabilityElement,
                            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
                            overrideChild: overrideChild
                        )
                    }
                }
            }
        )
    }
    
    override public var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            overrideChildren(
                testabilityElement,
                testabilityElement.mb_testability_children()
            )
        )
    }
}

#endif
