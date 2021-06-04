import UIKit
import MixboxFoundation

extension ImageHashCalculatorSnapshotsComparator {
    // Explanation of why this is needed and how it works.
    //
    // # Why
    //
    // Situation:
    // - We need to match a button with specific icon in a navigation bar.
    // - Navigation bar can have any background color.
    // - We have a button with transparent background as a reference.
    //
    // If we just take snapshot of an actual navigation button it will have some background.
    // And it will not match our reference image.
    //
    // Solution: ignore transparency.
    //
    // # How
    //
    // Place expected image on a generated background that looks like background of actual image.
    // Previous method (described below) didn't work and the whole enterprise seems to be futile...
    // We can't use things like image hashing for such cases.
    //
    // NOTE: This was previous "How" and it didn't work:
    //
    // > To ignore transparent pixels we just cut transparent pixels from both of images.
    // > It will be replaced with opaque color later. So the transparent region will
    // > have same color in both of pictures. Note that we don't make images opaque here,
    // > because we rely on image hashing implementation that it will treat images as opaque.
    // > This is not very secure (implementation can be changed), but we have tests for that,
    // > and also we save a bit of time by not doing unneccessary work.
    //
    // This is because intersection of small transparent icons ("outline"-like) was very
    // small and icons looked like each other. It ignored important features of objects.
    //
    final class ImagesForHashingProvider {
        private let shouldIgnoreTransparency: Bool
        
        init(shouldIgnoreTransparency: Bool) {
            self.shouldIgnoreTransparency = shouldIgnoreTransparency
        }
        
        func imagesForHashing(
            actualImage: UIImage,
            expectedImage: UIImage)
            throws
            -> ImagesForHashing
        {
            if shouldIgnoreTransparency {
                let actualImage = try toOpaque(
                    image: actualImage,
                    backgroundColor: .gray
                )
                
                return ImagesForHashing(
                    actualImage: actualImage,
                    expectedImage: try blend(
                        background: actualImage,
                        foreground: expectedImage
                    )
                )
            } else {
                return ImagesForHashing(
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
            }
        }
        
        private func toOpaque(
            image: UIImage,
            backgroundColor: UIColor)
            throws
            -> UIImage
        {
            return try self.uiImage(
                size: image.size,
                opaque: false,
                scale: image.scale,
                body: { (context, frame) in
                    context.setFillColor(backgroundColor.cgColor)
                    context.fill(frame)
                    
                    image.draw(
                        in: frame,
                        blendMode: .normal,
                        alpha: 1
                    )
                }
            )
        }
        
        private func blend(
            background: UIImage,
            foreground: UIImage)
            throws
            -> UIImage
        {
            return try self.uiImage(
                size: foreground.size,
                opaque: false,
                scale: foreground.scale,
                body: { (_, frame) in
                    background.draw(
                        in: frame,
                        blendMode: .copy,
                        alpha: 1
                    )
                    
                    foreground.draw(
                        in: frame,
                        blendMode: .normal,
                        alpha: 1
                    )
                }
            )
        }
        
        private func uiImage(
            size: CGSize,
            opaque: Bool,
            scale: CGFloat,
            body: (CGContext, CGRect) throws -> ())
            throws
            -> UIImage
        {
            return try image(
                size: size,
                opaque: opaque,
                scale: scale,
                body: { context, rect in
                    try body(context, rect)
                    
                    return UIGraphicsGetImageFromCurrentImageContext()
                }
            )
        }
        
        private func image<T>(
            size: CGSize,
            opaque: Bool,
            scale: CGFloat,
            body: (CGContext, CGRect) throws -> T?)
            throws
            -> T
        {
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                throw ErrorString(
                    """
                    Failed to create context with options:
                    {
                        size: \(size)
                        opaque: \(opaque)
                        scale: \(scale)
                    }
                    """
                )
            }
            
            defer {
                UIGraphicsEndImageContext()
            }
            
            let frame = CGRect(origin: .zero, size: size)
            
            return try body(context, frame).unwrapOrThrow(
                message: "Failed to create modified image for calculating hash"
            )
        }
    }
}
