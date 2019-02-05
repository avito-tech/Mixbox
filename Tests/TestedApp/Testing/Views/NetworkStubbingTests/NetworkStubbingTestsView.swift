import UIKit
import GCDWebServer

final class NetworkStubbingTestsView: TestStackScrollView {
    private let server = GCDWebServer()
    private var infoLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accessibilityIdentifier = "view"
        
        infoLabel = addLabel(id: "info") { _ in }
        
        startServer()
        
        addLabel(id: "port") {
            $0.text = "\(server.port)"
        }
        
        addRequestButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRequestButtons() {
        addButton(idAndText: "example.com") {
            $0.onTap = { [weak self] in
                string("http://example.com") { string in
                    self?.setInfo(string)
                }
            }
        }
        addButton(idAndText: "localhost") {
            
            $0.onTap = { [weak self] in
                if let port = self?.server.port {
                    string("http://localhost:\(port)") { string in
                        self?.setInfo(string)
                    }
                } else {
                    self?.setErrorInfo()
                }
            }
        }
    }
    
    private func setInfo(_ string: String?) {
        infoLabel?.text = string ?? "<ERROR>"
        infoLabel?.textColor = string == nil ? .red : .black
    }
    
    private func setErrorInfo() {
        setInfo(nil)
    }
    
    private func startServer() {
        server.addDefaultHandler(forMethod: "GET", request: GCDWebServerDataRequest.self) { request, completion in
            let contentType = "application/json"
            completion(GCDWebServerDataResponse(data: "test".data(using: .utf8) ?? Data(), contentType: contentType))
        }
        
        (try? server.start(options: [:])) ?? setInfo(nil)
    }
}

func string(_ url: String, completion: @escaping (String?) -> ()) {
    guard let url = URL(string: url) else { return completion(nil) }
    
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        DispatchQueue.main.async {
            guard let data = data else { return completion(nil) }
            guard let string = String(data: data, encoding: .utf8) else { return completion(nil) }
        
            completion(string)
        }
    }
    
    task.resume()
}
