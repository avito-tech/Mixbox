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
    override func tearDown() {
        if !reuseState {
            UIApplication.shared.keyWindow?.rootViewController = UIViewController()
        }
        
        super.tearDown()
    }
    
    func openScreen(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UnavoidableFailure.fail("UIApplication.shared.delegate is not AppDelegate")
        }
        
        testCaseUtils.baseUiTestCaseUtils.lazilyInitializedIpcClient.ipcClient = appDelegate.ipcClient
        
        let viewController = TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                name: name,
                mixboxInAppServices: appDelegate.mixboxInAppServices
            )
        )
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}
