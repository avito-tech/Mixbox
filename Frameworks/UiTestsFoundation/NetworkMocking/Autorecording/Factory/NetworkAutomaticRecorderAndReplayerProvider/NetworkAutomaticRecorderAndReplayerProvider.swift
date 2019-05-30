import MixboxFoundation

public protocol NetworkAutomaticRecorderAndReplayerProvider: class {
    func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
}
