import XCTest
import MixboxBuiltinIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import MixboxIpcCommon

public final class BuiltinIpcLaunchableApplication: LaunchableApplication {
    public var legacyNetworking: LegacyNetworking {
        UnavoidableFailure.fail("LegacyNetworking is not implemented for Builtin Ipc")
    }
    
    private static var everLaunched: Bool = false
    private let applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver
    private var launchedXcuiApplication: XCUIApplication?
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
    }
    
    public func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    {
        let application: XCUIApplication
        
        // Prototype of fast launching
        if !BuiltinIpcLaunchableApplication.everLaunched {
            application = XCUIApplication()
        } else {
            application = XCUIApplication(privateWithPath: nil, bundleID: "mixbox.Tests.TestedApp")
        }
        
        // Initialize client/server pairs
        let handshaker = KnownPortHandshakeWaiter()
        guard let port = handshaker.start() else {
            preconditionFailure("Не удалось стартовать сервер.")
        }
        
        application.launchArguments = arguments
        application.launchEnvironment["MIXBOX_HOST"] = "localhost"
        application.launchEnvironment["MIXBOX_PORT"] = "\(port)"
        application.launchEnvironment["MIXBOX_IPC_STARTER_TYPE"] = IpcStarterType.blackbox.rawValue
        
        for (key, value) in environment {
            application.launchEnvironment[key] = value
        }
        
        // Launch
        application.launch()
        launchedXcuiApplication = application
        BuiltinIpcLaunchableApplication.everLaunched = true
        applicationLifecycleObservable.applicationStateChanged(applicationIsLaunched: true)
        
        // Wait for handshake
        let ipcClient = handshaker.waitForHandshake()
        
        return LaunchedApplicationImpl(
            ipcClient: ipcClient,
            ipcRouter: handshaker.server
        )
    }
    
    public func terminate() {
        launchedXcuiApplication?.terminate()
        applicationLifecycleObservable.applicationStateChanged(applicationIsLaunched: false)
    }
}
