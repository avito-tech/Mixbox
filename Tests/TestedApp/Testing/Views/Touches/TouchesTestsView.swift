import UIKit
import MixboxFoundation
import MixboxIpc
import TestsIpc

// Contract for tests:
// - All views should have fixed frames and other properties that affect coordinates
// - There should be a view with "targetView" accessibilityIdentifier
// - "targetView" should be on screen of every supported device.
final class TouchesTestsView: UIView, InitializableWithTestingViewControllerSettings {
    let scrollView =  UIScrollView()
    let simpleContainerView = UIView()
    let transformedContainerView = UIView()
    let targetView = UIView()
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        scrollView.backgroundColor = .green
        simpleContainerView.backgroundColor = .gray
        transformedContainerView.backgroundColor = .purple
        targetView.backgroundColor = .blue
        
        addSubview(scrollView)
        scrollView.addSubview(simpleContainerView)
        simpleContainerView.addSubview(transformedContainerView)
        transformedContainerView.addSubview(targetView)
        
        targetView.accessibilityIdentifier = "targetView"
        
        setViewsPositions()

    }
    
    private func setViewsPositions() {
        scrollView.frame = CGRect(x: -11, y: -13, width: 220, height: 220)
        scrollView.contentSize = CGSize(width: 10000, height: 10000)
        scrollView.contentOffset = CGPoint(x: -11, y: -13)
        
        simpleContainerView.frame = CGRect(x: 11, y: 13, width: 190, height: 190)
        
        transformedContainerView.frame = CGRect(x: 71, y: 43, width: 60, height: 60)
        
        targetView.frame = CGRect(x: 3, y: 4, width: 3, height: 3)
        
        // I have no idea why this magic works. Setting `transform` without `async` produces not intended transform.
        DispatchQueue.main.async {
            self.applyTransform()
        }
    }
    
    private func applyTransform() {
        transformedContainerView.transform = CGAffineTransform.identity
            .rotated(by: .pi / 6)
            .scaledBy(x: 2, y: 2)
            .translatedBy(x: 7, y: 9)
        
        targetView.testability_customValues["centerToWindow"] = targetView.convert(targetView.bounds.mb_center, to: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setViewsPositions()
    }
}
