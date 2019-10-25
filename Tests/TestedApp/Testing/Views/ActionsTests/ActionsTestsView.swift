import UIKit
import MixboxFoundation
import MixboxIpc
import MixboxIpcCommon
import TestsIpc

final class ActionsTestsView: UIView, InitializableWithTestingViewControllerSettings {
    let infoLabel = UILabel()
    let overlappingView = UILabel()
    let scrollView = TestStackScrollView()
    let actionTestsViewViewRegistrar = ActionTestsViewViewRegistrar()
    
    var info: ActionsTestsViewActionResult = .uiWasNotTriggered {
        didSet {
            infoLabel.text = info.description
        }
    }
    
    var viewModel: ActionsTestsViewModel = ActionsTestsViewModel(
        showInfo: false,
        viewNames: [],
        alpha: 1,
        isHidden: false,
        overlapping: 0,
        touchesAreBlocked: false
    )
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        addSubview(scrollView)
        addSubview(overlappingView)
        addSubview(infoLabel)
        
        infoLabel.accessibilityIdentifier = "info"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        infoLabel.font = UIFont.systemFont(ofSize: 17)
        
        overlappingView.text = String(repeating: "overlapping view ", count: 500)
        overlappingView.backgroundColor = .red
        overlappingView.numberOfLines = 0
        
        backgroundColor = .white
        
        actionTestsViewViewRegistrar.registerViews()
        
        viewIpc.register(method: GetActionResultIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                completion(.error("self is nil"))
                return
            }
            
            DispatchQueue.main.async {
                completion(strongSelf.info)
            }
        }
        
        viewIpc.register(method: ResetUiIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                completion(IpcThrowingFunctionResult.threw("self is nil"))
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.info = .uiWasNotTriggered
                completion(IpcThrowingFunctionResult.returned(IpcVoid()))
            }
        }
        
        viewIpc.register(method: SetViewsIpcMethod()) { [weak self] viewModel, completion in
            guard let strongSelf = self else {
                completion(ErrorString("ERROR: self is nil"))
                return
            }
            
            DispatchQueue.main.async {
                completion(strongSelf.setViewModel(viewModel: viewModel))
            }
        }
        
        _ = setViewModel(viewModel: viewModel)
    }
    
    private func setViewModel(viewModel: ActionsTestsViewModel) -> ErrorString? {
        self.viewModel = viewModel
        
        scrollView.alpha = viewModel.alpha
        scrollView.isHidden = viewModel.isHidden
        
        if let error = updateViews(viewNames: viewModel.viewNames) {
            return error
        }
        
        infoLabel.isHidden = !viewModel.showInfo
        
        if viewModel.touchesAreBlocked {
            assertionFailure("touchesAreBlocked==true is not implemented")
        }
        
        setNeedsLayout()
        
        return nil
    }
    
    private func updateViews(viewNames: [String]) -> ErrorString? {
        scrollView.removeAllViews()
        
        for viewName in viewNames {
            if let specification = actionTestsViewViewRegistrar.viewSpecifications[viewName] {
                specification.addView(
                    context: ActionTestsViewAddingContext(
                        scrollView: scrollView,
                        id: specification.id,
                        reportResultClosure: { [weak self] result in
                            self?.info = .uiWasTriggered(result)
                        }
                    )
                )
            } else {
                return ErrorString("No known view for name \"\(viewName)\"")
            }
        }
        
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            insets = .zero
        }
        
        scrollView.contentInset = insets
        
        overlappingView.frame = bounds
        overlappingView.frame.size.width *= viewModel.overlapping
        overlappingView.isHidden = viewModel.overlapping <= 0
        
        if viewModel.showInfo {
            infoLabel.layout(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: bounds.mb_top + insets.bottom,
                height: 50
            )
            scrollView.layout(
                left: bounds.mb_left,
                right: bounds.mb_right,
                top: infoLabel.mb_bottom,
                bottom: bounds.mb_bottom
            )
        } else {
            scrollView.frame = bounds
        }
    }
}
