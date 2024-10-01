#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

public final class PageObjectElementGenerationWizardView: UIView {
    public var selectedRect: CGRect? {
        didSet {
            if let selectedRect = selectedRect {
                selectedRectView.frame = selectedRect
                selectedRectView.isHidden = false
            } else {
                selectedRectView.isHidden = true
            }
        }
    }
    
    private let selectedRectView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        selectedRectView.layer.borderWidth = UIScreen.main.scale
        selectedRectView.layer.borderColor = UIColor.red.cgColor
        selectedRectView.backgroundColor = .clear
        
        addSubview(selectedRectView)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
