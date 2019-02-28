import MixboxIpcCommon
import MixboxIpcClients
import MixboxIpc
import MixboxUiKit
import MixboxUiTestsFoundation
import XCTest

extension ElementSnapshot {
    
    public func hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() -> Bool {
        if hasKeyboardFocus {
            return true
        }
        for child in children {
            if child.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() {
                return true
            }
        }
        return false
    }
    
}
