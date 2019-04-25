import MixboxTestsFoundation
import MixboxUiTestsFoundation
import XCTest

// Tests are unstable, because actions are unstable. TODO: Make actions more stable and enable this test!
final class RunningActionsInRandomOrderTests: BaseActionTestCase {
    func disabled_test_0() {
        parameterizedTest(testId: 0)
    }
    
    func disabled_test_1() {
        parameterizedTest(testId: 1)
    }
    
    func disabled_test_2() {
        parameterizedTest(testId: 2)
    }
    
    func disabled_test_3() {
        parameterizedTest(testId: 3)
    }
    
    func disabled_test_4() {
        parameterizedTest(testId: 4)
    }
    
    func disabled_test_5() {
        parameterizedTest(testId: 5)
    }
    
    func disabled_test_6() {
        parameterizedTest(testId: 6)
    }
    
    func disabled_test_7() {
        parameterizedTest(testId: 7)
    }
    
    func disabled_test_8() {
        parameterizedTest(testId: 8)
    }
    
    private let numberOfTestsPerTestMethod: UInt = 10
    
    private struct VariationOf2Actions {
        let first: AnyActionSpecification
        let second: AnyActionSpecification
    }
    
    // Saves some time by bucketing tests and reducing overhead.
    // TODO: Dynamic test generation at runtime.
    // TODO: (Crazy) we don't need to check all variations by N*K formula.
    //       Example: check(AA) + check(AB) + check(BB) + check(BA) : 8 checks
    //                is equivalent to
    //                check(AAABBBBA)
    //                which is equivalent to
    //                check(ABA) : 3 checks
    func parameterizedTest(testId: UInt) {
        // T is numberOfTestsPerTestMethod
        // N is numberOfTestsPerTestMethod
        
        let maxTestId = UInt(allActionSpecifications.count * allActionSpecifications.count) / numberOfTestsPerTestMethod
        guard testId <= maxTestId else {
            UnavoidableFailure.fail("testId exceeds maxTestId=\(maxTestId)")
        }
        
        for i in 0..<numberOfTestsPerTestMethod {
            let variationId = testId * numberOfTestsPerTestMethod + i
            
            if variationId < allActionSpecifications.count * allActionSpecifications.count {
                parameterizedTest(
                    variationId: variationId
                )
            }
        }
    }
    
    func parameterizedTest(variationId: UInt) {
        let variation = variationOf2Actions(variationId: variationId)
        
        let actionSpecificationsForUi: [AnyActionSpecification]
        let actionSpecificationsForCheck = [variation.first, variation.second]
        
        // To avoid duplicates in UI. Making different actions with same element should be perfectly fine.
        if variation.first.elementId == variation.second.elementId {
            actionSpecificationsForUi = [variation.first]
        } else {
            actionSpecificationsForUi = actionSpecificationsForCheck
        }
        
        setViews(
            showInfo: true,
            actionSpecifications: actionSpecificationsForUi
        )
        
        for actionSpecification in actionSpecificationsForCheck {
            checkActionCausesExpectedResultIfIsPerformedOnce(
                actionSpecification: actionSpecification,
                resetViewsForCurrentActionSpecification: false
            )
        }
    }
    
    func variationOf2Actions(variationId: UInt) -> (first: AnyActionSpecification, second: AnyActionSpecification)  {
        let maxVariationId = allActionSpecifications.count * allActionSpecifications.count - 1
        
        guard variationId <= maxVariationId else {
            UnavoidableFailure.fail("variationId=\(variationId) exceeds maxVariationId=\(maxVariationId)")
        }
        
        let first = allActionSpecifications[Int(variationId) % allActionSpecifications.count]
        let second = allActionSpecifications[Int(variationId) / allActionSpecifications.count]
        
        return (first: first, second: second)
    }
}
