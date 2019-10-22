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
        
        // There is some kind of proxy that is not NSProxy that creates selectors for everything
        // on iOS 12 (12.1, 12.4, maybe others)
        if UiDeviceIosVersionProvider(uiDevice: UIDevice.current).iosVersion().majorVersion == 12,
            let `class` = NSClassFromString("_PFPlaceholderMulticaster"),
            let method = class_getInstanceMethod(`class`, selector)
        {
            expectedMethods.append(
                ObjcMethodWithUniqueImplementation(
                    class: `class`,
                    method: method
                )
            )
        }
        
        XCTAssertEqual(actualMethods.sorted(), expectedMethods.sorted())
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
