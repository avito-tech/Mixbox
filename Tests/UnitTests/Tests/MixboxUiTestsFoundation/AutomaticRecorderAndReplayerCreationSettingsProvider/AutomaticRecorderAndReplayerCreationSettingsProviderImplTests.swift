import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class AutomaticRecorderAndReplayerCreationSettingsProviderImplTests: XCTestCase {
    private let provider = AutomaticRecorderAndReplayerCreationSettingsProviderImpl(
        bundleResourcePathProvider: BundleResourcePathProviderImpl(
            bundle: Bundle(for: BundleResourcePathProviderImplTests.self)
        ),
        recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoaderImpl()
    )
    
    func test_automaticRecorderAndReplayerCreationSettings_returnsReplaying_ifFileContainsSession() {
        let settings = provider.automaticRecorderAndReplayerCreationSettings(
            session: .default()
        )
        
        XCTAssertEqual(
            settings,
            .createForReplaying(
                recordedNetworkSession: RecordedNetworkSession(
                    buckets: []
                )
            )
        )
    }
    
    func test_automaticRecorderAndReplayerCreationSettings_returnsError_ifFileDoesntExist() {
        let settings = provider.automaticRecorderAndReplayerCreationSettings(
            session: RecordedNetworkSessionPath
                .nearHere()
                .withName("nonExistent-5F4F01AD-EF1E-4C6F-9A91-14AB3D140530")
        )
        
        switch settings {
        case .failWithError(let message):
            let expectedPartOfMessage = "Couldn't load session! Session will be created automatically and stored to file if file exists. Otherwise you will see this failure. Nested error:"
            XCTAssert(
                message.contains(expectedPartOfMessage),
                """
                error doesn't contain expected part of message: "\(expectedPartOfMessage)", actual message: "\(message)"
                """
            )
        default:
            // swiftlint:disable:next xctfail_message
            XCTFail()
        }
    }
    
    func test_automaticRecorderAndReplayerCreationSettings_returnsRecording_ifFileDoesntContainSession() {
        let session = RecordedNetworkSessionPath
            .nearHere()
            .withName("AutomaticRecorderAndReplayerCreationSettingsProviderImplTests.empty.json")
        
        let settings = provider.automaticRecorderAndReplayerCreationSettings(
            session: session
        )
        
        switch settings {
        case .createForRecording(let recordedNetworkSessionPath):
            XCTAssert(recordedNetworkSessionPath.contains(session.resourceName))
            XCTAssert(FileManager.default.fileExists(atPath: recordedNetworkSessionPath))
        default:
            // swiftlint:disable:next xctfail_message
            XCTFail()
        }
    }
}
