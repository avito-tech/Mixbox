#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

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
