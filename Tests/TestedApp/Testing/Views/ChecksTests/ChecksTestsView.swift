import UIKit
import MixboxIpc
import MixboxFoundation
import TestsIpc

final class ChecksTestsView: TestStackScrollView, InitializableWithTestingViewControllerSettings {
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        // Set up nothing by default.
        addViewHandler = { _, _, _, _ in }
        
        setUpViews()
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        viewIpc.register(method: ConfigureChecksTestsViewIpcMethod()) { [weak self] config, completion in
            self?.handleConfigureChecksTestsViewIpcMethod(
                config: config,
                completion: {
                    completion(IpcVoid())
                }
            )
        }
    }
    
    private func handleConfigureChecksTestsViewIpcMethod(config: ChecksTestsViewConfiguration, completion: @escaping () -> ()) {
        // If reload in "synchronous", without delay, completion is called after reload.
        // Otherwise completion is called before first action.
        // If there is no actions, completion is also called.
        let callCompletionOnce = ThreadSafeOnceToken<Void>()
        
        func uiTestsCanStartCheckingUi() {
            _ = callCompletionOnce.executeOnce {
                completion()
            }
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            for action in config.actions {
                if action.delay > 0 {
                    uiTestsCanStartCheckingUi()
                }
                
                Thread.sleep(forTimeInterval: action.delay)
                
                DispatchQueue.main.async {
                    self?.addViewHandler = { defaultConfig, setId, userConfig, addSubview in
                        if action.reloadSettings.defaultConfig {
                            defaultConfig()
                        }
                        if action.reloadSettings.setId {
                            setId()
                        }
                        if action.reloadSettings.userConfig {
                            userConfig()
                        }
                        if action.reloadSettings.addSubview {
                            addSubview()
                        }
                    }
                    
                    self?.setUpViews()
                    
                    uiTestsCanStartCheckingUi()
                }
            }
            DispatchQueue.main.async {
                uiTestsCanStartCheckingUi()
            }
        }
    }
    
    private func setUpViews() {
        removeAllViews()
        
        addLabel(id: "checkText0") {
            $0.text = "Полное соответствие"
        }
        
        addLabel(id: "checkText1") {
            $0.text = "Частичное соответствие"
        }
        
        addLabel(id: "hasValue0") {
            $0.accessibilityValue = "Accessibility Value"
        }
        
        addLabel(id: "hasLabel0") {
            $0.accessibilityLabel = "Accessibility Label"
        }
        
        addLabel(id: "hasLabel1") {
            $0.text = "Text That Is Expected In Accessibility Label"
        }
        
        addButton(id: "hasLabel2") {
            $0.accessibilityLabel = "Accessibility Label"
        }
        
        addLabel(id: "isNotDisplayed0") {
            $0.isHidden = true
        }
        addLabel(id: "isNotDisplayed1") {
            $0.alpha = 0
        }
        
        addLabel(id: "isDisplayed0") { _ in
            // everything is default
        }
        
        addButton(id: "isEnabled0") {
            $0.isEnabled = true
        }
        
        addButton(id: "isDisabled0") {
            $0.isEnabled = false
        }
        
        add(view: ExpandingView(), id: "expandingView", userConfig: {}, defaultConfig: {})
        
        addLabel(id: "duplicated_but_one_is_hidden") { label in
            label.isHidden = true
            label.text = "I am hidden"
        }
        
        addLabel(id: "duplicated_but_one_is_hidden") { label in
            label.text = "I am visible"
        }
        
        addLabel(id: "duplicated_and_both_are_visible") { label in
            label.text = "I am visible"
        }
        
        addLabel(id: "duplicated_and_both_are_visible") { label in
            label.text = "I am visible"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
