#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol RunLoopModesStackProvider: AnyObject {
    var runLoopModes: [CFRunLoopMode] { get }
}

extension RunLoopModesStackProvider {
    public var activeRunLoopMode: CFRunLoopMode? {
        return runLoopModes.first
    }
}

#endif
