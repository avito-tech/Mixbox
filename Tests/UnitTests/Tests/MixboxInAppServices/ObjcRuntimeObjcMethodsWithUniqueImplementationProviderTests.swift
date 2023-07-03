import MixboxInAppServices
import XCTest
import MixboxUiKit

final class ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests: TestCase {
    func test() {
        let provider = ObjcRuntimeObjcMethodsWithUniqueImplementationProvider()
        let `class` = Class_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests.self
        let selector = #selector(Class_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests.functionWithSameNameAndDifferentTypes_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests)
        
        let actualMethods = provider.objcMethodsWithUniqueImplementation(
            baseClass: `class`,
            selector: selector,
            methodType: .instanceMethod
        )
        
        guard let method = class_getInstanceMethod(`class`, selector) else {
            XCTFail("class_getInstanceMethod failed. class: \(`class`), selector: \(selector)")
            return
        }
        
        var expectedMethods = [
            ObjcMethodWithUniqueImplementation(
                class: `class`,
                method: method
            )
        ]
        
        expectedMethods.append(contentsOf: methodsOfProxies(selector: selector))
        
        XCTAssertEqual(
            actualMethods.sorted(),
            expectedMethods.sorted(),
            """
            `objcMethodsWithUniqueImplementation` returned different classes that contains a specified selector. \
            You should either update `ObjcRuntimeObjcMethodsWithUniqueImplementationProvider` or ignore some classes. \
            Important note: you may see some internal classes in this test failure. Some of those classes are some proxies \
            that can respond to every selector and they even add selectors dynamically if they are requested. They \
            should be ignored in this test. See `methodsOfProxies`. If you are upgrading iOS version, add it to a switch. \
            Consider just having same proxy class names as in previous iOS version. But if the list differs, add another case.
            """
        )
    }
    
    private func methodsOfProxies(selector: Selector) -> [ObjcMethodWithUniqueImplementation] {
        var methodsOfProxies = [ObjcMethodWithUniqueImplementation]()
        
        // There are some kinds of proxy that are not NSProxy that create selectors for everything
        let proxyClassNames = valuesByIosVersion(type: [String].self)
            .value([])
            .since(MixboxIosVersions.Outdated.iOS12)
            .value([
                "_PFPlaceholderMulticaster"
            ])
            .since(MixboxIosVersions.Outdated.iOS13)
            .value([
                "_PFPlaceholderMulticaster",
                "UIKeyboardCandidateViewStyle",
                "UIKeyboardCandidateViewState"
            ])
            .getValue()
        
        for className in proxyClassNames {
            if let `class` = NSClassFromString(className),
                let method = class_getInstanceMethod(`class`, selector)
            {
                methodsOfProxies.append(
                    ObjcMethodWithUniqueImplementation(
                        class: `class`,
                        method: method
                    )
                )
            }
        }
        
        return methodsOfProxies
    }
}

private class Class_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests: NSObject {
    @objc func function_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(1) }
    @objc func otherFunction_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(2) }
    @objc class func classFunction_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(3) }
    
    @objc func functionWithSameNameAndDifferentTypes_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(4) }
}

private class OtherClass_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests: Class_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests {
    @objc override func function_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(5) }
    @objc override func otherFunction_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(6) }
    @objc override class func classFunction_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(7) }
    
    @objc class func functionWithSameNameAndDifferentTypes_for_ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests() { print(8) }
}
