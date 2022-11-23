#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxUiKit

public final class TextInputFrameworkProviderImpl: TextInputFrameworkProvider {
    private let iosVersionProvider: IosVersionProvider
    private let userInterfaceIdiomProvider: UserInterfaceIdiomProvider
    
    public init(
        iosVersionProvider: IosVersionProvider,
        userInterfaceIdiomProvider: UserInterfaceIdiomProvider
    ) {
        self.iosVersionProvider = iosVersionProvider
        self.userInterfaceIdiomProvider = userInterfaceIdiomProvider
    }
    
    public func withLoadedFramework(
        body: (TextInputFramework) throws -> ()
    ) throws {
        let handle = try openTextInputFramework()
        
        let textInputFramework = TextInputFrameworkImpl(
            handle: handle,
            iosVersionProvider: iosVersionProvider,
            userInterfaceIdiomProvider: userInterfaceIdiomProvider
        )
        
        try body(textInputFramework)
        
        dlclose(handle)
    }
    
    private func openTextInputFramework() throws -> UnsafeMutableRawPointer {
        let controllerPrefBundlePath = "/System/Library/PrivateFrameworks/TextInput.framework/TextInput"
        
        guard let handle = dlopen(controllerPrefBundlePath, RTLD_LAZY) else {
            throw ErrorString("dlopen couldn't open settings bundle at path bundle \(controllerPrefBundlePath)")
        }
        
        return handle
    }
}

#endif
