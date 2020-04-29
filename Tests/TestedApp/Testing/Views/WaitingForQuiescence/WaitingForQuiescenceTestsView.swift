import TestsIpc
import MixboxUiKit
import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

// This view contains scroll with high inertia and a very small button.
// This view is used to check that even if UI is moving, actions will wait until it becomes stable.
// High inertia of scroll view and small size of button increases chances of failing a test if there is an issue with waiting.
public final class WaitingForQuiescenceTestsView:
    UIView,
    InitializableWithTestingViewControllerSettings
{
    // Buttons without special layout
    private var actionButtons = [UIView]()
    
    // This button has special layout
    private var tapIndicatorButtons = [TapIndicatorButton]()
    private let tapIndicatorButtonHeight: CGFloat = 1 // it is harder to tap smaller button
    
    private var configuration = WaitingForQuiescenceTestsViewConfiguration(
        contentSize: .zero,
        tapIndicatorButtons: [],
        actionButtons: []
    )
    
    private var scrollView = UIScrollView()
    
    private weak var navigationController: UINavigationController?
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerAsyncResetUiMethod(view: self, argumentType: WaitingForQuiescenceTestsViewConfiguration.self) { view, configuration, completion in
            view.resetUi(configuration: configuration, completion: completion)
        }
        
        navigationController = testingViewControllerSettings.navigationController
        
        resetUi(configuration: configuration, completion: {})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let insets: UIEdgeInsets
        
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            insets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        }
        
        let frameForContent = bounds.mb_shrinked(insets)
        
        scrollView.frame = bounds
        scrollView.contentInset = insets
        scrollView.contentSize = configuration.contentSize
        
        for (configuration, view) in zip(configuration.tapIndicatorButtons, tapIndicatorButtons) {
            view.frame = CGRect(
                x: frameForContent.mb_left,
                y: configuration.offset,
                width: frameForContent.width,
                height: tapIndicatorButtonHeight
            )
        }
        
        var actionButtonOffset: CGFloat = 50
        let actionButtonHeight: CGFloat = 50
        for actionButton in actionButtons {
            actionButton.frame = CGRect(
                x: 0,
                y: actionButtonOffset,
                width: scrollView.contentSize.width,
                height: actionButtonHeight
            )
            actionButtonOffset += actionButtonHeight
        }
    }
    
    private func resetUi(configuration: WaitingForQuiescenceTestsViewConfiguration, completion: @escaping () -> ()) {
        dismissEverything { [weak self] in
            guard let strongSelf = self else {
                completion()
                return
            }
            
            strongSelf.resetView(configuration: configuration) {
                completion()
            }
        }
    }
    
    private func resetView(configuration: WaitingForQuiescenceTestsViewConfiguration, completion: @escaping () -> ()) {
        subviews.forEach { $0.removeFromSuperview() }
        tapIndicatorButtons = []
        actionButtons = []
        
        scrollView = UIScrollView()
        scrollView.decelerationRate = .init(rawValue: 0.9999) // less deceleration than `.normal` (0.998)
        
        self.configuration = configuration
        
        backgroundColor = .white
        
        for button in configuration.tapIndicatorButtons {
            addTapIndicatorButton(id: button.id)
        }
        
        for button in configuration.actionButtons {
            switch button {
            case let .present(animated):
                addPresentButton(animated: animated, id: button.id)
            case let .push(animated):
                addPushButton(animated: animated, id: button.id)
            }
        }
        
        addSubview(scrollView)
        
        completion()
    }
    
    private func dismissEverything(completion: @escaping () -> ()) {
        navigationController?.popToRootViewController(animated: false)
        
        if let presentedViewController = navigationController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: completion)
        } else {
            completion()
        }
    }
    
    private func addTapIndicatorButton(id: String) {
        let tapIndicatorButton = TapIndicatorButton()
        tapIndicatorButton.backgroundColor = .blue
        tapIndicatorButton.accessibilityIdentifier = id
        tapIndicatorButtons.append(tapIndicatorButton)
        scrollView.addSubview(tapIndicatorButton)
    }
    
    private func addPushButton(animated: Bool, id: String) {
        addActionButton(id: id) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.navigationController?.pushViewController(
                strongSelf.centeredLineViewController(layout: .vertical),
                animated: animated
            )
        }
    }
    
    private func addPresentButton(animated: Bool, id: String) {
        addActionButton(id: id) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.navigationController?.present(
                strongSelf.centeredLineViewController(layout: .horizontal),
                animated: animated,
                completion: nil
            )
        }
    }
    
    private func centeredLineViewController(layout: CenteredLineButtonView.Layout) -> UIViewController {
        let viewController = UIViewController()
        let view = CenteredLineButtonView(layout: layout)
        view.accessibilityIdentifier = "centeredLineViewControllerButton"
        viewController.view = view
        return viewController
    }
    
    private func addActionButton(id: String, onTap: @escaping () -> ()) {
        let button = ButtonWithClosures()
        
        button.onTap = onTap
        button.setTitle(id, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = id
        button.backgroundColor = .green
        
        scrollView.addSubview(button)
        actionButtons.append(button)
    }
}
