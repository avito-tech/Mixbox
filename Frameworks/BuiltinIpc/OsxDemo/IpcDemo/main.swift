import MixboxIpc
import MixboxBuiltinIpc
import Foundation

//  Example usage of MixboxBuiltinIpc:

if let port = ProcessInfo.processInfo.environment["PORT"].flatMap({ UInt($0) }) {
    mainForSlave(port)
} else {
    mainForMaster()
}
