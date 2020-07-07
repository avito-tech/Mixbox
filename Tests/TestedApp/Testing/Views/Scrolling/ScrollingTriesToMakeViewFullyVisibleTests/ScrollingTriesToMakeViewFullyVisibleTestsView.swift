import TestsIpc
import MixboxUiKit
import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

public final class ScrollingTriesToMakeViewFullyVisibleTestsView:
    UIView,
    InitializableWithTestingViewControllerSettings
{
    private var scrollView = UIScrollView()
    private var button = TapIndicatorButton()
    private var overlappingView = UIButton()
    private var configuration = ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration(
        buttonFrame: .zero,
        contentSize: .zero,
        overlappingViewFrame: .zero
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
        
        addSubview(scrollView)
        scrollView.addSubview(button)
        addSubview(overlappingView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        overlappingView.frame = configuration.overlappingViewFrame
        
        button.frame = configuration.buttonFrame
    }
    
    private func resetUi(configuration: ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration) {
        self.configuration = configuration
        
        button.reset()
        
        scrollView.contentSize = .zero // resets offset
        scrollView.contentSize = configuration.contentSize
        
        setNeedsLayout()
    }
}
