import MixboxFoundation

public protocol NetworkAutomaticRecorderAndReplayerProvider: AnyObject {
    func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
}
