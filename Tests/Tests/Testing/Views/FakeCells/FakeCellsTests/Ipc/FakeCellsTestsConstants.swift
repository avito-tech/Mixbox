import UIKit

// It is shared between a view and a test that uses the view.
final class FakeCellsTestsConstants {
    static let setsCount = 4 // tested on iPhone 6 Plus
    static let cellsInSetCount = 4
    static let customSubviewsCount = 2  // one at the top, one at the bottom
    
    static var lastSetId = setsCount - 1
    static let itemHeight: CGFloat = 80
    
    static func accessibilityId(
        _ caseId: String,
        _ viewType: String, // "cell" / "view"
        _ setId: Int,
        _ suffix: String? = nil,
        _ generation: Int = 0)
        -> String
    {
        return "\(setId)-\(caseId)-\(viewType)\(suffix.map { "-" + $0 } ?? "")-gen\(generation)"
    }
}
