#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxUiKit
import MixboxFoundation

public final class VisiblePixelDataCalculatorImpl: VisiblePixelDataCalculator {
    private let imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator
    private let visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer
    
    public init(
        imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
    {
        self.imagePixelDataFromImageCreator = imagePixelDataFromImageCreator
        self.visibilityCheckForLoopOptimizer = visibilityCheckForLoopOptimizer
    }
    
    // swiftlint:disable:next function_body_length
    public func visiblePixelData(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        searchRectInScreenCoordinates: CGRect,
        screenScale: CGFloat,
        visibilityCheckTargetCoordinates: VisibilityCheckTargetCoordinates?)
        throws
        -> VisiblePixelData
    {
        let imageSize = beforeImagePixelData.size
        
        guard imageSize == afterImagePixelData.size else {
            throw ErrorString(
                "Images must be of same size. Before: \(beforeImagePixelData.size). After \(afterImagePixelData.size)"
            )
        }
        
        let bytesPerPixel = beforeImagePixelData.bytesPerPixel
        
        guard bytesPerPixel == afterImagePixelData.bytesPerPixel else {
            throw ErrorString(
                "Images must be with same bytesPerPixel. Before: \(beforeImagePixelData.bytesPerPixel). After \(afterImagePixelData.bytesPerPixel)"
            )
        }
        
        // Note: the optimization has little 2..3.5% boost.
        // The idea is to compare 1 UInt32 instead of 3 UInt8
        guard bytesPerPixel == 4 else {
            throw ErrorString(
                "This code is optimized for 4 bytes per pixel. Remove optimization and this check."
            )
        }
        
        let pixelsBefore = reboundedMemoryFor32BitPixels(imagePixelData: beforeImagePixelData)
        let pixelsAfter = reboundedMemoryFor32BitPixels(imagePixelData: afterImagePixelData)
        
        var checkedPixelCount: Int = 0
        var visiblePixelCount: Int = 0
        var visiblePixel: CGPoint?
        var minimalSquaredDistanceToTargetPoint = Int.max
        
        // 1. Check if target pixel is already visible, it takes O(1) and the pixel is often visible.
        //    Without this check the operation will take O(X*Y).
        // 2. We use grid (which reduces number of points to small constant amount) so
        //    the target pixel is not exactly a point from grid. We want to tap to target pixel if possible,
        //    and not just somewhere near it.
        
        let targetPixelToForAForLoop: IntPoint?
        var closestVisiblePixelInImage: IntPoint?
        
        if let visibilityCheckTargetCoordinates = visibilityCheckTargetCoordinates {
            let targetPixelOfInteraction = visibilityCheckTargetCoordinates.targetPixelOfInteraction
            
            let targetPixelHasDiff = Self.isPixelDifferent(
                pixelsBefore: pixelsBefore,
                pixelsAfter: pixelsAfter,
                index: targetPixelOfInteraction.y * imageSize.width + targetPixelOfInteraction.x
            )
            
            if targetPixelHasDiff {
                targetPixelToForAForLoop = nil
                // It is always better to return same point that is target, not to just tap pixel of image.
                // For example, it is better for cases with very tiny views (less than a point).
                visiblePixel = visibilityCheckTargetCoordinates.targetPointOfInteraction
            } else {
                targetPixelToForAForLoop = targetPixelOfInteraction
            }
        } else {
            targetPixelToForAForLoop = nil
        }
        
        visibilityCheckForLoopOptimizer.forEachPoint(imageSize: imageSize) { (x, y) in
            checkedPixelCount += 1
            
            let currentPixelIndex = y * imageSize.width + x
            
            let pixelHasDiff = Self.isPixelDifferent(
                pixelsBefore: pixelsBefore,
                pixelsAfter: pixelsAfter,
                index: currentPixelIndex
            )
            
            if pixelHasDiff {
                visiblePixelCount += 1
                
                if let targetPixelToForAForLoop = targetPixelToForAForLoop {
                    let dx = targetPixelToForAForLoop.x - x
                    let dy = targetPixelToForAForLoop.y - y
                    let squaredDistanceToTargetPoint = dx * dx + dy * dy
                    
                    if squaredDistanceToTargetPoint < minimalSquaredDistanceToTargetPoint {
                        minimalSquaredDistanceToTargetPoint = squaredDistanceToTargetPoint
                        closestVisiblePixelInImage = IntPoint(x: x, y: y)
                    }
                }
            }
        }
        
        return VisiblePixelData(
            visiblePixelCount: visiblePixelCount,
            checkedPixelCount: checkedPixelCount,
            visiblePixel: visiblePixel ?? closestVisiblePixelInImage.map { closestVisiblePixelInImage in
                self.visiblePixel(
                    intPoint: closestVisiblePixelInImage,
                    imageSize: imageSize,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates,
                    screenScale: screenScale
                )
            }
        )
    }
    
    private func visiblePixel(
        intPoint: IntPoint,
        imageSize: IntSize,
        searchRectInScreenCoordinates: CGRect,
        screenScale: CGFloat)
        -> CGPoint
    {
        // Without this line tests fail to tap single pixel views:
        let centerOfPixel = screenScale / 2
        
        let pointInView = CGPoint(
            x: CGFloat(intPoint.x) / CGFloat(imageSize.width) * searchRectInScreenCoordinates.width + centerOfPixel,
            y: CGFloat(intPoint.y) / CGFloat(imageSize.height) * searchRectInScreenCoordinates.height + centerOfPixel
        )
        
        return pointInView + searchRectInScreenCoordinates.origin
    }

    // TODO: Ideally, we should be testing that pixel colors are shifted by a certain amount instead of
    // checking if they are simply different. However, the naive check for shifted colors doesn't
    // work if pixels are overlapped by a translucent mask or have special layer effects applied
    // to it. Because they are still visible to user and we want to avoid false-negatives that
    // would cause the test to fail, we resort to a naive check that rbg1 and rgb2 are not the
    // same without specifying the exact delta between them.
    static func isPixelDifferent(
        pixelsBefore: UnsafeMutablePointer<UInt32>,
        pixelsAfter: UnsafeMutablePointer<UInt32>,
        index: Int)
        -> Bool
    {
        return pixelsBefore[index] != pixelsAfter[index]
    }
    
    private func reboundedMemoryFor32BitPixels(
        imagePixelData: ImagePixelData)
        -> UnsafeMutablePointer<UInt32>
    {
        return imagePixelData.imagePixelBuffer.pointer.withMemoryRebound(
            to: UInt32.self,
            capacity: imagePixelData.imagePixelBuffer.count / 4,
            { pointer in
                pointer
            }
        )
    }
}

#endif
