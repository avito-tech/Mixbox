import MixboxFoundation
import UIKit

// NOTE: Swift.Result is used instead of Swift exceptions, because exceptions cause various
// EXC_BAD_ACCESS errors (in random places) due to some kind of bug in memory management in Swift.
//
// TODO: Split.
// swiftlint:disable:next type_body_length
public final class PerPixelSnapshotsComparator: SnapshotsComparator {
    private let tolerance: CGFloat
    private let forceUsingNonDiscretePercentageOfMatching: Bool
    
    private class ComparisonError: Error {
        let message: String
        let percentageOfMatching: Double
        
        init(message: String, percentageOfMatching: Double = 0) {
            self.message = message
            self.percentageOfMatching = percentageOfMatching
        }
    }
    
    /// `tolerance`:
    ///
    ///     How many pixels can be different. Use 0 for optimal performance.
    ///     Range of values: 0...1.
    ///
    /// `forceUsingNonDiscretePercentageOfMatching`:
    ///
    /// if `true`, resulting `percentageOfMatching` will be any value in range 0...1, not just discrete 0 or 1.
    /// This negatively affects performance.
    /// Note that if tolerance is set to a non-zero value, same non-optimal code will be executed and `percentageOfMatching`
    /// will be also non-discrete.
    public init(
        tolerance: CGFloat,
        forceUsingNonDiscretePercentageOfMatching: Bool)
    {
        self.tolerance = tolerance
        self.forceUsingNonDiscretePercentageOfMatching = forceUsingNonDiscretePercentageOfMatching
    }
    
    public func compare(
        actualImage: UIImage,
        expectedImage: UIImage)
        -> SnapshotsComparisonResult
    {
        let result = assertPixelsAreEqual(lhsImage: actualImage, rhsImage: expectedImage)
        
        switch result {
        case .success:
            return .similar
        case .failure(let error):
            return .different(
                LazySnapshotsDifferenceDescription(
                    percentageOfMatching: error.percentageOfMatching,
                    messageFactory: { "Failed to compare images: \(error.message)" },
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
            )
        }
    }
    
    private final class ContextWithImage {
        let cgImage: CGImage
        let frame: CGRect
        
        init(
            cgImage: CGImage,
            frame: CGRect)
        {
            self.cgImage = cgImage
            self.frame = frame
        }
    }
    
    private final class ContextWithAllocatedMemory {
        let cgImage: CGImage
        let frame: CGRect
        let cgContext: CGContext
        let imagePixels: UnsafeMutableRawPointer
        let imageSizeInBytes: Int
        
        init(
            cgImage: CGImage,
            frame: CGRect,
            cgContext: CGContext,
            imagePixels: UnsafeMutableRawPointer,
            imageSizeInBytes: Int)
        {
            self.cgImage = cgImage
            self.frame = frame
            self.cgContext = cgContext
            self.imagePixels = imagePixels
            self.imageSizeInBytes = imageSizeInBytes
        }
    }
    
    private func assertPixelsAreEqual(
        lhsImage: UIImage,
        rhsImage: UIImage)
        -> Result<Void, ComparisonError>
    {
        return contextWithImage(image: lhsImage).flatMap { (lhsContext: ContextWithImage) in
            contextWithImage(image: rhsImage).flatMap { (rhsContext: ContextWithImage) in
                compareContextsWithImages(
                    lhsContext: lhsContext,
                    rhsContext: rhsContext
                )
            }
        }
    }
    
    private func contextWithImage(image: UIImage) -> Result<ContextWithImage, ComparisonError> {
        return cgImage(image: image).map { cgImage in
            ContextWithImage(
                cgImage: cgImage,
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: cgImage.width,
                    height: cgImage.height
                )
            )
        }
    }
    
    private func compareContextsWithImages(
        lhsContext: ContextWithImage,
        rhsContext: ContextWithImage)
        -> Result<Void, ComparisonError>
    {
        return getAnyValueIfValuesAreSame(lhs: lhsContext.frame, rhs: rhsContext.frame, name: "frame").flatMap { (frame: CGRect) in
            // We shouldn't check if `bytesPerRow` are equal for images.
            // There can be extra bytes, which can be ignored.
            // https://stackoverflow.com/questions/25706397/cgimageref-width-doesnt-agree-with-bytes-per-row
            let bytesPerRow = min(lhsContext.cgImage.bytesPerRow, rhsContext.cgImage.bytesPerRow)
            let imageSizeInBytes = Int(frame.size.height) * bytesPerRow
            
            let lhsContextWithAllocatedMemory = contextWithAllocatedMemory(
                contextWithImage: lhsContext,
                imageSizeInBytes: imageSizeInBytes,
                bytesPerRow: bytesPerRow
            )
                
            return lhsContextWithAllocatedMemory.flatMap { (lhsContext: ContextWithAllocatedMemory) in
                let rhsContextWithAllocatedMemory = contextWithAllocatedMemory(
                    contextWithImage: rhsContext,
                    imageSizeInBytes: imageSizeInBytes,
                    bytesPerRow: bytesPerRow
                )
                    
                return rhsContextWithAllocatedMemory.flatMap { (rhsContext: ContextWithAllocatedMemory) in
                    compareContextsWithAllocatedMemory(
                        lhsContext: lhsContext,
                        rhsContext: rhsContext,
                        frame: frame
                    )
                }
            }
        }
    }
    
    private func contextWithAllocatedMemory(
        contextWithImage: ContextWithImage,
        imageSizeInBytes: Int,
        bytesPerRow: Int)
        -> Result<ContextWithAllocatedMemory, ComparisonError>
    {
        return allocateMemory(size: imageSizeInBytes).flatMap { (imagePixels: UnsafeMutableRawPointer) in
            cgContext(data: imagePixels, image: contextWithImage.cgImage, bytesPerRow: bytesPerRow).map { cgContext in
                ContextWithAllocatedMemory(
                    cgImage: contextWithImage.cgImage,
                    frame: contextWithImage.frame,
                    cgContext: cgContext,
                    imagePixels: imagePixels,
                    imageSizeInBytes: imageSizeInBytes
                )
            }
        }
    }
    
    private func compareContextsWithAllocatedMemory(
        lhsContext: ContextWithAllocatedMemory,
        rhsContext: ContextWithAllocatedMemory,
        frame: CGRect)
        -> Result<Void, ComparisonError>
    {
        lhsContext.cgContext.draw(lhsContext.cgImage, in: frame)
        rhsContext.cgContext.draw(rhsContext.cgImage, in: frame)
        
        let pixelCount = Int(frame.size.width) * Int(frame.size.height)
        let intTolerance = Int(tolerance * CGFloat(pixelCount))
        
        if intTolerance > 0 || forceUsingNonDiscretePercentageOfMatching {
            return comparePixelByPixel(
                lhsContext: lhsContext,
                rhsContext: rhsContext,
                intTolerance: intTolerance,
                pixelCount: pixelCount
            )
        } else {
            return compareUsingMemcmp(
                lhsContext: lhsContext,
                rhsContext: rhsContext
            )
        }
    }

    // Does a fast comparison
    private func compareUsingMemcmp(
        lhsContext: ContextWithAllocatedMemory,
        rhsContext: ContextWithAllocatedMemory)
        -> Result<Void, ComparisonError>
    {
        let resultIfNoDifference = 0
        
        let result = memcmp(
            lhsContext.imagePixels,
            rhsContext.imagePixels,
            min(lhsContext.imageSizeInBytes, rhsContext.imageSizeInBytes)
        )
        
        if result == resultIfNoDifference {
            return .success(())
        } else {
            return .failure(imageHasDifferentPixelsError(percentageOfMatching: 0))
        }
    }

    // Goes through each pixel in turn and see if it is different
    private func comparePixelByPixel(
        lhsContext: ContextWithAllocatedMemory,
        rhsContext: ContextWithAllocatedMemory,
        intTolerance: Int,
        pixelCount: Int)
        -> Result<Void, ComparisonError>
    {
        var differentPixelsCount = 0
        
        for pixel in 0..<pixelCount {
            let lhsPixel = lhsContext.imagePixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            let rhsPixel = rhsContext.imagePixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            
            if lhsPixel != rhsPixel {
                differentPixelsCount += 1
                
                if differentPixelsCount > intTolerance {
                    let samePixelsCount = pixelCount - differentPixelsCount
                    
                    let totalNecessaryPixelsToMatch = pixelCount - intTolerance

                    return .failure(
                        imageHasDifferentPixelsError(
                            percentageOfMatching: Double(samePixelsCount) / Double(totalNecessaryPixelsToMatch)
                        )
                    )
                }
            }
        }
        
        return .success(())
    }
    
    private func cgImage(image: UIImage) -> Result<CGImage, ComparisonError> {
        if let cgImage = image.cgImage {
            return .success(cgImage)
        } else {
            return .failure(ComparisonError(message: "cgImage of image is nil"))
        }
    }
    
    private func imageHasDifferentPixelsError(
        percentageOfMatching: Double)
        -> ComparisonError
    {
         return ComparisonError(
            message: "Image has different pixels",
            percentageOfMatching: percentageOfMatching
         )
    }
    
    private func cgContext(
        data: UnsafeMutableRawPointer?,
        image: CGImage,
        bytesPerRow: Int)
        -> Result<CGContext, ComparisonError>
    {
        return colorSpace(image: image).flatMap { (colorSpace: CGColorSpace) -> Result<CGContext, ComparisonError> in
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
            
            let contextOrNil = CGContext(
                data: data,
                width: image.width,
                height: image.height,
                bitsPerComponent: image.bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            )
            
            if let context = contextOrNil {
                return .success(context)
            } else {
                return .failure(ComparisonError(message: "Failed to create CGContext"))
            }
        }
    }
    
    private func colorSpace(image: CGImage) -> Result<CGColorSpace, ComparisonError> {
        if let colorSpace = image.colorSpace {
            return .success(colorSpace)
        } else {
            return .failure(ComparisonError(message: "colorSpace is nil for image"))
        }
    }
    
    private func allocateMemory(size: Int) -> Result<UnsafeMutableRawPointer, ComparisonError> {
        if let memory = calloc(1, size) {
            return .success(memory)
        } else {
            return .failure(ComparisonError(message: "Failed to calloc(1, \(size))"))
        }
    }
    
    private func getAnyValueIfValuesAreSame<T: Equatable>(
        lhs: T,
        rhs: T,
        name: String)
        -> Result<T, ComparisonError>
    {
        return getAnyValueIfValuesAreSame(
            lhs: lhs,
            rhs: rhs,
            error: { lhs, rhs in "Images have different \(name): \(lhs) != \(rhs)" }
        )
    }
    
    private func getAnyValueIfValuesAreSame<T: Equatable>(
        lhs: T,
        rhs: T,
        error: (T, T) -> String)
        -> Result<T, ComparisonError>
    {
        if lhs == rhs {
            return .success(lhs)
        } else {
            return .failure(ComparisonError(message: error(lhs, rhs)))
        }
    }
}
