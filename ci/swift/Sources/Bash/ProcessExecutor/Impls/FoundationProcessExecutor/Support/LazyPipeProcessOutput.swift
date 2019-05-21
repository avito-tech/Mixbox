import CiFoundation
import Foundation

final class LazyProcessOutput: ProcessOutput {
    private let pipe: Pipe
    
    init(pipe: Pipe) {
        self.pipe = pipe
    }
    
    var data: Data {
        return pipe.getDataSynchronously()
    }
}
