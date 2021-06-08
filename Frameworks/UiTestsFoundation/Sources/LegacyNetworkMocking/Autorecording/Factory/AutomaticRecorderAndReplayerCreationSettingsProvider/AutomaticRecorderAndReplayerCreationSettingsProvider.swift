public protocol AutomaticRecorderAndReplayerCreationSettingsProvider: AnyObject {
    func automaticRecorderAndReplayerCreationSettings(
        session: RecordedNetworkSessionPath)
        -> AutomaticRecorderAndReplayerCreationSettings
}
