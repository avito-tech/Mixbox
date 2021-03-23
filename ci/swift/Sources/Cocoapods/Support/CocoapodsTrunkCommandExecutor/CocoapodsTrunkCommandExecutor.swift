import Bash

public protocol CocoapodsTrunkCommandExecutor {
    func execute(
        arguments: [String])
        throws
        -> ProcessResult
}
