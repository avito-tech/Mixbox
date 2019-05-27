public protocol RunLoopModesStackProvider {
    var runLoopModes: [CFRunLoopMode] { get }
}

extension RunLoopModesStackProvider {
    public var activeRunLoopMode: CFRunLoopMode? {
        return runLoopModes.first
    }
}
