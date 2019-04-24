import MixboxInAppServices
import MixboxIpc
import MixboxFoundation
import MixboxTestsFoundation

public final class GrayBoxInAppServicesStarter {
    // We can not control test execution (enter test methods), so we use singleton here.
    public static let instance = GrayBoxInAppServicesStarter()
    
    private let grayBoxIpcStarter = GrayBoxIpcStarter()
    private var startOnceToken = ThreadUnsafeOnceToken()
    private let mixboxInAppServices: MixboxInAppServices
    
    private init() {
        mixboxInAppServices = MixboxInAppServices(
            ipcStarter: grayBoxIpcStarter,
            shouldAddAssertionForCallingIsHiddenOnFakeCell: true
        )
    }
    
    public func startOnce(setUp: (MixboxInAppServices) -> ()) -> StartedGrayBoxInAppServices {
        do {
            try startOnceToken.executeOnce {
                try setUpAccessibilityForSimulator()
                setUp(mixboxInAppServices)
                mixboxInAppServices.start()
            }
        } catch let error {
            UnavoidableFailure.fail("Couldn't start MixboxInAppServices: \(error)")
        }
        
        return StartedGrayBoxInAppServices(
            ipcClient: grayBoxIpcStarter.sameProcessIpcClientServer,
            ipcRouter: grayBoxIpcStarter.sameProcessIpcClientServer,
            mixboxInAppServices: mixboxInAppServices
        )
    }
    
    private func setUpAccessibilityForSimulator() throws {
        if let error = AccessibilityOnSimulatorInitializer().setupAccessibilityOrReturnError() {
            throw ErrorString(error)
        }
    }
}
