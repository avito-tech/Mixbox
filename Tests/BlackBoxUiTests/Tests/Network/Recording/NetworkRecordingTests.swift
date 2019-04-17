import XCTest

final class NetworkRecordingTests: BaseNetworkMockingTestCase {
    func test_networkRecording_works() {
        networking.recording.startRecording()
        
        openScreen(name: screen.view)
        
        screen.localhost.tap()
        
        XCTAssertEqual(
            networking.recording.lastRequest(urlPattern: "localhost")?.responseString(),
            notStubbedText
        )
    }
}
