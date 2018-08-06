import MixboxIpcCommon

public protocol KeyboardEventInjector {
    func inject(events: [KeyboardEvent], completion: @escaping () -> ())
}
