import UIKit
import MixboxUiTestsFoundation

extension UIImage {
    static func image(
        color: UIColor,
        size: CGSize)
        throws
        -> UIImage
    {
        let scale = UIScreen.main.scale
        
        return try image(
            width: Int(size.width * scale),
            height: Int(size.height * scale),
            color: color.cgColor,
            scale: scale
        )
    }
    
    static func image(
        width: Int,
        height: Int,
        color: CGColor,
        byteOrder: ByteOrder? = nil,
        scale: CGFloat = 0)
        throws
        -> UIImage
    {
        return UIImage(
            cgImage: try CGImage.image(
                width: width,
                height: height,
                color: color,
                byteOrder: byteOrder
            ),
            scale: scale,
            orientation: .down
        )
    }
}
