import Bash

public protocol SimctlExecutor {
    func execute(arguments: [String]) throws -> ProcessResult
}
