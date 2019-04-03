import UIKit
import MixboxFoundation
import MixboxIpc

final class ActionsTestsView: UIView, InitializableWithTestingViewControllerSettings {
    let infoLabel = UILabel()
    let scrollView = TestStackScrollView()
    let actionTestsViewViewRegistrar = ActionTestsViewViewRegistrar()
    
    var info: String? {
        didSet {
            infoLabel.text = info
        }
    }
    
    var viewModel: ActionsTestsViewModel = ActionsTestsViewModel(showInfo: false, viewNames: [])
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        addSubview(scrollView)
        
        accessibilityIdentifier = "ActionsTestsView"
        
        infoLabel.accessibilityIdentifier = "info"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        infoLabel.font = UIFont.systemFont(ofSize: 17)
        
        backgroundColor = .white
        
        actionTestsViewViewRegistrar.registerViews()
        
        viewIpc.register(method: GetActionResultIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                completion("ERROR: self is nil")
                return
            }
            
            DispatchQueue.main.async {
                completion(strongSelf.info)
            }
        }
        
        viewIpc.register(method: ResetActionResultIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                completion(ErrorString("ERROR: self is nil"))
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.info = nil
                completion(nil)
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
        
        // This was wrong:
        //
        // > if viewModel.viewNames != oldValue.viewNames {
        // >    let error = updateViews(viewNames: viewModel.viewNames)
        //
        // Because we want to reset views. Because we want to reset texts in inputs for example.
            
        if let error = updateViews(viewNames: viewModel.viewNames) {
            return error
        }
        
        updateShowInfo(showInfo: viewModel.showInfo)
        
        setNeedsLayout()
        
        return nil
    }
    
    private func updateShowInfo(showInfo: Bool) {
        infoLabel.removeFromSuperview()
        
        if viewModel.showInfo {
            addSubview(infoLabel)
        }
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
                            self?.info = result
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
