#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxUiKit
#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

public final class TextInputFrameworkImpl: TextInputFramework {
    private var handle: UnsafeMutableRawPointer?
    private let iosVersionProvider: IosVersionProvider
    private let userInterfaceIdiomProvider: UserInterfaceIdiomProvider
    
    public init(
        handle: UnsafeMutableRawPointer,
        iosVersionProvider: IosVersionProvider,
        userInterfaceIdiomProvider: UserInterfaceIdiomProvider
    ) {
        self.handle = handle
        self.iosVersionProvider = iosVersionProvider
        self.userInterfaceIdiomProvider = userInterfaceIdiomProvider
    }
    
    public func sharedTextInputPreferencesController() throws -> TextInputPreferencesController {
        return TextInputPreferencesControllerImpl(
            tiPreferencesController: TIPreferencesControllerObjCWrapper.shared(),
            iosVersionProvider: iosVersionProvider,
            userInterfaceIdiomProvider: userInterfaceIdiomProvider
        )
    }
}

#endif
