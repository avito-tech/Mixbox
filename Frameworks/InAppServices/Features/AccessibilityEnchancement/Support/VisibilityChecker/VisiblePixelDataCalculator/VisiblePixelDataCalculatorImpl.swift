#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxUiKit
import MixboxFoundation

public final class VisiblePixelDataCalculatorImpl: VisiblePixelDataCalculator {
    private let imagePixelDataCreator: ImagePixelDataCreator
    private let colorChannelsPerPixel = 4
    
    public init(imagePixelDataCreator: ImagePixelDataCreator) {
        self.imagePixelDataCreator = imagePixelDataCreator
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func visiblePixelData(
        beforeImage: CGImage,
        afterImage: CGImage,
        storeVisiblePixelRect: Bool,
        storeComparisonResult: Bool)
        throws
        -> VisiblePixelData
    {
        let width = beforeImage.width
        let height = beforeImage.height
        
        guard width == afterImage.width else {
            throw ErrorString(
                "Images must be of same size. Width before: \(beforeImage.width). Width after \(afterImage.width)"
            )
        }
        
        guard height == afterImage.height else {
            throw ErrorString(
                "Images must be of same size. Width before: \(beforeImage.height). Width after \(afterImage.height)"
            )
        }
        
        let beforeImagePixelData = try imagePixelDataCreator.createImagePixelData(image: beforeImage)
        let afterImagePixelData = try imagePixelDataCreator.createImagePixelData(image: afterImage)
        
        var histograms: [UInt16]
        
        // We only want to perform the relatively expensive rect computation if we've actually
        // been asked for it.
        if storeVisiblePixelRect {
            histograms = [UInt16](repeating: 0, count: width * height)
        } else {
            histograms = [UInt16]()
        }
        
        var visiblePixelCount: Int = 0
        var visiblePixel: CGPoint?
        var visiblePixelRect: CGRect?
        var comparisonResultBuffer: VisibilityDiffBuffer
        
        if storeComparisonResult {
            comparisonResultBuffer = VisibilityDiffBuffer.createUninitialized(
                width: width,
                height: height
            )
        } else {
            comparisonResultBuffer = VisibilityDiffBuffer.createUninitialized(width: 0, height: 0)
        }
        
        // Make sure we go row-order to take advantage of data locality (cuts runtime in half).
        for y in 0..<height {
            for x in 0..<width {
                let currentPixelIndex = (y * width + x) * colorChannelsPerPixel
                
                let pixelHasDiff = Self.isPixelDifferent(
                    beforeImagePixelData: beforeImagePixelData,
                    afterImagePixelData: afterImagePixelData,
                    index: currentPixelIndex
                )
                
                if pixelHasDiff {
                    visiblePixelCount += 1
                    // Always pick the bottom and right-most pixel. We may want to consider using tax-cab
                    // formula to find a pixel that's closest to the center if we encounter problems with this
                    // approach.
                    visiblePixel = CGPoint(x: x, y: y)
                }
                
                if storeVisiblePixelRect {
                    if y == 0 {
                        histograms[x] = pixelHasDiff ? 1 : 0
                    } else {
                        histograms[y * width + x] = pixelHasDiff ? (histograms[(y - 1) * width + x] + 1) : 0
                    }
                }
                
                if storeComparisonResult {
                    comparisonResultBuffer.setVisibility(x: x, y: y, value: pixelHasDiff)
                }
            }
        }
        
        if storeVisiblePixelRect {
            var globalLargestRect: CGRect = .zero
            
            for idx in 0..<height {
                var localLargestRect = Self.largestRect(
                    inHistogram: histograms,
                    idx: idx,
                    length: UInt16(width)
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
            visiblePixel: visiblePixel,
            visiblePixelRect: visiblePixelRect,
            comparisonResultBuffer: comparisonResultBuffer
        )
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
