#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class ScreenInContextDrawerWindowPatcherImpl: ScreenInContextDrawerWindowPatcher {
    private let keyboardWindowExposer: KeyboardWindowExposer
    
    public init(
        keyboardWindowExposer: KeyboardWindowExposer
    ) {
        self.keyboardWindowExposer = keyboardWindowExposer
    }
    
    public func patchWindowsForDrawing(windows: [UIWindow]) throws -> [UIView] {
        switch try keyboardWindowExposer.exposeKeyboardWindow(windows: windows) {
        case let .exposedKeyboard(exposedKeyboard):
            switch try exposedKeyboard.keyboardDrawingMode() {
            case .drawOriginalWindows:
                return windows
            case let .drawPatchedWindows(exposedKeyboardWindows):
                return exposedKeyboardWindows.patchedWindows
            }
        case .keyboardIsNotVisible:
            return windows
        }
    }
}

#endif
