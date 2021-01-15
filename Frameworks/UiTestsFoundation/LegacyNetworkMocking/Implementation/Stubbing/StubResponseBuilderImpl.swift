import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxFoundation

public class StubResponseBuilderImpl: StubResponseBuilder {
    private let urlPattern: String
    private let httpMethod: HttpMethod?
    private let legacyNetworkStubRepository: LegacyNetworkStubRepository
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    
    public init(
        urlPattern: String,
        httpMethod: HttpMethod?,
        legacyNetworkStubRepository: LegacyNetworkStubRepository,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter)
    {
        self.urlPattern = urlPattern
        self.httpMethod = httpMethod
        self.legacyNetworkStubRepository = legacyNetworkStubRepository
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
    }
    
    public func withResponse(
        value: StubResponseBuilderResponseValue,
        variation: URLResponseProtocolVariation,
        responseTime: TimeInterval)
    {
        do {
            let stub = try LegacyNetworkStub(
                urlPattern: urlPattern,
                httpMethod: httpMethod,
                value: value,
                variation: variation,
                responseTime: responseTime
            )
            
            legacyNetworkStubRepository.add(
                stub: stub
            )
        } catch {
            testFailureRecorder.recordFailure(
                description: "\(error)",
                // This is wrong, but this code (implementation of a legacy protocol) should be removed soon:
                fileLine: .current(),
                shouldContinueTest: false
            )
        }
    }
}
