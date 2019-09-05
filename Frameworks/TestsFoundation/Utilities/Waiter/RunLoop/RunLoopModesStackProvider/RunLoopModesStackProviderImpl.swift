public final class RunLoopModesStackProviderImpl: RunLoopModesStackProvider {
    public init() {
    }
    
    // TODO: Good implementation (e.g. steal from EarlGrey)
    public var runLoopModes: [CFRunLoopMode] {
        return RunLoop.current.currentMode.map { [CFRunLoopMode(rawValue: $0.rawValue as CFString)] } ?? []
    }
}
