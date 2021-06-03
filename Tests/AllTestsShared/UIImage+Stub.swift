import UIKit
import MixboxUiTestsFoundation

extension UIImage {
    static func image(
        width: Int,
        height: Int,
        byteOrder: ByteOrder? = nil,
        scale: CGFloat = 0,
        orientation: UIImage.Orientation = .down,
        drawingFunction: (CGContext, CGRect) throws -> ())
        throws
        -> UIImage
    {
        return UIImage(
            cgImage: try CGImage.image(
                width: width,
                height: height,
                byteOrder: byteOrder,
                drawingFunction: drawingFunction
            ),
            scale: scale,
            orientation: orientation
        )
    }
    
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
        orientation: UIImage.Orientation = .down,
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
            orientation: orientation
        )
    }
}
