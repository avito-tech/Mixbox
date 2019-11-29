import MixboxUiTestsFoundation
import TestsIpc

// TODO: Share with GrayBoxUiTests
final class NetworkPlayerShowcaseTests: BaseNetworkMockingTestCase {
    // Note: use this test to record session for other tests!
    func test___player_replays_network_in_replaying_mode___basic_case() {
        let player = legacyNetworking.recording.player(session: .default())
        
        player.checkpoint(id: "ADB86909-6DD5-4056-86F7-784FD286FD7C")
        
        openScreen(screen)
            .waitUntilViewIsLoaded()
        
        player.checkpoint(id: "FFA9231E-29A9-4646-9B70-91278E6FFC31")
        
        screen.exampleCom.withoutTimeout.tap()
        
        player.checkpoint(id: "360496D2-3C7D-4985-B2F2-A4C9BA2F5F8A")
        
        screen.info.assertMatches { element in
            element.text.startsWith("<!doctype html>")
        }
    }
    
    // Note that test will fail in recording mode (see comments in test function body)
    func test___player_replays_network_in_replaying_mode___complex_case() {
        let player = legacyNetworking.recording.player(
            session: RecordedNetworkSessionPath
                .nearHere()
                .withName("MoreComplexExample")
                .addDefaultExtension()
        )
        
        player.checkpoint(id: "initial")
        
        openScreen(screen)
        
        setResponse("1")
        screen.localhost.tap()
        screen.info.assertHasText("1")
        
        player.checkpoint(id: "afterOneAction")
        
        setResponse("2")
        screen.localhost.tap()
        screen.info.assertHasText("4") // Last matching stub in bucket will be applied and this is OK for now.
        
        setResponse("3")
        screen.localhost.tap()
        screen.info.assertHasText("4") // Last matching stub in bucket will be applied and this is OK for now.
        
        setResponse("4")
        screen.localhost.tap()
        screen.info.assertHasText("4")
        
        player.checkpoint(id: "afterMultipleActions")
        
        setResponse("5")
        screen.localhost.tap()
        screen.info.assertHasText("5")
        
        player.checkpoint(id: "afterLastAction")
    }
    
    private func setResponse(_ string: String) {
        ipcClient.callOrFail(
            method: NetworkStubbingTestsViewSetResponseIpcMethod(),
            arguments: string
        )
    }
    
    func test_player_inReplayingMode_fails_ifCheckpointsDoesntHaveId() {
        assertFails(
            description:
                """
                `id` wasn't specified in `checkpoint()` function (or in `checkpointImpl`, which I hope you didn't use directly). You can only skip setting id in recording mode (when file with records is empty). Please, remove all contents of file with records (but not the file) and retry.
                """,
            body: {
                let player = legacyNetworking.recording.player(session: .default())
                
                player.checkpoint()
            }
        )
    }
    
    func test_player_inReplayingMode_fails_ifCheckpointsHaveSameIds() {
        assertFails(
            description: """
                Unexpected bucket id in recordedNetworkSession: FFA9231E-29A9-4646-9B70-91278E6FFC31. Expected bucket id (from source code  that calls `checkpoint`): ADB86909-6DD5-4056-86F7-784FD286FD7C. Maybe recordedNetworkSession is outdated and you need to rerecord it. Example that produce this failure (pseudocode): you have checkpoints [A, B] in code and [A, C] in recordedNetworkSession JSON, in that case C is not expected, B is expected.
                """,
            body: {
                let player = legacyNetworking.recording.player(session: .default())
                
                player.checkpoint(id: "ADB86909-6DD5-4056-86F7-784FD286FD7C")
                player.checkpoint(id: "ADB86909-6DD5-4056-86F7-784FD286FD7C")
            }
        )
    }
    
    func test_player_fails_ifSessionResourceDoesntExist() {
        let nonExistingResource = "5F4F01AD-EF1E-4C6F-9A91-14AB3D140530"
        let e = NSRegularExpression.escapedPattern(for:)
        
        assertFails(
            failureDescriptionMatchesRegularExpression: e("""
                Couldn't load session! Session will be created automatically and stored to file if file exists. Otherwise you will see this failure. Nested error: Bundle "
                """) + ".*?" + e("""
                " doesn't contain resource named "\(nonExistingResource)"
                """),
            body: {
                let player = legacyNetworking.recording.player(
                    session: RecordedNetworkSessionPath.nearHere().withName(nonExistingResource)
                )
                
                player.checkpoint()
                
                openScreen(screen)
            }
        )
    }
    
    func test_player_fails_ifSessionSourceCodeFileDoesntExist() {
        let nonExistingFilePath = "5F4F01AD-EF1E-4C6F-9A91-14AB3D140530"
        
        assertFails(
            description: """
                Couldn't load session! Session will be created automatically and stored to file if file exists. Otherwise you will see this failure. Nested error: Source code doesn't exist at specified path: "\(nonExistingFilePath)".
                """,
            body: {
                let player = legacyNetworking.recording.player(
                    session: RecordedNetworkSessionPath(
                        resourceName: alwaysEmptyJson,
                        sourceCodePath: nonExistingFilePath
                    )
                )
                
                player.checkpoint()
                
                openScreen(screen)
            }
        )
    }
    
    func test_player_fails_afterRecording() {
        let recordedNetworkSessionFile = fileSystem.temporaryFile()
        
        assertFailsInRecordingMode {
            let player = legacyNetworking.recording.player(
                session: RecordedNetworkSessionPath(
                    resourceName: alwaysEmptyJson,
                    sourceCodePath: recordedNetworkSessionFile.path
                )
            )
            
            player.checkpoint(id: "9D73E577-8699-48DF-867D-B2C0A9709109")
            
            openScreen(screen)
        }
    }
    
    private let alwaysEmptyJson = "NetworkPlayerShowcaseTests.alwaysEmpty.json"
}
