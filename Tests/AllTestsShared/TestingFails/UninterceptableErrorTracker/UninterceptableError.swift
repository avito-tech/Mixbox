import MixboxFoundation

final class UninterceptableError {
    let error: Error
    let fileLine: FileLine
    
    init(error: Error, fileLine: FileLine) {
        self.error = error
        self.fileLine = fileLine
    }
}
