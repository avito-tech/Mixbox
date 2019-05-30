import MixboxIpcCommon
import MixboxIpc

public protocol KeyboardEventInjector: class {
    func inject(events: [KeyboardEvent])
}

extension KeyboardEventInjector {
    // E.g.: inject { press in press.command(press.a()) }
    public func inject(builder: (_ press: KeyboardEventBuilder) -> [KeyboardEventBuilder.Key]) {
        let events = KeyboardEventBuilder().build(builder)
        inject(events: events)
    }
}

public final class KeyboardEventInjectorImpl: KeyboardEventInjector {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func inject(events: [KeyboardEvent]) {
        // TODO: Handle result
        _ = ipcClient.call(
            method: InjectKeyboardEventsIpcMethod(),
            arguments: events
        )
    }
}
