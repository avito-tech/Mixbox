import UIKit

public final class SoftwareKeyboardTestsViewConfiguration: Codable {
    public let returnKeyType: UIReturnKeyType
    public let viewThatCanBeHiddenBelowKeyboard: ViewThatCanBeHiddenBelowKeyboard
    
    public init(
        returnKeyType: UIReturnKeyType,
        viewThatCanBeHiddenBelowKeyboard: ViewThatCanBeHiddenBelowKeyboard
    ) {
        self.returnKeyType = returnKeyType
        self.viewThatCanBeHiddenBelowKeyboard = viewThatCanBeHiddenBelowKeyboard
    }
    
    public enum ViewThatCanBeHiddenBelowKeyboard: Codable {
        case hidden
        case visibleWithHeight(CGFloat)
        case visibleWithHeightOfKeyboardIfKeyboardIsVisibleOrDefaultHeight(CGFloat)
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
