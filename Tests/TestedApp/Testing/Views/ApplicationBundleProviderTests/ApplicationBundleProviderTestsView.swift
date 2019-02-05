import UIKit
import MixboxFoundation

final class ApplicationBundleProviderTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLabel(id: "bundlePath") {
            $0.text = Bundle.main.bundlePath.mb_resolvingSymlinksInPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
