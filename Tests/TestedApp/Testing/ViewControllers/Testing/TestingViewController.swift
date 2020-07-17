import UIKit

final class TestingViewController: UIViewController {
    private let viewFactory: () -> UIView
    
    init(viewFactory: @escaping () -> UIView) {
        self.viewFactory = viewFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Display errors instead of fallback?
    override func loadView() {
        self.view = viewFactory()
    }
}
