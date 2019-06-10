import Dip
import Tasks

public final class TravisBuildDi: CommonDi {
    override public init() {}
    
    override public func registerAll(container: DependencyContainer) {
        super.registerAll(container: container)
        
        container.register(type: LocalTaskExecutor.self) {
            TravisLocalTaskExecutor()
        }
    }
}
