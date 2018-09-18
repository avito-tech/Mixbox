import UIKit

public extension UIImage {
    
    func difference(with other: UIImage) -> UIImage? {
        
        let imageRect = CGRect(
            x: 0,
            y: 0,
            width: max(size.width, other.size.width),
            height: max(size.height, other.size.height)
        )
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        draw(in: imageRect)
        
        context.setAlpha(0.5)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        other.draw(in: imageRect)
        
        context.setBlendMode(.difference)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(imageRect)
        
        context.endTransparencyLayer()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func perPixelEquals(to otherUIImage: UIImage, tolerance: CGFloat = 0) -> Bool {
        guard let reference = cgImage else { return false }
        guard let other = otherUIImage.cgImage else { return false }
        
        let referenceFrame = CGRect(
            x: 0,
            y: 0,
            width: reference.width,
            height: reference.height
        )
        
        let otherFrame = CGRect(
            x: 0,
            y: 0,
            width: other.width,
            height: other.height
        )
      
        if referenceFrame.size != otherFrame.size {
            // Images must be of same size
            return false
        }

        // The images have the equal size, so we could use the smallest amount of bytes because of byte padding
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let bytesPerRow = min(reference.bytesPerRow, other.bytesPerRow)
        let referenceImageSizeBytes = Int(referenceFrame.height) * bytesPerRow
        
        guard let referenceImagePixels = calloc(1, referenceImageSizeBytes)
            else { return false }
        
        guard let otherPixels = calloc(1, referenceImageSizeBytes)
            else { return false }
        
        guard let referenceColorSpace = reference.colorSpace
            else { return false }
        
        guard let otherColorSpace = other.colorSpace
            else { return false }
        
        guard let referenceContext = CGContext(
            data: referenceImagePixels,
            width: Int(referenceFrame.width),
            height: Int(referenceFrame.height),
            bitsPerComponent: reference.bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: referenceColorSpace,
            bitmapInfo: bitmapInfo
            ) else { return false }
        
        guard let otherContext = CGContext(
            data: otherPixels,
            width: Int(otherFrame.width),
            height: Int(otherFrame.height),
            bitsPerComponent: other.bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: otherColorSpace,
            bitmapInfo: bitmapInfo
            ) else { return false }
        
        referenceContext.draw(reference, in: referenceFrame)
        otherContext.draw(other, in: otherFrame)
        
        // Do a fast compare if we can
        guard tolerance > 0 else {
            return (memcmp(referenceImagePixels, otherPixels, referenceImageSizeBytes) == 0)
        }
        
        // Go through each pixel in turn and see if it is different
        let pixelCount = referenceFrame.width * otherFrame.height
        
        var differentPixelsCount = 0
        
        for pixel in (0...Int(pixelCount)) {
            
            let referencePixel = referenceImagePixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            let otherPixel = otherPixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            
            // If this pixel is different, increment the pixel diff count and see
            // if we have hit our limit.
            if referencePixel != otherPixel {
                differentPixelsCount += 1
                
                let difference = CGFloat(differentPixelsCount) / pixelCount
                
                if difference > tolerance {
                    return false
                }
            }
            
        }
        
        return true
    }
}
