import Bash

public protocol Brew {
    // isExecutable: true if executable will be in PATH. Allows faster check for presence.
    func install(name: String, isExecutable: Bool) throws
}

extension Brew {
    public func installExecutable(name: String) throws {
        try install(name: name, isExecutable: true)
    }
    
    public func installLibrary(name: String) throws {
        try install(name: name, isExecutable: false)
    }
}
