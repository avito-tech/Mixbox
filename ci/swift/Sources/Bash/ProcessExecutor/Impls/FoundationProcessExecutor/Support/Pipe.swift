import Foundation
import CiFoundation

class Pipe {
    let pipe = Foundation.Pipe()
    
    private let dataBox = MutableBox<Data>(value: Data()) // to not use weak self in closures
    private let queue = DispatchQueue(label: "Bash.Pipe.queue")
    
    init() {
    }
    
    func getDataSynchronously() -> Data {
        return queue.sync {
            return dataBox.value
        }
    }
    
    func setUp() {
        pipe.fileHandleForReading.readabilityHandler = { [queue, weak pipe, dataBox] handler in
            let data = handler.availableData
            
            if data.isEmpty {
                // TODO: Use `Process` `terminationHandler` to set `readabilityHandler` to nil?
                // Note about terminationHandler:
                // > This block is not guaranteed to be fully executed prior to waitUntilExit() returning.
                // https://developer.apple.com/documentation/foundation/process/1408746-terminationhandler
                pipe?.fileHandleForReading.readabilityHandler = nil
            }
            
            queue.async {
                dataBox.value.append(data)
            }
        }
    }
}
