public protocol NetworkRecording:
    NetworkRecordsProvider,
    NetworkRecorderLifecycle,
    NetworkAutomaticRecorderAndReplayerProvider
{
}
