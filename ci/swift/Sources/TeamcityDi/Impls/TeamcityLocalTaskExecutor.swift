import Darwin
import CiFoundation
import Tasks

// Move to some "Teamcity" package
public final class TeamcityLocalTaskExecutor: LocalTaskExecutor {
    public init() {
    }
    
    public func execute(localTask: LocalTask) -> Never {
        print("##teamcity[progressMessage '\(localTask.name)']")
        
        func printStatus(success: Bool) {
            // Printing status disables "at least one test failed" "Failure condition"
            // TODO: Fix marking build as failed if test is failed.
            //
            // let status = success ? "SUCCESS" : "FAILURE"
            // print("##teamcity[buildStatus status='\(status)' text='\(localTask.name): {build.status.text}']")
        }
        
        do {
            try localTask.execute()
            printStatus(success: true)
        } catch {
            printStatus(success: false)
            if let error = error as? ErrorString {
                print("error: \(error.file):\(error.line): \(error.value)")
            } else {
                print("error: \(error)")
            }
            exit(1)
        }
        
        exit(0)
    }
}
