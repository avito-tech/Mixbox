import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class AutomaticRecorderAndReplayerCreationSettingsProviderImplTests: XCTestCase {
    private let provider = AutomaticRecorderAndReplayerCreationSettingsProviderImpl(
        bundleResourcePathProvider: BundleResourcePathProviderImpl(
            bundle: Bundle(for: BundleResourcePathProviderImplTests.self)
        ),
        recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoaderImpl()
    )
    
    func test___automaticRecorderAndReplayerCreationSettings___returns_createForReplaying_if_file_contains_session() {
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
    
    func test___automaticRecorderAndReplayerCreationSettings___returns_failWithError___if_file_doesnt_exist() {
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
    
    func test_FLAKY___automaticRecorderAndReplayerCreationSettings___returns_createForRecording___when_file_doesnt_contain_session() {
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
