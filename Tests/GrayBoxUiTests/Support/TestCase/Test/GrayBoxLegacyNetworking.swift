import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxGray
import MixboxReporting

final class GrayBoxLegacyNetworking: LegacyNetworking {
    let stubbing: LegacyNetworkStubbing
    
    var recording: LegacyNetworkRecording {
        grayNotImplemented()
    }
    
    init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner)
    {
        self.stubbing = GrayBoxLegacyNetworkStubbing(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: testFailureRecorder,
            spinner: spinner
        )
    }
}
