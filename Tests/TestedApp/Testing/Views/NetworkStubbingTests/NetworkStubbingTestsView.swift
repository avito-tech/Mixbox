import UIKit
import MixboxIpc
import MixboxFoundation
import TestsIpc

final class NetworkStubbingTestsView: TestStackScrollView, TestingView {
    private let server = SingleResponseWebServer(
        response: "This is NOT a stubbed string",
        contentType: SingleResponseWebServer.ContentTypes.plainText
    )
    private var infoLabel: UILabel?
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        accessibilityIdentifier = "view"
        
        infoLabel = addLabel(id: "info") { _ in }
        
        do {
            try server.start()
        } catch {
            setInfo(ErrorString(error))
        }
        
        addLabel(id: "port") {
            $0.text = "\(server.port)"
        }
        
        addRequestButtons()
        
        testingViewControllerSettings.viewIpc.register(
            method: NetworkStubbingTestsViewSetResponseIpcMethod(),
            closure:  { [weak self] message, completion in
                guard let strongSelf = self else {
                    completion(IpcVoid())
                    assertionFailure("self is nil")
                    return
                }
                
                DispatchQueue.main.async {
                    strongSelf.server.response = message
                    completion(IpcVoid())
                }
            }
        )
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
                guard let strongSelf = self else {
                    return
                }
                
                string(strongSelf.server.urlString) { string in
                    strongSelf.setInfo(string)
                }
            }
        }
    }
    
    private func setInfo(_ stringResult: Result<String, ErrorString>) {
        switch stringResult {
        case .success(let string):
            setInfo(string)
        case .failure(let error):
            setInfo(error)
        }
    }
    
    private func setInfo(_ string: String) {
        infoLabel?.text = string
        infoLabel?.textColor = .black
    }
    
    private func setInfo(_ error: ErrorString) {
        infoLabel?.text = "<ERROR: \(error)>"
        infoLabel?.textColor = .red
    }
}

func string(_ urlString: String, completion: @escaping (Result<String, ErrorString>) -> ()) {
    guard let url = URL(string: urlString) else {
        return completion(
            .failure(ErrorString("url is not valid: \(urlString)"))
        )
    }
    
    let task = URLSession.shared.dataTask(with: url) {(data, _, _) in
        DispatchQueue.main.async {
            guard let data = data else {
                return completion(
                    .failure(ErrorString("dataTask didn't return data"))
                )
            }
            guard let string = String(data: data, encoding: .utf8) else {
                return completion(
                    .failure(ErrorString("data is not UTF-8 string"))
                )
            }
        
            completion(.success(string))
        }
    }
    
    task.resume()
}
