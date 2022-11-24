import MixboxFoundation
import MixboxTestsFoundation
import MixboxIpcCommon

// TODO: Move to a separate entity? current implementation violates DI/SRP.
extension SynchronousKeyboardEventInjector {
    // E.g.: inject { press in press.command(press.a()) }
    public func inject(
        builder: (_ press: KeyboardEventBuilder) -> [KeyboardEventBuilder.Key])
        throws
    {
        let events = KeyboardEventBuilder().build(builder)
        try inject(events: events)
    }
}
