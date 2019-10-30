import MixboxFoundation

// NOTE: Swift.Result is used instead of Swift exceptions, because exceptions cause various
// EXC_BAD_ACCESS errors (in random places) due to some kind of bug in memory management in Swift.
public final class PerPixelSnapshotsComparator: SnapshotsComparator {
    public init() {
    }
    
    public func compare(
        actualImage: UIImage,
        expectedImage: UIImage)
        -> SnapshotsComparisonResult
    {
        let result = assertPixelsAreEqual(lhsImage: actualImage, rhsImage: expectedImage, tolerance: 0)
        
        switch result {
        case .success:
            return .similar
        case .failure(let error):
            return .different(
                LazySnapshotsDifferenceDescription(
                    percentageOfMatching: 0, // TODO: Support calculation? It can negatively affect performance.
                    messageFactory: { "Failed to compare images: \(error)" },
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
    
    // `tolerance`: 0..1. How many pixels can be different.
    private func assertPixelsAreEqual(
        lhsImage: UIImage,
        rhsImage: UIImage,
        tolerance: CGFloat)
        -> Result<Void, ErrorString>
    {
        return contextWithImage(image: lhsImage).flatMap { (lhsContext: ContextWithImage) in
            contextWithImage(image: rhsImage).flatMap { (rhsContext: ContextWithImage) in
                compareContextsWithImages(
                    lhsContext: lhsContext,
                    rhsContext: rhsContext,
                    tolerance: tolerance
                )
            }
        }
    }
    
    private func contextWithImage(image: UIImage) -> Result<ContextWithImage, ErrorString> {
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
        rhsContext: ContextWithImage,
        tolerance: CGFloat)
        -> Result<Void, ErrorString>
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
                        frame: frame,
                        tolerance: tolerance
                    )
                }
            }
        }
    }
    
    private func contextWithAllocatedMemory(
        contextWithImage: ContextWithImage,
        imageSizeInBytes: Int,
        bytesPerRow: Int)
        -> Result<ContextWithAllocatedMemory, ErrorString>
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
        frame: CGRect,
        tolerance: CGFloat)
        -> Result<Void, ErrorString>
    {
        lhsContext.cgContext.draw(lhsContext.cgImage, in: frame)
        rhsContext.cgContext.draw(rhsContext.cgImage, in: frame)
        
        let pixelCount = Int(frame.size.width) * Int(frame.size.height)
        let intTolerance = Int(tolerance * CGFloat(pixelCount))
        
        if intTolerance == 0 {
            return compareUsingMemcmp(
                lhsContext: lhsContext,
                rhsContext: rhsContext
            )
        } else {
            return compareWithTolerance(
                lhsContext: lhsContext,
                rhsContext: rhsContext,
                intTolerance: intTolerance,
                pixelCount: pixelCount
            )
        }
    }

    // Does a fast comparison
    private func compareUsingMemcmp(
        lhsContext: ContextWithAllocatedMemory,
        rhsContext: ContextWithAllocatedMemory)
        -> Result<Void, ErrorString>
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
            return .failure(imageHasDifferentPixelsError())
        }
    }

    // Goes through each pixel in turn and see if it is different
    private func compareWithTolerance(
        lhsContext: ContextWithAllocatedMemory,
        rhsContext: ContextWithAllocatedMemory,
        intTolerance: Int,
        pixelCount: Int)
        -> Result<Void, ErrorString>
    {
        var differentPixelsCount = 0
        
        for pixel in 0..<pixelCount {
            let lhsPixel = lhsContext.imagePixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            let rhsPixel = rhsContext.imagePixels.load(fromByteOffset: pixel * 4, as: UInt32.self)
            
            if lhsPixel != rhsPixel {
                differentPixelsCount += 1
                
                if differentPixelsCount > intTolerance {
                    return .failure(imageHasDifferentPixelsError())
                }
            }
        }
        
        return .success(())
    }
    
    private func cgImage(image: UIImage) -> Result<CGImage, ErrorString> {
        if let cgImage = image.cgImage {
            return .success(cgImage)
        } else {
            return .failure(ErrorString("cgImage of image is nil"))
        }
    }
    
    private func imageHasDifferentPixelsError() -> ErrorString {
         return ErrorString("Image has different pixels")
    }
    
    private func cgContext(
        data: UnsafeMutableRawPointer?,
        image: CGImage,
        bytesPerRow: Int)
        -> Result<CGContext, ErrorString>
    {
        return colorSpace(image: image).flatMap { (colorSpace: CGColorSpace) -> Result<CGContext, ErrorString> in
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
                return .failure(ErrorString("Failed to create CGContext"))
            }
        }
    }
    
    private func colorSpace(image: CGImage) -> Result<CGColorSpace, ErrorString> {
        if let colorSpace = image.colorSpace {
            return .success(colorSpace)
        } else {
            return .failure(ErrorString("colorSpace is nil for image"))
        }
    }
    
    private func allocateMemory(size: Int) -> Result<UnsafeMutableRawPointer, ErrorString> {
        if let memory = calloc(1, size) {
            return .success(memory)
        } else {
            return .failure(ErrorString("Failed to calloc(1, \(size))"))
        }
    }
    
    private func getAnyValueIfValuesAreSame<T: Equatable>(
        lhs: T,
        rhs: T,
        name: String)
        -> Result<T, ErrorString>
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
        -> Result<T, ErrorString>
    {
        if lhs == rhs {
            return .success(lhs)
        } else {
            return .failure(ErrorString(error(lhs, rhs)))
        }
    }
}
