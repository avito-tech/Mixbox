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
    private let bundlerBashCommandGenerator: BundlerBashCommandGenerator
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    
    public init(
        bashExecutor: BashExecutor,
        iosProjectBuilder: IosProjectBuilder,
        environmentProvider: EnvironmentProvider,
        mixboxTestDestinationProvider: MixboxTestDestinationProvider,
        bundlerBashCommandGenerator: BundlerBashCommandGenerator,
        bashEscapedCommandMaker: BashEscapedCommandMaker)
    {
        self.bashExecutor = bashExecutor
        self.iosProjectBuilder = iosProjectBuilder
        self.environmentProvider = environmentProvider
        self.mixboxTestDestinationProvider = mixboxTestDestinationProvider
        self.bundlerBashCommandGenerator = bundlerBashCommandGenerator
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
    }
    
    public func execute() throws {
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        
        let xcodebuildPipeFilter = bashEscapedCommandMaker.escapedCommand(
            arguments: [
                "bash",
                "-c",
                try bundlerBashCommandGenerator.bashCommandRunningCommandBundler(
                    arguments: ["xcpretty", "-r", "junit", "-o", "\(reportsPath)/junit.xml"]
                )
            ]
        )
        
        _ = try iosProjectBuilder.build(
            projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
            action: .build,
            scheme: "Demo",
            workspaceName: "UiTestsDemo",
            testDestination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: "cat"
        )
        
        try iosProjectBuilder.test(
            projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
            scheme: "BlackBoxTests",
            workspaceName: "UiTestsDemo",
            testDestination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
        
        try iosProjectBuilder.test(
            projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
            scheme: "GrayBoxTests",
            workspaceName: "UiTestsDemo",
            testDestination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
    }
}
