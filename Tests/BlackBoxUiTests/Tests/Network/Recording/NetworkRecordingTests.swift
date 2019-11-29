import XCTest

// TODO: Share with GrayBoxUiTests
final class NetworkRecordingTests: BaseNetworkMockingTestCase {
    func test_networkRecording_works() {
        legacyNetworking.recording.startRecording()
        
        openScreen(screen)
            .waitUntilViewIsLoaded()
        
        screen.localhost.withoutTimeout.tap()
        
        XCTAssertEqual(
            legacyNetworking.recording.lastRequest(urlPattern: "localhost")?.responseString(),
            notStubbedText
        )
    }
}
