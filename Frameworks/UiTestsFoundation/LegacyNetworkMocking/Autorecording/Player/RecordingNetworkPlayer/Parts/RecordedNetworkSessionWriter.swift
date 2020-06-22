import Foundation
import UIKit

final class RecordedNetworkSessionWriter {
    func write(
        recordedSession: RecordedNetworkSession,
        file: String)
        throws
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        try encoder
            .encode(recordedSession)
            .write(to: URL(fileURLWithPath: file))
    }
}
