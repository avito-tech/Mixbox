import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
}
