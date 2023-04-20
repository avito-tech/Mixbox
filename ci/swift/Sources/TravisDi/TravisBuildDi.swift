import DI
import Tasks
import CiDi
import Bundler

public final class TravisBuildDependencies: CommonBuildDependencies {
    override public func registerDependenciesOfCurrentModule(di: DependencyRegisterer) {
        super.registerDependenciesOfCurrentModule(di: di)
        
        di.register(type: LocalTaskExecutor.self) {
            TravisLocalTaskExecutor()
        }
        di.register(type: BundlerBashCommandGenerator.self) { di in
            try BundlerBashCommandGeneratorImpl(
                gemfileLocationProvider: di.resolve(),
                bashEscapedCommandMaker: di.resolve(),
                bundlerToUse: .install(version: "2.1.2")
            )
        }
    }
}
