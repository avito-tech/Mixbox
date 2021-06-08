public protocol TouchInjector: AnyObject {
    func enqueue(enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo)
    func startInjectionIfNecessary()
    func waitForInjectionToFinish()
}
