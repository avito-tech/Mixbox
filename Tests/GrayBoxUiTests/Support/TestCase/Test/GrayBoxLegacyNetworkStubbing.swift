import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxReporting

final class GrayBoxLegacyNetworkStubbing: LegacyNetworkStubbing {
    private let testFailureRecorder: TestFailureRecorder
    private let spinner: Spinner
    
    private let bridgedUrlProtocolClass: GrayBoxLegacyNetworkStubbingBridgedUrlProtocolClass
    
    init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner)
    {
        self.bridgedUrlProtocolClass = GrayBoxLegacyNetworkStubbingBridgedUrlProtocolClass(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: testFailureRecorder
        )
        self.testFailureRecorder = testFailureRecorder
        self.spinner = spinner
    }
    
    func withRequestStub(
        urlPattern: String,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        return GrayBoxLegacyNetworkStubbingStubResponseBuilder(
            urlPattern: urlPattern,
            httpMethod: httpMethod,
            grayBoxLegacyNetworkStubbingNetworkStubRepository: bridgedUrlProtocolClass,
            testFailureRecorder: testFailureRecorder,
            spinner: spinner
        )
    }
    
    func removeAllStubs() {
        bridgedUrlProtocolClass.removeAllStubs()
    }
}
