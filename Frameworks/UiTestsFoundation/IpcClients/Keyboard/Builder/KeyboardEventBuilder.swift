#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

// Very simple builder for very limited task. Typing CMD, A, V and Backspace.
// It doesn't pretend to be a generic solution at the moment. It may be improved in future if needed.
//
// Example: build { press in press.command(press.a()) }
//
// So it is just for readability of a simple task.
//
// Some external OSS projects with examples:
// - https://github.com/WebKit/webkit/blob/2324dbf6d438d673938f30b18e07350497ae7dad/Tools/WebKitTestRunner/ios/HIDEventGenerator.mm
public final class KeyboardEventBuilder {
    public final class Key {
        public let code: UInt16
        public let inBetween: [Key]
        
        public init(
            code: UInt16,
            inBetween: [Key])
        {
            self.code = code
            self.inBetween = inBetween
        }
    }
    
    public init() {
    }
    
    public func a(_ inBetween: [Key] = []) -> [Key] {
        return keys(4, inBetween)
    }
    public func v(_ inBetween: [Key] = []) -> [Key] {
        return keys(25, inBetween)
    }
    public func backspace(_ inBetween: [Key] = []) -> [Key] {
        return keys(42, inBetween)
    }
    public func command(_ inBetween: [Key] = []) -> [Key] {
        return keys(227, inBetween)
    }
    
    private func keys(_ code: UInt16, _ inBetween: [Key]) -> [Key] {
        return [Key(code: code, inBetween: inBetween)]
    }
    
    public func build(_ closure: (KeyboardEventBuilder) -> [Key]) -> [KeyboardEvent] {
        let keys = closure(self)
        var events = [KeyboardEvent]()
        visit(keys: keys, append: &events)
        return events
    }
    
    private func visit(keys: [Key], append events: inout [KeyboardEvent]) {
        let physicalKeyboardUsagePage: UInt16 = 7
        
        let usagePage = physicalKeyboardUsagePage
        for key in keys {
            events.append(KeyboardEvent(usagePage: usagePage, usage: key.code, down: true))
            visit(keys: key.inBetween, append: &events)
            events.append(KeyboardEvent(usagePage: usagePage, usage: key.code, down: false))
        }
    }
}

#endif
