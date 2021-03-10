import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpcCommon
import MixboxFoundation

public class GrayBoxLegacyNetworkStubbingStubResponseBuilder: StubResponseBuilder {
    private let urlPattern: String
    private let httpMethod: HttpMethod?
    private let grayBoxLegacyNetworkStubbingNetworkStubRepository: GrayBoxLegacyNetworkStubbingNetworkStubRepository
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    
    public init(
        urlPattern: String,
        httpMethod: HttpMethod?,
        grayBoxLegacyNetworkStubbingNetworkStubRepository: GrayBoxLegacyNetworkStubbingNetworkStubRepository,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter)
    {
        self.urlPattern = urlPattern
        self.httpMethod = httpMethod
        self.grayBoxLegacyNetworkStubbingNetworkStubRepository = grayBoxLegacyNetworkStubbingNetworkStubRepository
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
    }
    
    public func withResponse(
        value: StubResponseBuilderResponseValue,
        variation: URLResponseProtocolVariation,
        responseTime: TimeInterval)
    {
        do {
            let stub = try GrayBoxLegacyNetworkStubbingNetworkStub(
                urlPattern: urlPattern,
                httpMethod: httpMethod,
                value: value,
                variation: variation,
                responseTime: responseTime
            )
            
            grayBoxLegacyNetworkStubbingNetworkStubRepository.add(
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
