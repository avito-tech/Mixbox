public enum AutomaticRecorderAndReplayerCreationSettings: Equatable {
    case failWithError(message: String)
    case createForRecording(recordedNetworkSessionPath: String)
    case createForReplaying(recordedNetworkSession: RecordedNetworkSession)

    public static func ==(
        l: AutomaticRecorderAndReplayerCreationSettings,
        r: AutomaticRecorderAndReplayerCreationSettings)
        -> Bool
    {
        switch (l, r) {
        case let (.failWithError(l), .failWithError(r)):
            return l == r
        case let (.createForRecording(l), .createForRecording(r)):
            return l == r
        case let (.createForReplaying(l), .createForReplaying(r)):
            return l == r
        default:
            return false
        }
    }
}
