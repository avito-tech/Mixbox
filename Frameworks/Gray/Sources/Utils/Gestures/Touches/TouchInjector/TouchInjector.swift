public protocol TouchInjector: class {
    func enqueue(enqueuedMultiTouchInfo: EnqueuedMultiTouchInfo)
    func startInjectionIfNecessary()
    func waitForInjectionToFinish()
}
