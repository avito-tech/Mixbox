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
        
        XCTAssertEqual(actualMethods.sorted(), expectedMethods.sorted())
    }
    
    private func methodsOfProxies(selector: Selector) -> [ObjcMethodWithUniqueImplementation] {
        var methodsOfProxies = [ObjcMethodWithUniqueImplementation]()
        
        let proxyClassNames: [String]
        
        // There are some kinds of proxy that are not NSProxy that create selectors for everything
        switch UiDeviceIosVersionProvider(uiDevice: UIDevice.current).iosVersion().majorVersion {
        case 12:
            proxyClassNames = [
                "_PFPlaceholderMulticaster"
            ]
        case 13:
            proxyClassNames = [
                "_PFPlaceholderMulticaster",
                "UIKeyboardCandidateViewStyle",
                "UIKeyboardCandidateViewState"
            ]
        default:
            proxyClassNames = []
        }
        
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
