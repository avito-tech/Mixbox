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
            
            localTaskExecutor.execute(localTask: localTask)
        } catch {
            print("Caught error: \(error)")
            abort()
        }
    }
}
