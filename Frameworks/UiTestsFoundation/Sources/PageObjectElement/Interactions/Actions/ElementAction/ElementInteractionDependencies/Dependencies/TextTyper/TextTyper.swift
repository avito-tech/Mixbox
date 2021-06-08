public protocol TextTyper: AnyObject {
    func type(instructions: [TextTyperInstruction]) throws
}

public extension TextTyper {
    func type(text: String) throws {
        try type(instructions: [.text(text)])
    }
    
    func type(key: TextTyperKey) throws {
        try type(instructions: [.key(key)])
    }
}
