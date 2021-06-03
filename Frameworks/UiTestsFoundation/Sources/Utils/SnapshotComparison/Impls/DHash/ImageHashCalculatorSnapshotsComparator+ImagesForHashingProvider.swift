import UIKit
import MixboxFoundation

extension ImageHashCalculatorSnapshotsComparator {
    // To reduce amout of arguments
    private class ImageVariations {
        init(uiImage: UIImage, cgImage: CGImage) {
            self.uiImage = uiImage
            self.cgImage = cgImage
        }
        
        let uiImage: UIImage
        let cgImage: CGImage
    }
    
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
    // To ignore transparent pixels we just cut transparent pixels from both of images.
    // It will be replaced with opaque color later. So the transparent region will
    // have same color in both of pictures. Note that we don't make images opaque here,
    // because we rely on image hashing implementation that it will treat images as opaque.
    // This is not very secure (implementation can be changed), but we have tests for that,
    // and also we save a bit of time by not doing unneccessary work.
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
                let actualImage = try imageVariations(
                    uiImage: actualImage,
                    imageDescrption: "actual image"
                )
                
                let expectedImage = try imageVariations(
                    uiImage: expectedImage,
                    imageDescrption: "expected image"
                )
                
                return ImagesForHashing(
                    actualImage: try intersection(
                        image: actualImage,
                        mask: expectedImage
                    ),
                    expectedImage: try intersection(
                        image: expectedImage,
                        mask: actualImage
                    )
                )
            } else {
                return ImagesForHashing(
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
            }
        }
        
        private func intersection(
            image: ImageVariations,
            mask: ImageVariations)
            throws
            -> UIImage
        {
            // There are many ways thar UIImage can be rendered:
            // https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html#//apple_ref/doc/uid/TP40010156-CH14-SW4
            // It can be flipped, offset, etc, depending on settings. All this logic exists
            // in UIImage method `-(void)drawInRect:(struct CGRect)arg2 blendMode:(int)arg3 alpha:(double)arg4`.
            // Disassembled code is very huge so there is no real justification of reimplementing that logic.
            // We can afford an inefficient algorithm to not do that (inefficient, because we create
            // an auxiliary mask image, for example, just extra work).
            //
            // If we don't account for this, images will be flipped seemingly randomly (from a point of view
            // of a developer who can't care less about internal implementation of those things).
            return try self.uiImage(
                size: image.uiImage.size,
                opaque: false,
                scale: image.uiImage.scale,
                body: { (_, frame) in
                    image.uiImage.draw(
                        in: frame,
                        blendMode: .copy,
                        alpha: 1
                    )
                    
                    mask.uiImage.draw(
                        in: frame,
                        blendMode: .destinationIn, // TODO: Test this. It was `.sourceIn`, it was wrong and test didn't find it.
                        alpha: 1
                    )
                }
            )
        }
        
        private func imageVariations(
            uiImage: UIImage,
            imageDescrption: String)
            throws
            -> ImageVariations
        {
            return ImageVariations(
                uiImage: uiImage,
                cgImage: try cgImage(
                    uiImage: uiImage,
                    imageDescrption: imageDescrption
                )
            )
        }
        
        private func cgImage(
            uiImage: UIImage,
            imageDescrption: String)
            throws
            -> CGImage
        {
            return try uiImage.cgImage.unwrapOrThrow(
                message: "Failed to get `cgImage` from \(imageDescrption)"
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
        
        private func cgImage(
            size: CGSize,
            opaque: Bool,
            scale: CGFloat,
            body: (CGContext, CGRect) throws -> ())
            throws
            -> CGImage
        {
            return try image(
                size: size,
                opaque: opaque,
                scale: scale,
                body: { context, rect in
                    try body(context, rect)
                    
                    return context.makeImage()
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
