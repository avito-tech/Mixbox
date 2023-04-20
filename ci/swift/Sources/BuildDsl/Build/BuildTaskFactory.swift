import Tasks
import DI

public protocol BuildTaskFactory {
    func task(di: DependencyResolver) throws -> LocalTask
}
