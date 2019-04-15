import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxReporting

public final class SbtuiStubRequestBuilder: StubRequestBuilder {
    private let sbtuiStubApplier: SbtuiStubApplier
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        sbtuiStubApplier: SbtuiStubApplier,
        testFailureRecorder: TestFailureRecorder)
    {
        self.sbtuiStubApplier = sbtuiStubApplier
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func withRequestStub(
        urlRegexPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        let requestMatch = self.requestMatch(
            urlRegexPattern: urlRegexPattern,
            query: query,
            httpMethod: httpMethod
        )
        
        return SbtuiStubResponseBuilder(
            stubResponseBuilderArgumentsBefore: .requestMatch(requestMatch),
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
        )
    }
    
    public func withError(
        message: String)
        -> StubResponseBuilder
    {
        return SbtuiStubResponseBuilder(
            stubResponseBuilderArgumentsBefore: .error(message),
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
        )
    }
    
    public func removeAllStubs() {
        sbtuiStubApplier.removeAllStubs()
    }
    
    // TODO: Поправить nullability в SBTUITestTunnel.
    // Нужно сделать конструктор с nullable полями, так как внутри все nullable
    private func requestMatch(
        urlRegexPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> SBTRequestMatch
    {
        switch (query, httpMethod) {
        case let (.some(query), .some(httpMethod)):
            return SBTRequestMatch(
                url: urlRegexPattern,
                query: query,
                method: httpMethod.value
            )
        case let (.none, .some(httpMethod)):
            return SBTRequestMatch(
                url: urlRegexPattern,
                method: httpMethod.value
            )
        case let (.some(query), .none):
            return SBTRequestMatch(
                url: urlRegexPattern,
                query: query
            )
        case (.none, .none):
            return SBTRequestMatch(
                url: urlRegexPattern
            )
        }
    }
}
