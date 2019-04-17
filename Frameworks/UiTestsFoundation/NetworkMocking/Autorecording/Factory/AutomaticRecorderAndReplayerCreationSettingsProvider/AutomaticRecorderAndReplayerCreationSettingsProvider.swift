public protocol AutomaticRecorderAndReplayerCreationSettingsProvider {
    func automaticRecorderAndReplayerCreationSettings(
        session: RecordedNetworkSessionPath)
        -> AutomaticRecorderAndReplayerCreationSettings
}
