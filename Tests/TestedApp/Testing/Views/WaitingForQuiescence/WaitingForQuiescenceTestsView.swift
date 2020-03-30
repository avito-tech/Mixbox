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
    private var tapIndicatorButton = ButtonWithClosures()
    private var tapIndicatorButtonOffset: CGFloat = 500
    private let tapIndicatorButtonHeight: CGFloat = 1 // it is harder to tap smaller button
    
    private var scrollView = UIScrollView()
    
    private weak var navigationController: UINavigationController?
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerResetUiMethod(view: self, argumentType: CGFloat.self) { view, tapIndicatorButtonOffset in
            view.resetUi(tapIndicatorButtonOffset: tapIndicatorButtonOffset)
        }
        
        navigationController = testingViewControllerSettings.navigationController
        
        resetUi(tapIndicatorButtonOffset: tapIndicatorButtonOffset)
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
        scrollView.contentSize = frameForContent.size.mb_plusHeight(100000)
        
        tapIndicatorButton.frame = CGRect(
            x: frameForContent.mb_left,
            y: frameForContent.mb_top + tapIndicatorButtonOffset,
            width: frameForContent.width,
            height: tapIndicatorButtonHeight
        )
        
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
    
    private func resetUi(tapIndicatorButtonOffset: CGFloat) {
        subviews.forEach { $0.removeFromSuperview() }
        actionButtons = []
        
        scrollView = UIScrollView()
        scrollView.decelerationRate = .init(rawValue: 0.9999) // less deceleration than `.normal` (0.998)
        
        self.tapIndicatorButtonOffset = tapIndicatorButtonOffset
        backgroundColor = .white
        
        addTapIndicatorButton()
        addPushButton(animated: true)
        addPushButton(animated: false)
        addPresentButton(animated: true)
        addPresentButton(animated: false)
        
        addSubview(scrollView)
    }
    
    private func addTapIndicatorButton() {
        tapIndicatorButton = ButtonWithClosures()
        tapIndicatorButton.backgroundColor = .blue
        tapIndicatorButton.accessibilityIdentifier = "tapIndicatorButton"
        tapIndicatorButton.onTap = { [weak tapIndicatorButton] in
            tapIndicatorButton?.testability_customValues["tapped"] = true
        }
        scrollView.addSubview(tapIndicatorButton)
    }
    
    private func addPushButton(animated: Bool) {
        let id = "pushButton_" + (animated ? "animated" : "notAnimated")
        addActionButton(id: id) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.navigationController?.pushViewController(
                strongSelf.centeredLineViewController(layout: .vertical),
                animated: animated
            )
        }
    }
    
    private func addPresentButton(animated: Bool) {
        let id = "presentButton_" + (animated ? "animated" : "notAnimated")
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
        view.onTap = { [weak view] in
            view?.testability_customValues["tapped"] = true
        }
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
