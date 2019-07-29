import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxReporting

class GrayBoxLegacyNetworkStubbingStubResponseBuilder: StubResponseBuilder {
    private let urlPattern: String
    private let httpMethod: HttpMethod?
    private let grayBoxLegacyNetworkStubbingNetworkStubRepository: GrayBoxLegacyNetworkStubbingNetworkStubRepository
    private let testFailureRecorder: TestFailureRecorder
    private let spinner: Spinner
    
    init(
        urlPattern: String,
        httpMethod: HttpMethod?,
        grayBoxLegacyNetworkStubbingNetworkStubRepository: GrayBoxLegacyNetworkStubbingNetworkStubRepository,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner)
    {
        self.urlPattern = urlPattern
        self.httpMethod = httpMethod
        self.grayBoxLegacyNetworkStubbingNetworkStubRepository = grayBoxLegacyNetworkStubbingNetworkStubRepository
        self.testFailureRecorder = testFailureRecorder
        self.spinner = spinner
    }
    
    func withResponse(
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
        responseTime: TimeInterval)
    {
        do {
            let stub = try GrayBoxLegacyNetworkStubbingNetworkStub(
                urlPattern: urlPattern,
                httpMethod: httpMethod,
                value: value,
                headers: headers,
                statusCode: statusCode,
                responseTime: responseTime
            )
            
            grayBoxLegacyNetworkStubbingNetworkStubRepository.add(
                stub: stub
            )
            
            // Kludge! Should be fixed. How to reproduce: remove this run loop spinning and
            // run LegacyNetworkStubbingTests.test___requests_are_stubbed_in_correct_order()
            // The issue is that we need to spin run loop few times before new stub become active.
            // I don't know why this is happening.  Maybe its because of SBTUITestTunnel/IPC/something else.
            // TODO: Fix properly: synchronize adding stubs. New stub should take effect immediately in same thread.
            spinner.spin(timeout: 1)
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
