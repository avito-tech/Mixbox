import MixboxBlack
import XCTest
import TestsIpc
import MixboxUiTestsFoundation
import SBTUITestTunnel

final class LaunchingAppTests: TestCase {
    private let applicationLifecycleObservable = ApplicationLifecycleObservableImpl()
    
    override var reuseState: Bool {
        return false
    }
    
    func test_SbtuiLaunchableApplication_canBeLaunchedithArgumentsAndEnvironmentAndTerminated() {
        checkAppIsCanBeLaunchedWithArgumentsAndEnvironmentAndTerminated(
            launchableApplication: sbtuiLaunchableApplication()
        )
    }
    
    func test_BuiltinLaunchableApplication_canBeLaunchedithArgumentsAndEnvironmentAndTerminated() {
        checkAppIsCanBeLaunchedWithArgumentsAndEnvironmentAndTerminated(
            launchableApplication: sbtuiLaunchableApplication()
        )
    }
    
    private func sbtuiLaunchableApplication() -> LaunchableApplication {
        let launchableApplication = SbtuiLaunchableApplication(
            tunneledApplication: SBTUITunneledApplication(),
            applicationLifecycleObservable: applicationLifecycleObservable,
            testFailureRecorder: dependencies.resolve(),
            bundleResourcePathProvider: bundleResourcePathProviderForTestsTarget,
            waiter: waiter,
            networkReplayingObserver: DummyNetworkReplayingObserver()
        )
        
        return launchableApplication
    }
    
    private func builtinIpcLaunchableApplication() -> LaunchableApplication {
        let launchableApplication = BuiltinIpcLaunchableApplication(
            applicationLifecycleObservable: applicationLifecycleObservable
        )
        
        return launchableApplication
    }
    
    private func checkAppIsCanBeLaunchedWithArgumentsAndEnvironmentAndTerminated(
        launchableApplication: LaunchableApplication)
    {
        XCTAssertEqual(applicationLifecycleObservable.applicationIsLaunched, false)
        
        let arguments = ["1", "2"]
        let environment = ["MB_TESTS_screenName": "this is really a required argument"]
        
        let launchedApplication = launchableApplication.launch(
            arguments: arguments,
            environment: environment
        )
        
        guard let ipcClient = launchedApplication.ipcClient else {
            XCTFail("Couldn't start IPC")
            return
        }
        
        XCTAssertEqual(applicationLifecycleObservable.applicationIsLaunched, true)
        
        let ipcProcessInfo: IpcProcessInfo = ipcClient.callOrFail(method: ProcessInfoIpcMethod())
        
        for expectedValue in arguments {
            XCTAssert(
                ipcProcessInfo.arguments.contains(expectedValue),
                "Arguments should contain '\(expectedValue)', actual values: [\(ipcProcessInfo.arguments)]"
            )
        }
        
        for (key, expectedValue) in environment {
            let actualValue = ipcProcessInfo.environment[key]
            
            XCTAssertEqual(
                actualValue,
                expectedValue,
                "Environment variable '\(key)' is expected to equal '\(expectedValue)', actual value: \(actualValue ?? "nil")"
            )
        }
        
        launchableApplication.terminate()
        
        XCTAssertEqual(applicationLifecycleObservable.applicationIsLaunched, false)
        
        // Simple check that app is launched
        switch ipcClient.call(method: ProcessInfoIpcMethod()) {
        case .data:
            XCTFail("It seems that app is still lanuched, which is unexpected")
        case .error:
            break
        }
    }
}
