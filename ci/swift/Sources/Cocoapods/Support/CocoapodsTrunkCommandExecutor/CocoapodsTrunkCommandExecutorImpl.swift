import CiFoundation
import Bash

public final class CocoapodsTrunkCommandExecutorImpl: CocoapodsTrunkCommandExecutor {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider
    private let environmentProvider: EnvironmentProvider
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider,
        environmentProvider: EnvironmentProvider)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.cocoapodsTrunkTokenProvider = cocoapodsTrunkTokenProvider
        self.environmentProvider = environmentProvider
    }
    
    public func executeImpl(
        arguments: [String],
        shouldThrowOnNonzeroExitCode: Bool)
        throws
        -> ProcessResult
    {
        let arguments = ["trunk"] + arguments
        
        return try cocoapodsCommandExecutor.execute(
            arguments: arguments,
            environment: [
                "COCOAPODS_TRUNK_TOKEN": cocoapodsTrunkTokenProvider.cocoapodsTrunkToken()
            ].merging(environmentProvider.environment, uniquingKeysWith: { left, _ in left }),
            shouldThrowOnNonzeroExitCode: shouldThrowOnNonzeroExitCode
        )
    }
}
