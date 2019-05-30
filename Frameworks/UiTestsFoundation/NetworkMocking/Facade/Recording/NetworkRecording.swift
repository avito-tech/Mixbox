public protocol NetworkRecording:
    class,
    NetworkRecordsProvider,
    NetworkRecorderLifecycle,
    NetworkAutomaticRecorderAndReplayerProvider
{
}
