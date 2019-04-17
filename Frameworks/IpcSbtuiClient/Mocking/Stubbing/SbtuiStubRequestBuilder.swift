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
        urlPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        let requestMatch = self.requestMatch(
            urlPattern: urlPattern,
            query: query,
            httpMethod: httpMethod
        )
        
        return SbtuiStubResponseBuilder(
            stubResponseBuilderArgumentsBefore: .requestMatch(requestMatch),
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
        urlPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> SBTRequestMatch
    {
        switch (query, httpMethod) {
        case let (.some(query), .some(httpMethod)):
            return SBTRequestMatch(
                url: urlPattern,
                query: query,
                method: httpMethod.value
            )
        case let (.none, .some(httpMethod)):
            return SBTRequestMatch(
                url: urlPattern,
                method: httpMethod.value
            )
        case let (.some(query), .none):
            return SBTRequestMatch(
                url: urlPattern,
                query: query
            )
        case (.none, .none):
            return SBTRequestMatch(
                url: urlPattern
            )
        }
    }
}
