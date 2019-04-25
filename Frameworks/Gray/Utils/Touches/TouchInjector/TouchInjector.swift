protocol TouchInjector {
    func enqueueForDelivery(touchInfo: TouchInfo)
    func waitUntilAllTouchesAreDeliveredUsingInjector()
}
