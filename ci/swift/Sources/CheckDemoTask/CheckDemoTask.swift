import Bash
import Tasks
import SingletonHell
import Xcodebuild
import CiFoundation
import Destinations
import Bundler

public final class CheckDemoTask: LocalTask {
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
        try iosProjectBuilder.withPreparationAndCleanup(
            rebootSimulator: true,
            destination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            body: { builder, destination in
                _ = try builder.build(
                    projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
                    action: .build,
                    scheme: "Demo",
                    workspaceName: "UiTestsDemo",
                    destination: destination
                )
                
                _ = try builder.build(
                    projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
                    action: .test,
                    scheme: "BlackBoxTests",
                    workspaceName: "UiTestsDemo",
                    destination: destination
                )
                
                _ = try builder.build(
                    projectDirectoryFromRepoRoot: "Demos/UiTestsDemo",
                    action: .test,
                    scheme: "GrayBoxTests",
                    workspaceName: "UiTestsDemo",
                    destination: destination
                )
            }
        )
    }
}
