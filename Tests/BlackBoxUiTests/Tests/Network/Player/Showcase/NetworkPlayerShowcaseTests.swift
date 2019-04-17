import MixboxUiTestsFoundation

final class NetworkPlayerShowcaseTests: BaseNetworkMockingTestCase {
    // Note: use this test to record session for other tests!
    func test_player_inReplayingMode_replays() {
        let player = networking.recording.player(session: .default())
        
        player.checkpoint(id: "ADB86909-6DD5-4056-86F7-784FD286FD7C")
        
        openScreen(name: screen.view)
        
        player.checkpoint(id: "FFA9231E-29A9-4646-9B70-91278E6FFC31")
        
        screen.exampleCom.tap()
        
        player.checkpoint(id: "360496D2-3C7D-4985-B2F2-A4C9BA2F5F8A")
        
        screen.info.assertMatches { element in
            element.text.startsWith("<!doctype html>")
        }
    }
    
    func test_player_inReplayingMode_fails_ifCheckpointsDoesntHaveId() {
        assertFails(
            description:
                """
                `id` wasn't specified in `checkpoint()` function (or in `checkpointImpl`, which I hope you didn't use directly). You can only skip setting id in recording mode (when file with records is empty). Please, remove all contents of file with records (but not the file) and retry.
                """,
            body: {
                let player = networking.recording.player(session: .default())
                
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
                let player = networking.recording.player(session: .default())
                
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
                let player = networking.recording.player(
                    session: RecordedNetworkSessionPath.nearHere().withName(nonExistingResource)
                )
                
                player.checkpoint()
                
                openScreen(name: screen.view)
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
                let player = networking.recording.player(
                    session: RecordedNetworkSessionPath(
                        resourceName: alwaysEmptyJson,
                        sourceCodePath: nonExistingFilePath
                    )
                )
                
                player.checkpoint()
                
                openScreen(name: screen.view)
            }
        )
    }
    
    func test_player_fails_afterRecording() {
        let recordedNetworkSessionFile = fileSystem.temporaryFile()
        
        assertFailsInRecordingMode {
            let player = networking.recording.player(
                session: RecordedNetworkSessionPath(
                    resourceName: alwaysEmptyJson,
                    sourceCodePath: recordedNetworkSessionFile.path
                )
            )
            
            player.checkpoint(id: "9D73E577-8699-48DF-867D-B2C0A9709109")
            
            openScreen(name: screen.view)
        }
    }
    
    private let alwaysEmptyJson = "NetworkPlayerShowcaseTests.alwaysEmpty.json"
}
