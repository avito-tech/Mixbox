#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxTestability
import MixboxFoundation
import MixboxUiKit
import UIKit

public final class InProcessViewHierarchyProvider: ViewHierarchyProvider {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let keyboardWindowExposer: KeyboardWindowExposer
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        keyboardWindowExposer: KeyboardWindowExposer
    ) {
        self.applicationWindowsProvider = applicationWindowsProvider
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.keyboardWindowExposer = keyboardWindowExposer
    }
    
    public func viewHierarchy() throws -> ViewHierarchy {
        DtoViewHierarchy(
            rootElements: try elements(windows: applicationWindowsProvider.windows)
        )
    }
    
    // MARK: - Private
    
    private func elements(windows: [UIWindow]) throws -> RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        let keyboardWindowExposerResult = try keyboardWindowExposer.exposeKeyboardWindow(
            windows: windows
        )
        
        func originalElements() -> RandomAccessCollectionOf<ViewHierarchyElement, Int> {
            RandomAccessCollectionOf(
                windows.lazy.map { [floatValuesForSr5346Patcher] in
                    TestabilityElementViewHierarchyElement(
                        testabilityElement: $0,
                        floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
                    )
                }
            )
        }
        
        switch keyboardWindowExposerResult {
        case let .exposedKeyboard(exposedKeyboard):
            return RandomAccessCollectionOf(
                try exposedKeyboard.patchedElementHierarchy()
            )
        case .keyboardIsNotVisible:
            return originalElements()
        }
    }
}

#endif
