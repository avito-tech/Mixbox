import Bash

public final class BrewImpl: Brew {
    private let bashExecutor: BashExecutor
    
    public init(bashExecutor: BashExecutor) {
        self.bashExecutor = bashExecutor
    }
    
    public func install(name: String, isExecutable: Bool) throws {
        let checkCommand: String
        
        if isExecutable {
            checkCommand = "which \(name)"
        } else {
            checkCommand = "brew ls --versions \(name)"
        }
        
        _ = try bashExecutor.executeOrThrow(
            command:
            """
            \(checkCommand) > /dev/null || brew install \(name)
            """
        )
    }
}
