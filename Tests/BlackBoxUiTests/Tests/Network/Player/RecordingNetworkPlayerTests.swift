import MixboxUiTestsFoundation
import MixboxFoundation
import XCTest

// TODO: Share with GrayBoxUiTests
final class RecordingNetworkPlayerTests: BaseNetworkMockingTestCase {
    private lazy var recordedNetworkSessionFile = fileSystem.temporaryFile()
    
    private lazy var recordingPlayer = RecordingNetworkPlayer(
        networkRecordsProvider: legacyNetworking.recording,
        networkRecorderLifecycle: legacyNetworking.recording,
        testFailureRecorder: dependencies.resolve(),
        waiter: waiter,
        recordedNetworkSessionPath: recordedNetworkSessionFile.path,
        onStart: {}
    )
    
    private func file(contents: String) -> TemporaryFile {
        let file = fileSystem
            .temporaryFile()
            .withContents(string: contents)
        
        return file
    }
    
    func test_checkpoint_insertsIdToItself() {
        // Given
        let player = recordingPlayer
        
        legacyNetworking.recording.startRecording()
        
        openScreen(screen)
            .waitUntilViewIsLoaded()
        
        let sourceCodeFile = file(contents: ".checkpoint()")
        
        // When
        assertFailsInRecordingMode {
            player.checkpointImpl(
                id: nil,
                fileLine: RuntimeFileLine(
                    file: sourceCodeFile.path,
                    line: 1
                )
            )
        }
        
        // Then
        let regularExpressionForInsertedIdIntoFunction = "\\.checkpoint\\(id: \".+?\"\\)"
        assert(
            contentsOfFile: sourceCodeFile,
            matchesRegularExpression: regularExpressionForInsertedIdIntoFunction
        )
    }
    
    private func assert(contentsOfFile file: TemporaryFile, matchesRegularExpression regularExpression: String) {
        guard let contents = file.contents else {
            XCTFail("file.contents == nil")
            return
        }
        
        assert(
            value: contents,
            matches: RegularExpressionMatcher(
                regularExpression: regularExpression
            )
        )
    }
}
