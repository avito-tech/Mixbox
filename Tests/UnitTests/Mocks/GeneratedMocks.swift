import Cuckoo
import MixboxUiTestsFoundation

public class MockStubRequestBuilder: StubRequestBuilder, Cuckoo.ProtocolMock {

    public typealias MocksType = StubRequestBuilder

    public typealias Stubbing = __StubbingProxy_StubRequestBuilder
    public typealias Verification = __VerificationProxy_StubRequestBuilder

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: StubRequestBuilder?

    public func enableDefaultImplementation(_ stub: StubRequestBuilder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func withRequestStub(urlPattern: String, httpMethod: HttpMethod?) -> StubResponseBuilder {

    return cuckoo_manager.call("withRequestStub(urlPattern: String, httpMethod: HttpMethod?) -> StubResponseBuilder",
            parameters: (urlPattern, httpMethod),
            escapingParameters: (urlPattern, httpMethod),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.withRequestStub(urlPattern: urlPattern, httpMethod: httpMethod))

    }

    public func removeAllStubs()  {

    return cuckoo_manager.call("removeAllStubs()",
            parameters: (),
            escapingParameters: (),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeAllStubs())

    }

	public struct __StubbingProxy_StubRequestBuilder: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func withRequestStub<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(urlPattern: M1, httpMethod: M2) -> Cuckoo.ProtocolStubFunction<(String, HttpMethod?), StubResponseBuilder> where M1.MatchedType == String, M2.OptionalMatchedType == HttpMethod {
	        let matchers: [Cuckoo.ParameterMatcher<(String, HttpMethod?)>] = [wrap(matchable: urlPattern) { $0.0 }, wrap(matchable: httpMethod) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStubRequestBuilder.self, method: "withRequestStub(urlPattern: String, httpMethod: HttpMethod?) -> StubResponseBuilder", parameterMatchers: matchers))
	    }
	    
	    func removeAllStubs() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockStubRequestBuilder.self, method: "removeAllStubs()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_StubRequestBuilder: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func withRequestStub<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(urlPattern: M1, httpMethod: M2) -> Cuckoo.__DoNotUse<(String, HttpMethod?), StubResponseBuilder> where M1.MatchedType == String, M2.OptionalMatchedType == HttpMethod {
	        let matchers: [Cuckoo.ParameterMatcher<(String, HttpMethod?)>] = [wrap(matchable: urlPattern) { $0.0 }, wrap(matchable: httpMethod) { $0.1 }]
	        return cuckoo_manager.verify("withRequestStub(urlPattern: String, httpMethod: HttpMethod?) -> StubResponseBuilder", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeAllStubs() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("removeAllStubs()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class StubRequestBuilderStub: StubRequestBuilder {

    public func withRequestStub(urlPattern: String, httpMethod: HttpMethod?) -> StubResponseBuilder  {
        return DefaultValueRegistry.defaultValue(for: (StubResponseBuilder).self)
    }

    public func removeAllStubs()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}

import Cuckoo
import MixboxUiTestsFoundation

import MixboxIpcCommon

public class MockStubResponseBuilder: StubResponseBuilder, Cuckoo.ProtocolMock {

    public typealias MocksType = StubResponseBuilder

    public typealias Stubbing = __StubbingProxy_StubResponseBuilder
    public typealias Verification = __VerificationProxy_StubResponseBuilder

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: StubResponseBuilder?

    public func enableDefaultImplementation(_ stub: StubResponseBuilder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func withResponse(value: StubResponseBuilderResponseValue, variation: URLResponseProtocolVariation, responseTime: TimeInterval)  {

    return cuckoo_manager.call("withResponse(value: StubResponseBuilderResponseValue, variation: URLResponseProtocolVariation, responseTime: TimeInterval)",
            parameters: (value, variation, responseTime),
            escapingParameters: (value, variation, responseTime),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.withResponse(value: value, variation: variation, responseTime: responseTime))

    }

	public struct __StubbingProxy_StubResponseBuilder: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func withResponse<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(value: M1, variation: M2, responseTime: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(StubResponseBuilderResponseValue, URLResponseProtocolVariation, TimeInterval)> where M1.MatchedType == StubResponseBuilderResponseValue, M2.MatchedType == URLResponseProtocolVariation, M3.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(StubResponseBuilderResponseValue, URLResponseProtocolVariation, TimeInterval)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: variation) { $0.1 }, wrap(matchable: responseTime) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStubResponseBuilder.self, method: "withResponse(value: StubResponseBuilderResponseValue, variation: URLResponseProtocolVariation, responseTime: TimeInterval)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_StubResponseBuilder: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func withResponse<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(value: M1, variation: M2, responseTime: M3) -> Cuckoo.__DoNotUse<(StubResponseBuilderResponseValue, URLResponseProtocolVariation, TimeInterval), Void> where M1.MatchedType == StubResponseBuilderResponseValue, M2.MatchedType == URLResponseProtocolVariation, M3.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(StubResponseBuilderResponseValue, URLResponseProtocolVariation, TimeInterval)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: variation) { $0.1 }, wrap(matchable: responseTime) { $0.2 }]
	        return cuckoo_manager.verify("withResponse(value: StubResponseBuilderResponseValue, variation: URLResponseProtocolVariation, responseTime: TimeInterval)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class StubResponseBuilderStub: StubResponseBuilder {

    public func withResponse(value: StubResponseBuilderResponseValue, variation: URLResponseProtocolVariation, responseTime: TimeInterval)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}

import Cuckoo
import MixboxUiTestsFoundation

public class MockScreenshotTaker: ScreenshotTaker, Cuckoo.ProtocolMock {

    public typealias MocksType = ScreenshotTaker

    public typealias Stubbing = __StubbingProxy_ScreenshotTaker
    public typealias Verification = __VerificationProxy_ScreenshotTaker

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: ScreenshotTaker?

    public func enableDefaultImplementation(_ stub: ScreenshotTaker) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func takeScreenshot() -> UIImage? {

    return cuckoo_manager.call("takeScreenshot() -> UIImage?",
            parameters: (),
            escapingParameters: (),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.takeScreenshot())

    }

	public struct __StubbingProxy_ScreenshotTaker: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func takeScreenshot() -> Cuckoo.ProtocolStubFunction<(), UIImage?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockScreenshotTaker.self, method: "takeScreenshot() -> UIImage?", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_ScreenshotTaker: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func takeScreenshot() -> Cuckoo.__DoNotUse<(), UIImage?> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("takeScreenshot() -> UIImage?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class ScreenshotTakerStub: ScreenshotTaker {

    public func takeScreenshot() -> UIImage?  {
        return DefaultValueRegistry.defaultValue(for: (UIImage?).self)
    }

}

import Cuckoo
import MixboxUiTestsFoundation

public class MockSnapshotsComparatorFactory: SnapshotsComparatorFactory, Cuckoo.ProtocolMock {

    public typealias MocksType = SnapshotsComparatorFactory

    public typealias Stubbing = __StubbingProxy_SnapshotsComparatorFactory
    public typealias Verification = __VerificationProxy_SnapshotsComparatorFactory

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: SnapshotsComparatorFactory?

    public func enableDefaultImplementation(_ stub: SnapshotsComparatorFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator {

    return cuckoo_manager.call("snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator",
            parameters: (type),
            escapingParameters: (type),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.snapshotsComparator(type: type))

    }

	public struct __StubbingProxy_SnapshotsComparatorFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func snapshotsComparator<M1: Cuckoo.Matchable>(type: M1) -> Cuckoo.ProtocolStubFunction<(SnapshotsComparatorType), SnapshotsComparator> where M1.MatchedType == SnapshotsComparatorType {
	        let matchers: [Cuckoo.ParameterMatcher<(SnapshotsComparatorType)>] = [wrap(matchable: type) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSnapshotsComparatorFactory.self, method: "snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_SnapshotsComparatorFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func snapshotsComparator<M1: Cuckoo.Matchable>(type: M1) -> Cuckoo.__DoNotUse<(SnapshotsComparatorType), SnapshotsComparator> where M1.MatchedType == SnapshotsComparatorType {
	        let matchers: [Cuckoo.ParameterMatcher<(SnapshotsComparatorType)>] = [wrap(matchable: type) { $0 }]
	        return cuckoo_manager.verify("snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class SnapshotsComparatorFactoryStub: SnapshotsComparatorFactory {

    public func snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator  {
        return DefaultValueRegistry.defaultValue(for: (SnapshotsComparator).self)
    }

}

import Cuckoo
import MixboxUiTestsFoundation

import MixboxTestsFoundation

public class MockSnapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator, Cuckoo.ProtocolMock {

    public typealias MocksType = SnapshotsDifferenceAttachmentGenerator

    public typealias Stubbing = __StubbingProxy_SnapshotsDifferenceAttachmentGenerator
    public typealias Verification = __VerificationProxy_SnapshotsDifferenceAttachmentGenerator

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: SnapshotsDifferenceAttachmentGenerator?

    public func enableDefaultImplementation(_ stub: SnapshotsDifferenceAttachmentGenerator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment] {

    return cuckoo_manager.call("attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment]",
            parameters: (snapshotsDifferenceDescription),
            escapingParameters: (snapshotsDifferenceDescription),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.attachments(snapshotsDifferenceDescription: snapshotsDifferenceDescription))

    }

	public struct __StubbingProxy_SnapshotsDifferenceAttachmentGenerator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func attachments<M1: Cuckoo.Matchable>(snapshotsDifferenceDescription: M1) -> Cuckoo.ProtocolStubFunction<(SnapshotsDifferenceDescription), [Attachment]> where M1.MatchedType == SnapshotsDifferenceDescription {
	        let matchers: [Cuckoo.ParameterMatcher<(SnapshotsDifferenceDescription)>] = [wrap(matchable: snapshotsDifferenceDescription) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSnapshotsDifferenceAttachmentGenerator.self, method: "attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment]", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_SnapshotsDifferenceAttachmentGenerator: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func attachments<M1: Cuckoo.Matchable>(snapshotsDifferenceDescription: M1) -> Cuckoo.__DoNotUse<(SnapshotsDifferenceDescription), [Attachment]> where M1.MatchedType == SnapshotsDifferenceDescription {
	        let matchers: [Cuckoo.ParameterMatcher<(SnapshotsDifferenceDescription)>] = [wrap(matchable: snapshotsDifferenceDescription) { $0 }]
	        return cuckoo_manager.verify("attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class SnapshotsDifferenceAttachmentGeneratorStub: SnapshotsDifferenceAttachmentGenerator {

    public func attachments(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) -> [Attachment]  {
        return DefaultValueRegistry.defaultValue(for: ([Attachment]).self)
    }

}

import Cuckoo
import MixboxInAppServices

import MixboxFoundation

public class MockAllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory, Cuckoo.ProtocolMock {

    public typealias MocksType = AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory

    public typealias Stubbing = __StubbingProxy_AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory
    public typealias Verification = __VerificationProxy_AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory?

    public func enableDefaultImplementation(_ stub: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler {

    return cuckoo_manager.call("allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler",
            parameters: (enhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider, baseClass, selector, methodType),
            escapingParameters: (enhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider, baseClass, selector, methodType),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: enhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: objcMethodsWithUniqueImplementationProvider, baseClass: baseClass, selector: selector, methodType: methodType))

    }

	public struct __StubbingProxy_AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(enhancedAccessibilityLabelMethodSwizzler: M1, objcMethodsWithUniqueImplementationProvider: M2, baseClass: M3, selector: M4, methodType: M5) -> Cuckoo.ProtocolStubFunction<(EnhancedAccessibilityLabelMethodSwizzler, ObjcMethodsWithUniqueImplementationProvider, NSObject.Type, Selector, MethodType), AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler> where M1.MatchedType == EnhancedAccessibilityLabelMethodSwizzler, M2.MatchedType == ObjcMethodsWithUniqueImplementationProvider, M3.MatchedType == NSObject.Type, M4.MatchedType == Selector, M5.MatchedType == MethodType {
	        let matchers: [Cuckoo.ParameterMatcher<(EnhancedAccessibilityLabelMethodSwizzler, ObjcMethodsWithUniqueImplementationProvider, NSObject.Type, Selector, MethodType)>] = [wrap(matchable: enhancedAccessibilityLabelMethodSwizzler) { $0.0 }, wrap(matchable: objcMethodsWithUniqueImplementationProvider) { $0.1 }, wrap(matchable: baseClass) { $0.2 }, wrap(matchable: selector) { $0.3 }, wrap(matchable: methodType) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory.self, method: "allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(enhancedAccessibilityLabelMethodSwizzler: M1, objcMethodsWithUniqueImplementationProvider: M2, baseClass: M3, selector: M4, methodType: M5) -> Cuckoo.__DoNotUse<(EnhancedAccessibilityLabelMethodSwizzler, ObjcMethodsWithUniqueImplementationProvider, NSObject.Type, Selector, MethodType), AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler> where M1.MatchedType == EnhancedAccessibilityLabelMethodSwizzler, M2.MatchedType == ObjcMethodsWithUniqueImplementationProvider, M3.MatchedType == NSObject.Type, M4.MatchedType == Selector, M5.MatchedType == MethodType {
	        let matchers: [Cuckoo.ParameterMatcher<(EnhancedAccessibilityLabelMethodSwizzler, ObjcMethodsWithUniqueImplementationProvider, NSObject.Type, Selector, MethodType)>] = [wrap(matchable: enhancedAccessibilityLabelMethodSwizzler) { $0.0 }, wrap(matchable: objcMethodsWithUniqueImplementationProvider) { $0.1 }, wrap(matchable: baseClass) { $0.2 }, wrap(matchable: selector) { $0.3 }, wrap(matchable: methodType) { $0.4 }]
	        return cuckoo_manager.verify("allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactoryStub: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory {

    public func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler  {
        return DefaultValueRegistry.defaultValue(for: (AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler).self)
    }

}

import Cuckoo
import MixboxInAppServices

public class MockEnhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler, Cuckoo.ProtocolMock {

    public typealias MocksType = EnhancedAccessibilityLabelMethodSwizzler

    public typealias Stubbing = __StubbingProxy_EnhancedAccessibilityLabelMethodSwizzler
    public typealias Verification = __VerificationProxy_EnhancedAccessibilityLabelMethodSwizzler

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: EnhancedAccessibilityLabelMethodSwizzler?

    public func enableDefaultImplementation(_ stub: EnhancedAccessibilityLabelMethodSwizzler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func swizzleAccessibilityLabelMethod(method: Method)  {

    return cuckoo_manager.call("swizzleAccessibilityLabelMethod(method: Method)",
            parameters: (method),
            escapingParameters: (method),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.swizzleAccessibilityLabelMethod(method: method))

    }

	public struct __StubbingProxy_EnhancedAccessibilityLabelMethodSwizzler: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func swizzleAccessibilityLabelMethod<M1: Cuckoo.Matchable>(method: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Method)> where M1.MatchedType == Method {
	        let matchers: [Cuckoo.ParameterMatcher<(Method)>] = [wrap(matchable: method) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEnhancedAccessibilityLabelMethodSwizzler.self, method: "swizzleAccessibilityLabelMethod(method: Method)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_EnhancedAccessibilityLabelMethodSwizzler: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func swizzleAccessibilityLabelMethod<M1: Cuckoo.Matchable>(method: M1) -> Cuckoo.__DoNotUse<(Method), Void> where M1.MatchedType == Method {
	        let matchers: [Cuckoo.ParameterMatcher<(Method)>] = [wrap(matchable: method) { $0 }]
	        return cuckoo_manager.verify("swizzleAccessibilityLabelMethod(method: Method)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class EnhancedAccessibilityLabelMethodSwizzlerStub: EnhancedAccessibilityLabelMethodSwizzler {

    public func swizzleAccessibilityLabelMethod(method: Method)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }

}

import Cuckoo
import MixboxInAppServices

import MixboxFoundation

public class MockObjcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider, Cuckoo.ProtocolMock {

    public typealias MocksType = ObjcMethodsWithUniqueImplementationProvider

    public typealias Stubbing = __StubbingProxy_ObjcMethodsWithUniqueImplementationProvider
    public typealias Verification = __VerificationProxy_ObjcMethodsWithUniqueImplementationProvider

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: ObjcMethodsWithUniqueImplementationProvider?

    public func enableDefaultImplementation(_ stub: ObjcMethodsWithUniqueImplementationProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func objcMethodsWithUniqueImplementation(baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> [ObjcMethodWithUniqueImplementation] {

    return cuckoo_manager.call("objcMethodsWithUniqueImplementation(baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> [ObjcMethodWithUniqueImplementation]",
            parameters: (baseClass, selector, methodType),
            escapingParameters: (baseClass, selector, methodType),
            superclassCall:

                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.objcMethodsWithUniqueImplementation(baseClass: baseClass, selector: selector, methodType: methodType))

    }

	public struct __StubbingProxy_ObjcMethodsWithUniqueImplementationProvider: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func objcMethodsWithUniqueImplementation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(baseClass: M1, selector: M2, methodType: M3) -> Cuckoo.ProtocolStubFunction<(NSObject.Type, Selector, MethodType), [ObjcMethodWithUniqueImplementation]> where M1.MatchedType == NSObject.Type, M2.MatchedType == Selector, M3.MatchedType == MethodType {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject.Type, Selector, MethodType)>] = [wrap(matchable: baseClass) { $0.0 }, wrap(matchable: selector) { $0.1 }, wrap(matchable: methodType) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockObjcMethodsWithUniqueImplementationProvider.self, method: "objcMethodsWithUniqueImplementation(baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> [ObjcMethodWithUniqueImplementation]", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_ObjcMethodsWithUniqueImplementationProvider: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func objcMethodsWithUniqueImplementation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(baseClass: M1, selector: M2, methodType: M3) -> Cuckoo.__DoNotUse<(NSObject.Type, Selector, MethodType), [ObjcMethodWithUniqueImplementation]> where M1.MatchedType == NSObject.Type, M2.MatchedType == Selector, M3.MatchedType == MethodType {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject.Type, Selector, MethodType)>] = [wrap(matchable: baseClass) { $0.0 }, wrap(matchable: selector) { $0.1 }, wrap(matchable: methodType) { $0.2 }]
	        return cuckoo_manager.verify("objcMethodsWithUniqueImplementation(baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> [ObjcMethodWithUniqueImplementation]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class ObjcMethodsWithUniqueImplementationProviderStub: ObjcMethodsWithUniqueImplementationProvider {

    public func objcMethodsWithUniqueImplementation(baseClass: NSObject.Type, selector: Selector, methodType: MethodType) -> [ObjcMethodWithUniqueImplementation]  {
        return DefaultValueRegistry.defaultValue(for: ([ObjcMethodWithUniqueImplementation]).self)
    }

}

