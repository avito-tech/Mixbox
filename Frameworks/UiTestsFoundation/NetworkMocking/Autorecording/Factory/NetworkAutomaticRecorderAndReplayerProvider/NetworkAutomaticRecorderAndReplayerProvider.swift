import MixboxFoundation

public protocol NetworkAutomaticRecorderAndReplayerProvider {
    func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
}
