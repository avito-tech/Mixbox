import MixboxInAppServices
import MixboxMocksRuntime
import MixboxUiKit
import XCTest
import MixboxFoundation

// This test requires Accessibility to be enabled (should be run in GrayBoxUiTests).
final class PredefinedObjcMethodsTests: TestCase {
    private let factory = MockAllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory()
    private let methodType: MethodType = .instanceMethod
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        factory
            .stub()
            .allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
                enhancedAccessibilityLabelMethodSwizzler: any(),
                objcMethodsWithUniqueImplementationProvider: any(),
                baseClass: any(),
                selector: any(),
                methodType: any()
            )
            .thenReturn(
                // Value doesn't matter
                AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
                    enhancedAccessibilityLabelMethodSwizzler: register(MockEnhancedAccessibilityLabelMethodSwizzler()),
                    objcMethodsWithUniqueImplementationProvider: register(MockObjcMethodsWithUniqueImplementationProvider()),
                    baseClass: NSObject.self,
                    selector: #selector(NSObject.init),
                    methodType: .instanceMethod
                )
            )
    }
    
    func test() {
        let accessibilityLabelSwizzlerFactory = AccessibilityLabelSwizzlerFactoryImpl(
            allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: factory,
            iosVersionProvider: iosVersionProvider
        )
        
        assertDoesntThrow {
            _ = try accessibilityLabelSwizzlerFactory.accessibilityLabelSwizzler()
            
            let iosVersion = iosVersionProvider.iosVersion().majorVersion
            switch iosVersion {
            case 10:
                checkForIos10()
            case 11...:
                checkForIosFrom11()
            default:
                XCTFail("Current iOS version is not supported in this test: \(iosVersion). Please test it carefully.")
            }
        }
    }
    
    private func checkForIos10() {
        let baseClass = NSObject.self
        let selector = #selector(NSObject.accessibilityLabel)
        
        factory.verify().allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: isInstance(of: EnhancedAccessibilityLabelMethodSwizzlerImpl.self),
            objcMethodsWithUniqueImplementationProvider: isInstance(of: ObjcRuntimeObjcMethodsWithUniqueImplementationProvider.self),
            baseClass: isSame(baseClass),
            selector: equals(selector),
            methodType: equals(methodType)
        ).isCalled()
        
        // Verify that only 1 swizzler is created:
        
        factory.verify().allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: any(),
            objcMethodsWithUniqueImplementationProvider: any(),
            baseClass: any(),
            selector: any(),
            methodType: any()
        ).isCalled(times: .exactly(1))
    }
    
    private func checkForIosFrom11() {
        let baseClass = NSObject.self
        let selector = Selector(("_accessibilityAXAttributedLabel"))
        
        factory.verify().allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: isInstance(of: EnhancedAccessibilityLabelMethodSwizzlerImpl.self),
            objcMethodsWithUniqueImplementationProvider: isInstance(of: PredefinedObjcMethodsWithUniqueImplementationProvider.self),
            baseClass: isSame(baseClass),
            selector: equals(selector),
            methodType: equals(methodType)
        ).isCalled()
        
        checkObjcMethodsMethodsWithUniqueImplementationArePredefined(
            baseClass: baseClass,
            selector: selector
        )
        
        // Verify that only 1 swizzler is created:
        
        factory.verify().allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: any(),
            objcMethodsWithUniqueImplementationProvider: any(),
            baseClass: any(),
            selector: any(),
            methodType: any()
        ).isCalled(times: .exactly(1))
    }
    
    private func checkObjcMethodsMethodsWithUniqueImplementationArePredefined(
        baseClass: NSObject.Type,
        selector: Selector)
    {
        // Given
        var fallbackWasUsed = false
        
        let fallbackObjcMethodsWithUniqueImplementationProvider = register(MockObjcMethodsWithUniqueImplementationProvider())
        fallbackObjcMethodsWithUniqueImplementationProvider
            .stub()
            .objcMethodsWithUniqueImplementation(baseClass: any(), selector: any(), methodType: any())
            .thenInvoke { _ in
                fallbackWasUsed = true
                return []
            }
        
        let stubbedProvider = PredefinedObjcMethodsWithUniqueImplementationProvider(
            fallbackObjcMethodsWithUniqueImplementationProvider: fallbackObjcMethodsWithUniqueImplementationProvider,
            predefinedObjcMethodsWithUniqueImplementationBatchesFactory: PredefinedObjcMethodsWithUniqueImplementationBatchesFactoryImpl(),
            iosVersionProvider: iosVersionProvider
        )
        let realProvider = ObjcRuntimeObjcMethodsWithUniqueImplementationProvider()
        
        let expectedMethods = realProvider
            .objcMethodsWithUniqueImplementation(
                baseClass: baseClass,
                selector: selector,
                methodType: methodType
            )
            .sorted()
        
        // When
        let actualMethods = stubbedProvider
            .objcMethodsWithUniqueImplementation(
                baseClass: baseClass,
                selector: selector,
                methodType: methodType
            )
            .sorted()
        
        // Then
        if actualMethods != expectedMethods || fallbackWasUsed {
            failTest(
                actualMethods: actualMethods,
                expectedMethods: expectedMethods,
                fallbackWasUsed: fallbackWasUsed
            )
        }
    }
    
    private func failTest(
        actualMethods: [ObjcMethodWithUniqueImplementation],
        expectedMethods: [ObjcMethodWithUniqueImplementation],
        fallbackWasUsed: Bool)
    {
        XCTFail(
            """
            Expected methods:
            \(reviewableDescription(expectedMethods))
            Actual methods:
            \(reviewableDescription(actualMethods))\(fallbackWasUsed ? fallbackWasUsedMessageInfix() : "")
            You may want to copy-paste this into `\(PredefinedObjcMethodsWithUniqueImplementationBatchesFactoryImpl.self)`:
            \(copypastableDescription(expectedMethods))`
            """
        )
    }
    
    private func fallbackWasUsedMessageInfix() -> String {
        return """
        
        Note: `fallbackObjcMethodsWithUniqueImplementationProvider` was used by \
        `\(PredefinedObjcMethodsWithUniqueImplementationProvider.self)`, which is not expected for \
        the current iOS version. For the current iOS version it is possible to pre-define all necessary Obj-C methods,
        because they all are a part of iOS and fallback dumps every method of every class and is very expensive \
        (about 1..3 seconds on MacBook Pro 2017).
        """
    }
    
    private func reviewableDescription(_ methods: [ObjcMethodWithUniqueImplementation]) -> String {
        let joined = methods
            .map { (method: ObjcMethodWithUniqueImplementation) -> String in
                method.debugDescription
            }
            .joined(separator: ",\n")
        
        return String(joined)
            .mb_wrapAndIndent(prefix: "[", postfix: "]", indentation: "    ", ifEmpty: "[]")
    }
    
    private func copypastableDescription(_ methods: [ObjcMethodWithUniqueImplementation]) -> String {
        let joined = methods
            .map { (method: ObjcMethodWithUniqueImplementation) -> String in
                """
                method(class: "\(method.class)")
                """
            }
            .joined(separator: ",\n")
        
        return String(joined)
            .mb_wrapAndIndent(prefix: "[", postfix: "]", indentation: "    ", ifEmpty: "[]")
    }
    
    private func method(
        className: String,
        selector: Selector)
        -> ObjcMethodWithUniqueImplementation?
    {
        guard let `class` = NSClassFromString(className) else {
            return nil
        }
        guard let method = class_getInstanceMethod(`class`, selector) else {
            return nil
        }
        
        return ObjcMethodWithUniqueImplementation(class: `class`, method: method)
    }
    
    private func methods(_ methods: ObjcMethodWithUniqueImplementation?...) -> Set<ObjcMethodWithUniqueImplementation> {
        return Set(methods.compactMap { $0 })
    }
}
