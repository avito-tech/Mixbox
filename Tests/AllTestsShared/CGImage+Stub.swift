import UIKit
import MixboxFoundation
import MixboxUiTestsFoundation

extension CGImage {
    static func image(
        width: Int,
        height: Int,
        color: CGColor,
        byteOrder: ByteOrder? = nil)
        throws
        -> CGImage
    {
        return try image(
            width: width,
            height: height,
            byteOrder: byteOrder,
            drawingFunction: { context, frame in
                context.setFillColor(color)
                context.fill(frame)
            }
        )
    }
    
    static func image(
        width: Int,
        height: Int,
        byteOrder: ByteOrder? = nil,
        alphaInfo: CGImageAlphaInfo = .premultipliedLast,
        drawingFunction: (CGContext, CGRect) throws -> ())
        throws
        -> CGImage
    {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let bitsPerByte = 8
        let bytesPerComponent = 1
        let components = 4
        let bytesPerRow = components * width * bytesPerComponent
        let data = calloc(1, bytesPerRow * height)
        
        let contextOrNil = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: bitsPerByte * bytesPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: alphaInfo.rawValue | bitmapInfoMask(byteOrder: byteOrder)
        )
        
        guard let context = contextOrNil else {
            throw ErrorString("Failed to create context")
        }
        
        try drawingFunction(context, frame)
        
        guard let image = context.makeImage() else {
            throw ErrorString("Failed to make image")
        }
        
        return image
    }
    
    private static func bitmapInfoMask(byteOrder: ByteOrder?) -> UInt32 {
        switch byteOrder {
        case .bigEndian?:
            return CGBitmapInfo.byteOrder32Big.rawValue
        case .littleEndian?:
            return CGBitmapInfo.byteOrder32Little.rawValue
        case nil:
            return 0
        }
    }
}
