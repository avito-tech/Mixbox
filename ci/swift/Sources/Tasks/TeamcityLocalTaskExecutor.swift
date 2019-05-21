import Darwin
import CiFoundation

// Move to some "Teamcity" package
public final class TeamcityLocalTaskExecutor: LocalTaskExecutor {
    public init() {
    }
    
    public func execute(localTask: LocalTask) -> Never {
        print("##teamcity[progressMessage '\(localTask.name)']")
        
        func printStatus(success: Bool) {
            let status = success ? "SUCCESS" : "FAILURE"
            print("##teamcity[buildStatus status='\(status)' text='\(localTask.name): {build.status.text}']")
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
