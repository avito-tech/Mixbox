import Dip
import Bash
import CiFoundation
import Tasks
import Cocoapods
import Git
import Simctl
import Foundation
import Emcee

// TODO: Find a way to switch between CI`s.
public final class TeamcityBuildDi: Di {
    private let container = DependencyContainer()
    
    public init() {
    }
    
    public func bootstrap() throws {
        registerAll()
        
        try container.bootstrap()
    }
    
    public func resolve<T>() throws -> T {
        return try container.resolve()
    }
    
    // Private
    
    private func registerAll() {
        let container = self.container
        
        container.register(type: BashExecutor.self) {
            ProcessExecutorBashExecutor(
                processExecutor: try container.resolve(),
                environmentProvider: try container.resolve()
            )
        }
        container.register(type: ProcessExecutor.self) {
            LoggingProcessExecutor(
                originalProcessExecutor: FoundationProcessExecutor()
            )
        }
        container.register(type: LocalTaskExecutor.self) {
            TeamcityLocalTaskExecutor()
        }
        container.register(type: EnvironmentProvider.self) {
            EnvironmentSingletons.environmentProvider
        }
    }
}
