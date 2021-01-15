import XCTest

final class NetworkRecordingTests: BaseNetworkMockingTestCase {
    func test_networkRecording_works() {
        open(screen: screen)
            .waitUntilViewIsLoaded()
        
        screen.localhost.withoutTimeout.tap()
        
        XCTAssertEqual(
            legacyNetworking.recording.lastRequest(urlPattern: "localhost")?.responseString(),
            notStubbedText
        )
    }
}
