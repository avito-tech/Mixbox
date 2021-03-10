#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisibilityCheckImageColorShifterImpl: VisibilityCheckImageColorShifter {
    public init() {
    }
    
    // TODO: Split this function.
    //
    // The code below shifts RGB channels by some amount. The idea is that if after shifting colors of view
    // something really changes for user, then this view is visible. If nothing is changed, then it's hidden,
    // overlapped, etc.
    //
    // ----
    //
    // Below this paragraph is the original comment on how this code works. This is not how it was really working!
    // But the idea from the comment seems much better than the current implementation.
    // Current implementation is buggy and doesn't work great for every edge case.
    // The idea from the comment below might work better, but it also doesn't work properly in reality.
    // It would be good if we write tests, checking every combination of views, colors, positions, alpha, etc,
    // and test the actual percentage of visible area vs expected.
    //
    // ----
    //
    // Creates a UIImageView and adds a shifted color image of @c imageRef to it, in addition
    // view.frame is offset by @c offset and image orientation set to @c orientation. There are 256
    // possible values for a color component, from 0 to 255. Each color component will be shifted by
    // exactly 128, examples: 0 => 128, 64 => 192, 128 => 0, 255 => 127.
    //
    // @param imageRef The image whose colors are to be shifted.
    // @param offset The frame offset to be applied to resulting view.
    // @param orientation The target orientation of the image added to the resulting view.
    //
    // @return A view containing shifted color image of @c imageRef with view.frame offset by
    //         @c offset and orientation set to @c orientation.
    //
    public func imagePixelDataWithShiftedColors(
        imagePixelData: ImagePixelData,
        targetPixelOfInteraction: IntPoint?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        -> ImagePixelData
    {
        let shiftedImagePixels = imagePixelData.copy()
        let buffer = shiftedImagePixels.imagePixelBuffer
        
        func getPixelIndex(x: Int, y: Int) -> Int {
            return y * shiftedImagePixels.size.width + x
        }
        
        func getPixelDataOffset(x: Int, y: Int) -> Int {
            return getPixelIndex(x: x, y: y) * shiftedImagePixels.bytesPerPixel
        }
        
        func shiftPixels(x: Int, y: Int) {
            let pixelDataOffset = getPixelDataOffset(x: x, y: y)
            
            // We don't care about the [first] byte of the [X]RGB format.
            for byteIndex in 1..<4 {
                let shiftIntensityAmount: UInt8 = 10
                var pixelIntensity = buffer[pixelDataOffset + byteIndex]
                
                if pixelIntensity >= shiftIntensityAmount {
                    pixelIntensity -= shiftIntensityAmount
                } else {
                    pixelIntensity += shiftIntensityAmount
                }
                
                buffer[pixelDataOffset + byteIndex] = pixelIntensity
            }
        }
        
        if let targetPixelOfInteraction = targetPixelOfInteraction {
            let targetPixelDataOffset = getPixelDataOffset(
                x: targetPixelOfInteraction.x,
                y: targetPixelOfInteraction.y
            )
            
            func getTargetPixel() -> Int {
                return Int(buffer[targetPixelDataOffset + 1])
                    | (Int(buffer[targetPixelDataOffset + 2]) << 8)
                    | (Int(buffer[targetPixelDataOffset + 3]) << 16)
            }
            
            let targetPixelBefore = getTargetPixel()
            
            // 1. We check grid to make an approximate calculation of visible area
            visibilityCheckForLoopOptimizer.forEachPoint(
                imageSize: shiftedImagePixels.size,
                loop: shiftPixels
            )
            
            let targetPixelAfter = getTargetPixel()
            
            // 2. We check some pixels specifically (e.g. to tap them if they are visible or to tap neighboring pixels
            // We should shift pixels only if they were not shifted before
            
            if targetPixelBefore == targetPixelAfter {
                shiftPixels(
                    x: targetPixelOfInteraction.x,
                    y: targetPixelOfInteraction.y
                )
            }
        } else {
            // Just shift grid, because there is no target pixel
            visibilityCheckForLoopOptimizer.forEachPoint(
                imageSize: shiftedImagePixels.size,
                loop: shiftPixels
            )
        }
        
        return shiftedImagePixels
    }
}

#endif
