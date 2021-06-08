public protocol NetworkReplayingObserver: AnyObject {
    func networkPlayerStartedReplaying()
    func networkPlayerStartedRecording()
}
