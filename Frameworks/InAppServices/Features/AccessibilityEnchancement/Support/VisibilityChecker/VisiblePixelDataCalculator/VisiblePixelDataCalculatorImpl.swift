#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxUiKit
import MixboxFoundation

public final class VisiblePixelDataCalculatorImpl: VisiblePixelDataCalculator {
    private let imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator
    private let colorChannelsPerPixel = 4
    
    public init(imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator) {
        self.imagePixelDataFromImageCreator = imagePixelDataFromImageCreator
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func visiblePixelData(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        searchRectInScreenCoordinates: CGRect,
        targetPointOfInteraction: CGPoint?)
        throws
        -> VisiblePixelData
    {
        let imageSize = beforeImagePixelData.size
        
        guard beforeImagePixelData.size == afterImagePixelData.size else {
            throw ErrorString(
                "Images must be of same size. Size before: \(beforeImagePixelData.size). Size after \(afterImagePixelData.size)"
            )
        }
        
        var visiblePixelCount: Int = 0
        var visiblePixel: CGPoint?
        var minimalSquaredDistanceToTargetPoint = Int.max
        
        // Check if target pixel is already visible, it takes O(1) and the pixel is often visible.
        // Without this check the operation will take O(X*Y).
        
        let targetPixelInImage: IntPoint?
        var closestVisiblePixelInImage: IntPoint?
        
        if let targetPointOfInteraction = targetPointOfInteraction {
            let localTargetPixelInImage = self.targetPixelInImage(
                targetPointOfInteraction: targetPointOfInteraction,
                imageSize: imageSize,
                searchRectInScreenCoordinates: searchRectInScreenCoordinates
            )
            
            let targetPixelHasDiff = Self.isPixelDifferent(
                beforeImagePixelData: beforeImagePixelData,
                afterImagePixelData: afterImagePixelData,
                index: (localTargetPixelInImage.y * imageSize.width + localTargetPixelInImage.x) * colorChannelsPerPixel
            )
            
            if targetPixelHasDiff {
                targetPixelInImage = nil
                visiblePixel = targetPointOfInteraction
            } else {
                targetPixelInImage = localTargetPixelInImage
            }
        } else {
            targetPixelInImage = nil
        }
        
        // Note: we go row-order to take advantage of data locality (cuts runtime in half).
        for y in 0..<imageSize.height {
            for x in 0..<imageSize.width {
                let currentPixelIndex = y * imageSize.width + x
                let currentPixelByteIndex = currentPixelIndex * colorChannelsPerPixel
                
                let pixelHasDiff = Self.isPixelDifferent(
                    beforeImagePixelData: beforeImagePixelData,
                    afterImagePixelData: afterImagePixelData,
                    index: currentPixelByteIndex
                )
                
                if pixelHasDiff {
                    visiblePixelCount += 1
                    
                    if let targetPixelInImage = targetPixelInImage {
                        let dx = targetPixelInImage.x - x
                        let dy = targetPixelInImage.y - y
                        let squaredDistanceToTargetPoint = dx * dx + dy * dy
                        
                        if squaredDistanceToTargetPoint < minimalSquaredDistanceToTargetPoint {
                            minimalSquaredDistanceToTargetPoint = squaredDistanceToTargetPoint
                            closestVisiblePixelInImage = IntPoint(x: x, y: y)
                        }
                    }
                }
            }
        }
        
        return VisiblePixelData(
            visiblePixelCount: visiblePixelCount,
            visiblePixel: visiblePixel ?? closestVisiblePixelInImage.map { closestVisiblePixelInImage in
                self.visiblePixel(
                    intPoint: closestVisiblePixelInImage,
                    imageSize: imageSize,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates
                )
            }
        )
    }
    
    private func targetPixelInImage(
        targetPointOfInteraction: CGPoint,
        imageSize: IntSize,
        searchRectInScreenCoordinates: CGRect)
        -> IntPoint
    {
        // TODO: Make check for division by zero more obvious, don't forget it
        // after rewriting the code (improvement of performance was planned).
        // Currently the check is located in another class (VisibilityCheckImagesCapturer).
        // Same for `func visiblePixel`.
        let offsetInView = targetPointOfInteraction - searchRectInScreenCoordinates.origin
        
        return IntPoint(
            x: Int(offsetInView.dx / searchRectInScreenCoordinates.width * CGFloat(imageSize.width)),
            y: Int(offsetInView.dy / searchRectInScreenCoordinates.height * CGFloat(imageSize.height))
        )
    }
    
    private func visiblePixel(
        intPoint: IntPoint,
        imageSize: IntSize,
        searchRectInScreenCoordinates: CGRect)
        -> CGPoint
    {
        let pointInView = CGPoint(
            x: CGFloat(intPoint.x) / CGFloat(imageSize.width) * searchRectInScreenCoordinates.width,
            y: CGFloat(intPoint.y) / CGFloat(imageSize.height) * searchRectInScreenCoordinates.height
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
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        index: Int)
        -> Bool
    {
        let lhs = beforeImagePixelData.imagePixelBuffer.pointer.advanced(by: index)
        let rhs = afterImagePixelData.imagePixelBuffer.pointer.advanced(by: index)
        
        // We don't care about the first byte because we are dealing with XRGB format.
        return (lhs[0] != rhs[0])
            || (lhs[1] != rhs[1])
            || (lhs[2] != rhs[2])
    }
}

#endif
