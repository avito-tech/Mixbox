import UIKit
import MixboxUiKit
import TestsIpc
import WebKit

final class NonViewElementsTestsWebView: UIView, TestingView {
    private let webView = WKWebView(
        frame: .zero,
        configuration: WKWebViewConfiguration()
    )
    
    private let server = SingleResponseWebServer(
        response:
        """
        <!DOCTYPE html>
        <html>
          <head>
            <title>Text of the title</title>
          </head>
          <body>
            <h1>Text of the header</h1>
            <p>Text of the paragraph</p>
          </body>
        </html>
        """,
        contentType: SingleResponseWebServer.ContentTypes.html
    )
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(webView)
        
        do {
            try server.start()
            
            let url = try server.url()
        
            let request = URLRequest(url: url)
            webView.load(request)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        webView.frame = bounds
    }
}
