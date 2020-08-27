import UIKit

public final class UikitPasteboard: Pasteboard {
    private let uiPasteboard: UIPasteboard
    
    public init(uiPasteboard: UIPasteboard) {
        self.uiPasteboard = uiPasteboard
    }
    
    public func setString(_ string: String?) throws {
        uiPasteboard.string = string
    }
    
    public func getString() throws -> String? {
        return uiPasteboard.string
    }
}
