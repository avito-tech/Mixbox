public protocol AutomaticRecorderAndReplayerCreationSettingsProvider: class {
    func automaticRecorderAndReplayerCreationSettings(
        session: RecordedNetworkSessionPath)
        -> AutomaticRecorderAndReplayerCreationSettings
}
