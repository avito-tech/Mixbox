#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit

public final class VisibilityCheckForLoopOptimizerImpl: VisibilityCheckForLoopOptimizer {
    private let numberOfPointsInGrid: Int
    
    // NOTE: it is possible to calculate `numberOfPointsInGrid` purely via accuracy:
    //
    // This equation can be solved for `n` (where `n` is `numberOfPointsInGrid`)
    // `a = (w * h - (w - (p + sqrt(n * w / h)) * 2) * (h - (p + sqrt(n * h / w)) * 2)) / (w * h)`
    // Since I don't have paid wolframalpha I can not solve it (and free version times out).
    //
    // This equation is basically a relation between area of grid (including pixels of size `p`)
    // and area of image. The idea is that if something overlaps image, but not the grid, it doesn't count
    // as overlapping (and vice versa).
    private let useHundredPercentAccuracy: Bool
    
    // If numbers of points of image is less than `numberOfPointsInGrid`
    // then 100% accuracy will be enforced (because it wouldn't take much CPU time anyway).
    public init(numberOfPointsInGrid: Int, useHundredPercentAccuracy: Bool) {
        self.numberOfPointsInGrid = numberOfPointsInGrid
        self.useHundredPercentAccuracy = useHundredPercentAccuracy
    }
    
    public func forEachPoint(
        imageSize: IntSize,
        loop: (_ x: Int, _ y: Int) -> ())
    {
        if imageSize.area <= numberOfPointsInGrid || useHundredPercentAccuracy {
            forEachPointOnImage(imageSize: imageSize, loop: loop)
        } else {
            forEachPointOnGrid(imageSize: imageSize, loop: loop)
        }
    }
    
    private func forEachPointOnImage(
        imageSize: IntSize,
        loop: (_ x: Int, _ y: Int) -> ())
    {
        // There was a note in EarlGrey about data locality,
        // I didn't check it on current code, but still I use rows first:
        for y in 0..<imageSize.height {
            for x in 0..<imageSize.width {
                loop(x, y)
            }
        }
    }
    
    private func forEachPointOnGrid(
        imageSize: IntSize,
        loop: (_ x: Int, _ y: Int) -> ())
    {
        let floatImageSize = CGSize(
            width: imageSize.width,
            height: imageSize.height
        )
        let gridSize = self.gridSize(imageSize: floatImageSize)
        let floatGridDelta = CGVector(
            dx: floatImageSize.width / gridSize.width,
            dy: floatImageSize.height / gridSize.height
        )
        
        let initialOffsetsForLoops = self.initialOffsetsForLoops(imageSize: floatImageSize, gridSize: gridSize)
        
        var y = initialOffsetsForLoops.y
        while y < floatImageSize.height {
            var x = initialOffsetsForLoops.x
            
            while x < floatImageSize.width {
                loop(Int(x), Int(y))
                x += floatGridDelta.dx
            }
            
            y += floatGridDelta.dy
        }
    }
    
    private func gridSize(imageSize: CGSize) -> CGSize {
        // Example: given size (W: 5, H: 3) and N = 15
        // Return size that contain uniform grid of N points.
        //
        // This can reduce computations without affecting quality much.
        // It will lose some details, but in most cases the UI is not that detailed.
        //
        // v..v..v..v..v..
        // ...............
        // v..v..v..v..v..
        // ...............
        // v..v..v..v..v..
        // ...............
        //
        // N = X*Y (X points horizontally and Y vertically).
        // X/Y = W/H (to distribution to be uniform, nighboring dots will form perfect squares ideally).
        //
        // =>
        //
        // X=W/H*Y
        // Y=sqrt(N*H/W)
        //
        
        let y = sqrt(CGFloat(numberOfPointsInGrid) * imageSize.height / imageSize.width)
        let x = imageSize.width / imageSize.height * y
        
        return CGSize(
            width: x,
            height: y
        )
    }
    
    private func initialOffsetsForLoops(imageSize: CGSize, gridSize: CGSize) -> CGPoint {
        // <----W--->    <X>
        //
        // v....v....    ..........
        // ..........    ..........
        // ..........    ..v....v..
        // .......... => ..........
        // v....v.... => ..........
        // ..........    ..v....v..
        // ..........    ..........
        // ..........    ..........
        //
        // In this example X is a quarter of imageSize.width with gridSize.width == 2
        //
        // We want our grid to cover most of the view, so we want our points be centers in uniformly distributed
        // squares. So the central point represent square of pixels that will be checked (while checking only 1 pixel).
        //
        // So basically every corner of the square becomes it's center.
        
        return CGPoint(
            x: imageSize.width / gridSize.width / 2,
            y: imageSize.height / gridSize.height / 2
        )
    }
}

#endif
