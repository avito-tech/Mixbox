import UIKit
import MixboxUiKit
import TestsIpc

// A prototype of a view that can be fully configured in tests (including BlackBox tests).
// I always wanted it, because most of view views in tests are simple and already configurable via IPC,
// but the hierarchy is hardcoded and there is a lot of boilerplate.
//
// This class will be evolving from very simple tool with silly architecture to more generic and customizable.
//
// Note that behaviour can be transferred via IPC too. There is already an implemented feature called
// "BidirectionalIpc", however, it's not used in production, because we use SBTUITestTunnel and
// BidirectionalIpc doesn't use it and it doesn't support recording network requests yet. But in future it may.
//
final class IpcTestingView: UIView, TestingView {
    private struct ViewAndConfiguration {
        let view: UIView
        let ipcView: IpcView
    }
    
    private var viewsAndConfigurations = [ViewAndConfiguration]()
    private var configuration: IpcTestingViewConfiguration?
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerAsyncResetUiMethod(view: self, argumentType: IpcTestingViewConfiguration.self) { view, configuration, completion in
            view.resetUi(configuration: configuration, completion: completion)
        }
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for viewAndConfiguration in viewsAndConfigurations {
            viewAndConfiguration.view.frame = viewAndConfiguration.ipcView.frame
        }
    }
    
    private func resetUi(
        configuration: IpcTestingViewConfiguration,
        completion: @escaping () -> ())
    {
        viewsAndConfigurations.forEach { viewAndConfiguration in
            viewAndConfiguration.view.removeFromSuperview()
        }
        
        viewsAndConfigurations.removeAll(keepingCapacity: true)
    
        for ipcView in configuration.views {
            let viewAndConfiguration = self.viewAndConfiguration(ipcView: ipcView)
            
            viewsAndConfigurations.append(viewAndConfiguration)
            
            addSubview(viewAndConfiguration.view)
        }
        
        completion()
    }
    
    private func viewAndConfiguration(ipcView: IpcView) -> ViewAndConfiguration {
        return ViewAndConfiguration(
            view: view(
                ipcView: ipcView
            ),
            ipcView: ipcView
        )
    }
    private func view(ipcView: IpcView) -> UIView {
        let view = UIView()
        
        view.accessibilityIdentifier = ipcView.accessibilityIdentifier
        view.backgroundColor = ipcView.backgroundColor?.uiColor
        view.alpha = ipcView.alpha
        view.isHidden = ipcView.isHidden
        
        return view
    }
}
