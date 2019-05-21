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
    private init() {
    }
    
    public static func main(makeLocalTask: (Di) throws -> (LocalTask)) {
        BuildDsl().main(makeLocalTask: makeLocalTask)
    }
    
    private func main(makeLocalTask: (Di) throws -> (LocalTask)) {
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
