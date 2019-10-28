import UIKit

public final class ScreenshotTestsConstants {
    public static let viewsCount = 9
    
    public static func viewId(index: Int) -> String {
        return "view_\(index)"
    }
    
    public static func viewSize(index: Int) -> CGSize {
        let dimension = CGFloat(5 * (index + 1))
        return CGSize(
            width: dimension,
            height: dimension
        )
    }
    
    public static func color(index: Int) -> UIColor {
        return UIColor(
            red: roundedColorComponent(0.9 * CGFloat(index % 2)),
            green: roundedColorComponent(0.9 * CGFloat((index >> 1) % 2)),
            blue: roundedColorComponent(0.9 * CGFloat((index >> 2) % 2)),
            alpha: 1
        )
    }
    
    private static func roundedColorComponent(_ component: CGFloat) -> CGFloat {
        let colorsPerComponent: CGFloat = 256
        return (component * colorsPerComponent).rounded() / colorsPerComponent
    }
}
