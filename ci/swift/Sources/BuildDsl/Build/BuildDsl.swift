import Tasks
import Di
import Darwin

// Example of main.swift:
//
// ```
// import BuildDsl
//
// Build.main { di in
//     try RunBlackBoxTestsTask(
//         bashExecutor: di.resolve()
//     )
// }
// ```
//
public final class BuildDsl {
    private init(di: Di) {
    }
    
    public static var teamcity: BuildDsl {
        return BuildDsl(
            di: TeamcityBuildDi()
        )
    }
    
    public static var travis: BuildDsl {
        return BuildDsl(
            di: TravisBuildDi()
        )
    }
    
    public func main(makeLocalTask: (Di) throws -> (LocalTask)) {
        do {
            // TODO: Support other CI.
            let di = TeamcityBuildDi()
            
            try di.bootstrap()
            
            let localTask = try makeLocalTask(di)
            
            let localTaskExecutor: LocalTaskExecutor = try di.resolve()
            
            execute(localTaskExecutor: localTaskExecutor, localTask: localTask)
        } catch {
            print("Caught error: \(error)")
            abort()
        }
    }
    
    // Suppresses 'Will never be executed' warning, that is happening if Never-returning function
    // is called inside do-catch block. Probably a bug in Swift.
    private func execute(localTaskExecutor: LocalTaskExecutor, localTask: LocalTask) {
        localTaskExecutor.execute(localTask: localTask)
    }
}
