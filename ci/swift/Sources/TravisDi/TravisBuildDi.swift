import Dip
import Tasks
import Di

public final class TravisBuildDi: CommonDi {
    override public func registerAll(container: DependencyContainer) {
        super.registerAll(container: container)
        
        container.register(type: LocalTaskExecutor.self) {
            TravisLocalTaskExecutor()
        }
    }
}
