import Darwin
import CiFoundation

// Move to some "Travis" package
public final class TravisLocalTaskExecutor: LocalTaskExecutor {
    public init() {
    }
    
    public func execute(localTask: LocalTask) -> Never {
        do {
            try localTask.execute()
        } catch {
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
