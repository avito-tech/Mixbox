import TestsIpc
import MixboxUiKit
import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

public final class ScrollingTriesToMakeViewFullyVisibleTestsView:
    UIScrollView,
    InitializableWithTestingViewControllerSettings
{
    private var button = TapIndicatorButton()
    private var overlappingView = UIButton()
    private var configuration = ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration(
        buttonFrame: .zero,
        contentSize: .zero,
        overlappingViewSize: .zero
    )
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerAsyncResetUiMethod(
            view: self,
            argumentType: ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration.self)
        { view, configuration, completion in
            view.resetUi(configuration: configuration)
            completion()
        }
        
        backgroundColor = .white
        button.accessibilityIdentifier = "button"
        button.backgroundColor = .blue
        overlappingView.backgroundColor = .gray
        
        addSubview(button)
        addSubview(overlappingView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        overlappingView.frame = CGRect.mb_init(
            bottom: bounds.mb_bottom,
            centerX: bounds.mb_centerX,
            size: configuration.overlappingViewSize
        )
        
        button.frame = configuration.buttonFrame
    }
    
    private func resetUi(configuration: ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration) {
        self.configuration = configuration
        
        button.reset()
        
        contentSize = .zero // resets offset
        contentSize = configuration.contentSize
        
        setNeedsLayout()
    }
}
