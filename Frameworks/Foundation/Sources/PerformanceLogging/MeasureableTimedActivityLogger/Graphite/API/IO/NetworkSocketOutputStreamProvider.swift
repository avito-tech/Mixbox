#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public final class NetworkSocketOutputStreamProvider: OutputStreamProvider {
    private let host: String
    private let port: Int
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case failedToObtainOutputStream(String, Int)
        
        public var description: String {
            switch self {
            case let .failedToObtainOutputStream(host, port):
                return "Failed to obtain output stream to \(host):\(port)"
            }
        }
    }
    
    public init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    public func createOutputStream() throws -> OutputStream {
        var generatedOutputStream: OutputStream?
        Stream.getStreamsToHost(
            withName: host,
            port: port,
            inputStream: nil,
            outputStream: &generatedOutputStream
        )
        guard let outputStream = generatedOutputStream else {
            throw Error.failedToObtainOutputStream(host, port)
        }
        return outputStream
    }
}

#endif
