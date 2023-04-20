import Tasks
import CiDi
import TeamcityDi
import TravisDi
import DI
import Darwin

public final class BuildRunner {
    public static func run(
        build: Build
    ) {
        do {
            let di = build.di()
            
            let localTask = try build.task(di: di)
            
            let localTaskExecutor: LocalTaskExecutor = try di.resolve()
            
            execute(localTaskExecutor: localTaskExecutor, localTask: localTask)
        } catch {
            print("Caught error: \(error)")
            abort()
        }
    }
    
    // Suppresses 'Will never be executed' warning, that is happening if Never-returning function
    // is called inside do-catch block. Probably a bug in Swift.
    private static func execute(localTaskExecutor: LocalTaskExecutor, localTask: LocalTask) {
        localTaskExecutor.execute(localTask: localTask)
    }
}
