import Foundation
import MixboxTestsFoundation

public final class AutomaticRecorderAndReplayerCreationSettingsProviderImpl: AutomaticRecorderAndReplayerCreationSettingsProvider {
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoader
    
    public init(
        bundleResourcePathProvider: BundleResourcePathProvider,
        recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoader)
    {
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.recordedNetworkSessionFileLoader = recordedNetworkSessionFileLoader
    }
    
    public func automaticRecorderAndReplayerCreationSettings(
        session: RecordedNetworkSessionPath)
        -> AutomaticRecorderAndReplayerCreationSettings
    {
        do {
            return modeForSituationWhenSessionResourceExist(
                recordedNetworkSessionResourcePath: try bundleResourcePathProvider.path(
                    resource: session.resourceName
                ),
                recordedNetworkSessionSourceCodePath: session.sourceCodePath
            )
        } catch {
            return couldntLoadSessionError(
                nestedError: "\(error)"
            )
        }
    }
    
    private func modeForSituationWhenSessionResourceExist(
        recordedNetworkSessionResourcePath: String,
        recordedNetworkSessionSourceCodePath: String)
        -> AutomaticRecorderAndReplayerCreationSettings
    {
        do {
            return .createForReplaying(
                recordedNetworkSession: try recordedNetworkSessionFileLoader.recordedNetworkSession(
                    path: recordedNetworkSessionResourcePath
                )
            )
        } catch _ {
            return modeForSituationWhenSessionDoesntExistInFileAndPlayerShouldRecord(
                recordedNetworkSessionSourceCodePath: recordedNetworkSessionSourceCodePath
            )
        }
    }
    
    private func modeForSituationWhenSessionDoesntExistInFileAndPlayerShouldRecord(
        recordedNetworkSessionSourceCodePath: String)
        -> AutomaticRecorderAndReplayerCreationSettings
    {
        // TODO: Remove singleton!
        if !FileManager.default.fileExists(atPath: recordedNetworkSessionSourceCodePath) {
            return couldntLoadSessionError(
                nestedError: """
                    Source code doesn't exist at specified path: "\(recordedNetworkSessionSourceCodePath)".
                    """
            )
        }
        
        return .createForRecording(
            recordedNetworkSessionPath: recordedNetworkSessionSourceCodePath
        )
    }
    
    private func couldntLoadSessionError(nestedError: String) -> AutomaticRecorderAndReplayerCreationSettings {
        return .failWithError(
            message:
                """
                Couldn't load session! \
                Session will be created automatically and stored to file if file exists. \
                Otherwise you will see this failure. \
                Nested error: \(nestedError)
                """
        )
    }
}
