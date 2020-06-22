import Foundation
import UIKit

public final class RecordedNetworkSessionFileLoaderImpl: RecordedNetworkSessionFileLoader {
    public init() {
    }
    
    public func recordedNetworkSession(path: String) throws -> RecordedNetworkSession {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(RecordedNetworkSession.self, from: data)
    }
}
