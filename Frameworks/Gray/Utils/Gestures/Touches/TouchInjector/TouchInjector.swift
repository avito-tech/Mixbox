public protocol TouchInjector: class {
    func enqueueForDelivery(touchInfo: TouchInfo)
    func waitUntilAllTouchesAreDeliveredUsingInjector()
}
