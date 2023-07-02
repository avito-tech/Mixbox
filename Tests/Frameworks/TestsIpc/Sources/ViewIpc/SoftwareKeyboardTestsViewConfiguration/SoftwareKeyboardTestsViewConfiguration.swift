import UIKit

public final class SoftwareKeyboardTestsViewConfiguration: Codable {
    public let returnKeyType: UIReturnKeyType
    public let viewThatCanBeHiddenBelowKeyboard: ViewThatCanBeHiddenBelowKeyboard
    public let keyboardAccessoryView: KeyboardAccessoryView
    
    public init(
        returnKeyType: UIReturnKeyType,
        viewThatCanBeHiddenBelowKeyboard: ViewThatCanBeHiddenBelowKeyboard,
        keyboardAccessoryView: KeyboardAccessoryView
    ) {
        self.returnKeyType = returnKeyType
        self.viewThatCanBeHiddenBelowKeyboard = viewThatCanBeHiddenBelowKeyboard
        self.keyboardAccessoryView = keyboardAccessoryView
    }
    
    public static func `default`() -> SoftwareKeyboardTestsViewConfiguration {
        SoftwareKeyboardTestsViewConfiguration(
            returnKeyType: .default,
            viewThatCanBeHiddenBelowKeyboard: .hidden,
            keyboardAccessoryView: .none
        )
    }
    
    public enum ViewThatCanBeHiddenBelowKeyboard: Codable {
        case hidden
        case visibleWithHeight(CGFloat)
        case visibleWithHeightOfKeyboardIfKeyboardIsVisibleOrDefaultHeight(CGFloat)
    }
    
    public enum KeyboardAccessoryView: Codable {
        case none
        case hideKeyboardButton(id: String, text: String)
    }
}

extension UIReturnKeyType: Codable, CaseIterable, RawRepresentable {
    public static var allCases: [UIReturnKeyType] {
        [
            .`default`,
            .go,
            .google,
            .join,
            .next,
            .route,
            .search,
            .send,
            .yahoo,
            .done,
            .emergencyCall,
            .`continue`
        ]
    }
}
