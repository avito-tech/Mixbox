import Cuckoo
import MixboxUiTestsFoundation

public class MockStubRequestBuilder: StubRequestBuilder, Cuckoo.ProtocolMock {
    public typealias MocksType = StubRequestBuilder
    public typealias Stubbing = __StubbingProxy_StubRequestBuilder
    public typealias Verification = __VerificationProxy_StubRequestBuilder

    private var __defaultImplStub: StubRequestBuilder?

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    public func enableDefaultImplementation(_ stub: StubRequestBuilder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func withRequestStub(urlPattern: String, query: [String]?, httpMethod: HttpMethod?)  -> StubResponseBuilder {

            return cuckoo_manager.call("withRequestStub(urlPattern: String, query: [String]?, httpMethod: HttpMethod?) -> StubResponseBuilder",
                parameters: (urlPattern, query, httpMethod),
                escapingParameters: (urlPattern, query, httpMethod),
                superclassCall:

                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.withRequestStub(urlPattern: urlPattern, query: query, httpMethod: httpMethod))

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
	    
	    
	    func withRequestStub<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(urlPattern: M1, query: M2, httpMethod: M3) -> Cuckoo.ProtocolStubFunction<(String, [String]?, HttpMethod?), StubResponseBuilder> where M1.MatchedType == String, M2.MatchedType == [String]?, M3.MatchedType == HttpMethod? {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [String]?, HttpMethod?)>] = [wrap(matchable: urlPattern) { $0.0 }, wrap(matchable: query) { $0.1 }, wrap(matchable: httpMethod) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStubRequestBuilder.self, method: "withRequestStub(urlPattern: String, query: [String]?, httpMethod: HttpMethod?) -> StubResponseBuilder", parameterMatchers: matchers))
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
	    func withRequestStub<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(urlPattern: M1, query: M2, httpMethod: M3) -> Cuckoo.__DoNotUse<StubResponseBuilder> where M1.MatchedType == String, M2.MatchedType == [String]?, M3.MatchedType == HttpMethod? {
	        let matchers: [Cuckoo.ParameterMatcher<(String, [String]?, HttpMethod?)>] = [wrap(matchable: urlPattern) { $0.0 }, wrap(matchable: query) { $0.1 }, wrap(matchable: httpMethod) { $0.2 }]
	        return cuckoo_manager.verify("withRequestStub(urlPattern: String, query: [String]?, httpMethod: HttpMethod?) -> StubResponseBuilder", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeAllStubs() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("removeAllStubs()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

public class StubRequestBuilderStub: StubRequestBuilder {

    public func withRequestStub(urlPattern: String, query: [String]?, httpMethod: HttpMethod?)  -> StubResponseBuilder {
        return DefaultValueRegistry.defaultValue(for: StubResponseBuilder.self)
    }

    public func removeAllStubs()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }

}

import Cuckoo
import MixboxUiTestsFoundation

public class MockStubResponseBuilder: StubResponseBuilder, Cuckoo.ProtocolMock {
    public typealias MocksType = StubResponseBuilder
    public typealias Stubbing = __StubbingProxy_StubResponseBuilder
    public typealias Verification = __VerificationProxy_StubResponseBuilder

    private var __defaultImplStub: StubResponseBuilder?

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    public func enableDefaultImplementation(_ stub: StubResponseBuilder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public func withResponse(value: StubResponseBuilderResponseValue, headers: [String: String], statusCode: Int, responseTime: TimeInterval)  {

            return cuckoo_manager.call("withResponse(value: StubResponseBuilderResponseValue, headers: [String: String], statusCode: Int, responseTime: TimeInterval)",
                parameters: (value, headers, statusCode, responseTime),
                escapingParameters: (value, headers, statusCode, responseTime),
                superclassCall:

                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.withResponse(value: value, headers: headers, statusCode: statusCode, responseTime: responseTime))

    }

	public struct __StubbingProxy_StubResponseBuilder: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func withResponse<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(value: M1, headers: M2, statusCode: M3, responseTime: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(StubResponseBuilderResponseValue, [String: String], Int, TimeInterval)> where M1.MatchedType == StubResponseBuilderResponseValue, M2.MatchedType == [String: String], M3.MatchedType == Int, M4.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(StubResponseBuilderResponseValue, [String: String], Int, TimeInterval)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: statusCode) { $0.2 }, wrap(matchable: responseTime) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockStubResponseBuilder.self, method: "withResponse(value: StubResponseBuilderResponseValue, headers: [String: String], statusCode: Int, responseTime: TimeInterval)", parameterMatchers: matchers))
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
	    func withResponse<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(value: M1, headers: M2, statusCode: M3, responseTime: M4) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == StubResponseBuilderResponseValue, M2.MatchedType == [String: String], M3.MatchedType == Int, M4.MatchedType == TimeInterval {
	        let matchers: [Cuckoo.ParameterMatcher<(StubResponseBuilderResponseValue, [String: String], Int, TimeInterval)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: statusCode) { $0.2 }, wrap(matchable: responseTime) { $0.3 }]
	        return cuckoo_manager.verify("withResponse(value: StubResponseBuilderResponseValue, headers: [String: String], statusCode: Int, responseTime: TimeInterval)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

public class StubResponseBuilderStub: StubResponseBuilder {

    public func withResponse(value: StubResponseBuilderResponseValue, headers: [String: String], statusCode: Int, responseTime: TimeInterval)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }

}
