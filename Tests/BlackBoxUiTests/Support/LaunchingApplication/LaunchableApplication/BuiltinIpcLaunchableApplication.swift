import XCTest
import MixboxBuiltinIpc
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxXcuiDriver

public final class BuiltinIpcLaunchableApplication: LaunchableApplication {
    public var networking: Networking {
        UnavoidableFailure.fail("Networking is not implemented for Builtin Ipc")
    }
    
    private static var everLaunched: Bool = false
    private let applicationDidLaunchObserver: ApplicationDidLaunchObserver
    
    public init(applicationDidLaunchObserver: ApplicationDidLaunchObserver) {
        self.applicationDidLaunchObserver = applicationDidLaunchObserver
    }
    
    public func launch(environment: [String: String]) -> LaunchedApplication {
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
        
        application.launchEnvironment["MIXBOX_HOST"] = "localhost"
        application.launchEnvironment["MIXBOX_PORT"] = "\(port)"
        application.launchEnvironment["MIXBOX_USE_BUILTIN_IPC"] = "true"
        
        for (key, value) in environment {
            application.launchEnvironment[key] = value
        }
        
        // Launch
        application.launch()
        BuiltinIpcLaunchableApplication.everLaunched = true
        applicationDidLaunchObserver.applicationDidLaunch()
        
        // Wait for handshake
        let ipcClient = handshaker.waitForHandshake()
        
        return LaunchedApplicationImpl(
            ipcClient: handshaker.waitForHandshake(),
            ipcRouter: handshaker.server
        )
    }
}
