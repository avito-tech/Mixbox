import UIKit

public final class CanTapKeyboardTestsViewConfiguration: Codable {
    public let returnKeyType: UIReturnKeyType
    
    public init(returnKeyType: UIReturnKeyType) {
        self.returnKeyType = returnKeyType
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
