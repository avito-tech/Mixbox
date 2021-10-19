#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class KeyboardPrivateApi {
    private let uiKeyboardImpl: UIKeyboardImpl
    
    public init(uiKeyboardImpl: UIKeyboardImpl) {
        self.uiKeyboardImpl = uiKeyboardImpl
    }
    
    public static func sharedInstance() throws -> KeyboardPrivateApi {
        guard let uiKeyboardImpl = UIKeyboardImpl.sharedInstance() else {
            throw ErrorString("UIKeyboardImpl.sharedInstance() is nil")
        }
        
        return KeyboardPrivateApi(
            uiKeyboardImpl: uiKeyboardImpl
        )
    }
    
    public func set(shift: Bool, autoshift: Bool) {
        uiKeyboardImpl.setShift(false, autoshift: false)
    }
    
    public func addInputString(_ inputString: String) {
        uiKeyboardImpl.addInputString(inputString)
    }
    
    public func deleteBackward() {
        uiKeyboardImpl.deleteBackward()
    }
    
    public func set(automaticMinimizationEnabled: Bool) {
        uiKeyboardImpl.setAutomaticMinimizationEnabled(automaticMinimizationEnabled)
    }
}

#endif
