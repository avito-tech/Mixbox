import GCDWebServer
import MixboxFoundation

// Utility to mimic web server. Runs on localhost.
final class SingleResponseWebServer {
    final class ContentTypes {
        static let plainText = "text/plain; charset=utf-8"
        static let html = "text/html; charset=utf-8"
        static let json = "application/json"
    }
    
    var response: String
    
    private let contentType: String
    private let server = GCDWebServer()
    
    init(response: String, contentType: String) {
        self.response = response
        self.contentType = contentType
    }
    
    var port: UInt {
        return server.port
    }
    
    var urlString: String {
        return "http://localhost:\(port)"
    }
    
    func url() throws -> URL {
        guard port != 0 else {
            throw ErrorString("Failed to make url: server was not started")
        }
        
        let urlString = self.urlString
        
        guard let url = URL(string: urlString) else {
            throw ErrorString("Failed to make url from \(urlString)")
        }
        
        return url
    }
    
    func start() throws {
        server.addDefaultHandler(forMethod: "GET", request: GCDWebServerDataRequest.self) { [weak self, contentType] _, completion in
            completion(
                GCDWebServerDataResponse(
                    data: self?.response.data(using: .utf8) ?? Data(),
                    contentType: contentType
                )
            )
        }
        
        try server.start(options: [:])
    }
}
