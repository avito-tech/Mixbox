import UIKit

public final class IntermediateBetweenTestsViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        let label = UILabel()
        
        label.backgroundColor = .green
        label.numberOfLines = 0
        label.text = "Application is running in tests. Use IPC to show view for a particular test"
        label.textAlignment = .center
        
        self.view = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
