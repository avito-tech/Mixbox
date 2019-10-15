import Bash
import Tasks
import SingletonHell
import Xcodebuild
import CiFoundation
import Destinations
import Bundler

public final class CheckDemoTask: LocalTask {
    public let name = "CheckDemoTask"
    
    private let bashExecutor: BashExecutor
    private let iosProjectBuilder: IosProjectBuilder
    private let environmentProvider: EnvironmentProvider
    private let mixboxTestDestinationProvider: MixboxTestDestinationProvider
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        iosProjectBuilder: IosProjectBuilder,
        environmentProvider: EnvironmentProvider,
        mixboxTestDestinationProvider: MixboxTestDestinationProvider,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.iosProjectBuilder = iosProjectBuilder
        self.environmentProvider = environmentProvider
        self.mixboxTestDestinationProvider = mixboxTestDestinationProvider
        self.bundlerCommandGenerator = bundlerCommandGenerator
    }
    
    public func execute() throws {
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        
        let xcodebuildPipeFilter = try bundlerCommandGenerator.bundlerCommand(
            command:
            """
            xcpretty -r junit -o "\(reportsPath)/junit.xml"
            """
        )
        
        try iosProjectBuilder.test(
            projectDirectoryFromRepoRoot: "Demos/OversimplifiedDemo",
            scheme: "OversimplifiedDemo",
            workspaceName: "OversimplifiedDemo",
            testDestination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
    }
}
