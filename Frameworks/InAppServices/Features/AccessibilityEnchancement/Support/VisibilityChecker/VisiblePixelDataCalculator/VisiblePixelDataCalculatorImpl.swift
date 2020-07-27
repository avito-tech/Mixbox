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
        targetPointOfInteraction: CGPoint?,
        storeVisiblePixelRect: Bool,
        storeComparisonResult: Bool)
        throws
        -> VisiblePixelData
    {
        let imageSize = beforeImagePixelData.size
        
        guard beforeImagePixelData.size == afterImagePixelData.size else {
            throw ErrorString(
                "Images must be of same size. Size before: \(beforeImagePixelData.size). Size after \(afterImagePixelData.size)"
            )
        }
        
        var histograms: [UInt16]
        
        // We only want to perform the relatively expensive rect computation if we've actually
        // been asked for it.
        if storeVisiblePixelRect {
            histograms = [UInt16](repeating: 0, count: imageSize.area)
        } else {
            histograms = [UInt16]()
        }
        
        var visiblePixelCount: Int = 0
        var visiblePixel: CGPoint?
        var visiblePixelRect: CGRect?
        var minimalSquaredDistanceToTargetPoint = Int.max
        var comparisonResultBuffer: VisibilityDiffBuffer
        
        // Prepare comparison result if needed
        
        if storeComparisonResult {
            comparisonResultBuffer = VisibilityDiffBuffer.createUninitialized(
                width: imageSize.width,
                height: imageSize.height
            )
        } else {
            comparisonResultBuffer = VisibilityDiffBuffer.createUninitialized(width: 0, height: 0)
        }
        
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
                
                if storeVisiblePixelRect {
                    if y == 0 {
                        histograms[x] = pixelHasDiff ? 1 : 0
                    } else {
                        histograms[currentPixelIndex] = pixelHasDiff ? (histograms[(y - 1) * imageSize.width + x] + 1) : 0
                    }
                }
                
                if storeComparisonResult {
                    comparisonResultBuffer.setVisibility(x: x, y: y, value: pixelHasDiff)
                }
            }
        }
        
        // Perform additional computation if `storeVisiblePixelRect` is set.
        
        if storeVisiblePixelRect {
            var globalLargestRect: CGRect = .zero
            
            for idx in 0..<imageSize.height {
                var localLargestRect = Self.largestRect(
                    inHistogram: histograms,
                    idx: idx,
                    length: UInt16(imageSize.width)
                )
                
                if localLargestRect.mb_area > globalLargestRect.mb_area {
                    // Because our histograms point up, not down.
                    localLargestRect.origin.y = CGFloat(idx) - localLargestRect.size.height + 1
                    globalLargestRect = localLargestRect
                }
            }
            
            visiblePixelRect = globalLargestRect
        }
        
        return VisiblePixelData(
            visiblePixelCount: visiblePixelCount,
            visiblePixel: visiblePixel ?? closestVisiblePixelInImage.map { closestVisiblePixelInImage in
                self.visiblePixel(
                    intPoint: closestVisiblePixelInImage,
                    imageSize: imageSize,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates
                )
            },
            visiblePixelRect: visiblePixelRect,
            comparisonResultBuffer: comparisonResultBuffer
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

    // Given a list of values representing a histogram (values are the heights of the bars), this
    // method returns the largest contiguous rectangle in that histogram.
    //
    // `histogram`: the array of values representing the histogram
    // `length`: the number of values in the histogram (a size of one side of 2d-array)
    //
    // Returns a CGRect of the largest rectangle in the given histogram.
    //
    static func largestRect(inHistogram histogram: [UInt16], idx: Int, length: UInt16) -> CGRect {
        let length = Int(length)
        
        let leftNeighbors = UnsafeArray<Int>(count: length)
        let rightNeighbors = UnsafeArray<Int>(count: length)
        let leftStack = UnsafeArray<Int>(count: length)
        let rightStack = UnsafeArray<Int>(count: length)
        
        // Index of the last element on the stack.
        var leftStackIdx = -1
        var rightStackIdx = -1
        
        var largestRect = CGRect.zero
        
        var largestArea = 0
        
        // We make two passes at once, one from left to right and one from right to left.
        for idx in 0..<length {
            let tailIdx = (length - 1) - idx
            
            // Find nearest column shorter than this one on either side.
            while leftStackIdx >= 0 && histogram[leftStack[leftStackIdx]] >= histogram[idx] {
                leftStackIdx -= 1
            }
            while rightStackIdx >= 0 && histogram[rightStack[rightStackIdx]] >= histogram[tailIdx] {
                rightStackIdx -= 1
            }
            // Set the number of columns at least as tall as this one on either side.
            if leftStackIdx < 0 {
                leftNeighbors[idx] = idx
            } else {
                leftNeighbors[idx] = idx - leftStack[leftStackIdx] - 1
            }
            
            if rightStackIdx < 0 {
                rightNeighbors[tailIdx] = length - tailIdx - 1
            } else {
                rightNeighbors[tailIdx] = rightStack[rightStackIdx] - tailIdx - 1
            }
            
            leftStackIdx += 1
            rightStackIdx += 1
            
            // Add the current index to the stack
            leftStack[leftStackIdx] = idx
            rightStack[rightStackIdx] = tailIdx
        }
        
        // Now we have the number of histogram bars immediately left and right of each bar that are at
        // least as tall as the given bar. Now we can compute areas easily.
        for idx in 0..<length {
            let area = (leftNeighbors[idx] + rightNeighbors[idx] + 1) * Int(histogram[idx])
            
            if area > largestArea {
                largestArea = area
                largestRect.origin.x = CGFloat(idx - leftNeighbors[idx])
                largestRect.size.width = CGFloat(leftNeighbors[idx] + rightNeighbors[idx] + 1)
                largestRect.size.height = CGFloat(histogram[idx])
            }
        }
        
        return largestRect
    }
}

#endif
