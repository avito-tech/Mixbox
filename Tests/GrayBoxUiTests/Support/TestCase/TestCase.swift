import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxIpc
import MixboxFoundation
import MixboxGray
@testable import TestedApp

class TestCase: BaseUiTestCase, ScreenOpener {
    override func setUp() {
        // TODO: Move to DI (when Dip will be used for DI).
        
        let appDelegate = self.appDelegate
        
        testCaseUtils.baseUiTestCaseUtils.lazilyInitializedIpcClient.ipcClient = appDelegate.ipcClient
        testCaseUtils.ipcRouter = appDelegate.ipcRouter
        
        super.setUp()
    }
    
    override func tearDown() {
        if !reuseState {
            UIApplication.shared.keyWindow?.rootViewController = UIViewController()
        }
        
        testCaseUtils.legacyNetworking.stubbing.removeAllStubs()
        
        super.tearDown()
    }
    
    func ensureIpcIsInitiated() {
        // IPC is always initiated in GrayBox tests (see setUp)
    }
    
    func openScreen(name: String, additionalEnvironment: [String: String]) {
        let viewController = TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                name: name,
                mixboxInAppServices: appDelegate.mixboxInAppServices
            )
        )
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    // MARK: - Private
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UnavoidableFailure.fail("UIApplication.shared.delegate is not AppDelegate")
        }
        
        return appDelegate
    }
}
