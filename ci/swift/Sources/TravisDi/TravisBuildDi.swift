import Dip
import Tasks
import Di
import Bundler

public final class TravisBuildDi: CommonDi {
    override public func registerAll(container: DependencyContainer) {
        super.registerAll(container: container)
        
        container.register(type: LocalTaskExecutor.self) {
            TravisLocalTaskExecutor()
        }
        container.register(type: BundlerBashCommandGenerator.self) {
            BundlerBashCommandGeneratorImpl(
                gemfileLocationProvider: try container.resolve(),
                bashEscapedCommandMaker: try container.resolve(),
                bundlerToUse: .install(version: "2.1.2")
            )
        }
    }
}
