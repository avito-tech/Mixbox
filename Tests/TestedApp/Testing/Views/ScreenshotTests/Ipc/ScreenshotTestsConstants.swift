import UIKit

final class ScreenshotTestsConstants {
    static let viewsCount = 9
    
    static func viewId(index: Int) -> String {
        return "view_\(index)"
    }
    
    static func viewSize(index: Int) -> CGSize {
        let dimension = CGFloat(5 * (index + 1))
        return CGSize(
            width: dimension,
            height: dimension
        )
    }
    
    static func color(index: Int) -> UIColor {
        return UIColor(
            red: 0.9 * CGFloat(index % 2),
            green: 0.9 * CGFloat((index >> 1) % 2),
            blue: 0.9 * CGFloat((index >> 2) % 2),
            alpha: 1
        )
    }
}
