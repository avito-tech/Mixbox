import MixboxIpc
import TestsIpc
import MixboxInAppServices

final class SetScreenIpcMethodHandler: IpcMethodHandler {
    typealias Method = SetScreenIpcMethod
    
    let method = Method()
    
    private weak var mixboxInAppServices: MixboxInAppServices?
    private let rootViewControllerManager: RootViewControllerManager
    
    init(
        mixboxInAppServices: MixboxInAppServices?,
        rootViewControllerManager: RootViewControllerManager)
    {
        self.mixboxInAppServices = mixboxInAppServices
        self.rootViewControllerManager = rootViewControllerManager
    }
    
    func handle(
        arguments: Method.Arguments,
        completion: @escaping (Method.ReturnValue) -> ())
    {
        DispatchQueue.main.async {
            self.setScreen(arguments)
            
            completion(IpcVoid())
        }
    }
    
    private func setScreen(_ screen: SetScreenIpcMethod.Screen?) {
        rootViewControllerManager.setRootViewController(
            screen.map { rootViewController(screen: $0) }
        )
    }
    
    private func rootViewController(screen: SetScreenIpcMethod.Screen) -> UIViewController {
        let testingViewController = self.testingViewController(viewType: screen.viewType)
        
        return UINavigationController(rootViewController: testingViewController)
    }
    
    private func testingViewController(viewType: String) -> UIViewController {
        return TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                viewType: viewType,
                mixboxInAppServices: mixboxInAppServices
            )
        )
    }
}
