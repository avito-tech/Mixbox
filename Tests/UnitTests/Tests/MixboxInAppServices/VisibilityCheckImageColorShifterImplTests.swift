import MixboxInAppServices
import XCTest

// swiftlint:disable comma function_body_length
final class VisibilityCheckImageColorShifterImplTests: TestCase {
    private let visibilityCheckForLoopOptimizer = VisibilityCheckForLoopOptimizerImpl(
        numberOfPointsInGrid: 0, // doesn't really matter because of `useHundredPercentAccuracy: true`
        useHundredPercentAccuracy: true
    )
    private let shifter = VisibilityCheckImageColorShifterImpl()
    
    func test___with_target_point() {
        parameterized_test(targetPixelOfInteraction: IntPoint(x: 1, y: 1))
    }
    
    func test___without_target_point() {
        parameterized_test(targetPixelOfInteraction: nil)
    }
    
    private func parameterized_test(
        targetPixelOfInteraction: IntPoint?,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let bytesPerPixel = 4
        
        let imagePixelBuffer = UnsafeArray<UInt8>.fromArray([
            // <- pixel ->  <--- pixel ---> <--- pixel --->
            1,   2,  3,  4, 11, 12, 13, 14, 21, 22, 23, 24,
            31, 32, 33, 34, 41, 42, 43, 44, 51, 52, 53, 54,
            61, 62, 63, 64, 71, 72, 73, 74, 81, 82, 83, 84
        ])
        
        let imagePixelData = ImagePixelData(
            imagePixelBuffer: imagePixelBuffer,
            bytesPerPixel: bytesPerPixel,
            size: IntSize(width: 3, height: 3)
        )
        
        let shiftedPixelData = shifter.imagePixelDataWithShiftedColors(
            imagePixelData: imagePixelData,
            targetPixelOfInteraction: targetPixelOfInteraction,
            visibilityCheckForLoopOptimizer: visibilityCheckForLoopOptimizer
        )
        
        // If value < 10 it is incremented by 10, else it is decremented by 10.
        // X component in XRGB is not shifted
        let expectedPixelData = [
            1,  12, 13, 14, 11,  2,  3,  4, 21, 12, 13, 14,
            31, 22, 23, 24, 41, 32, 33, 34, 51, 42, 43, 44,
            61, 52, 53, 54, 71, 62, 63, 64, 81, 72, 73, 74
        ] as [UInt8]
        
        for byteIndex in 0..<imagePixelBuffer.count {
            let source = imagePixelBuffer[byteIndex]
            let shifted = shiftedPixelData.imagePixelBuffer[byteIndex]
            let expected = expectedPixelData[byteIndex]
            
            let componentNames = ["X", "R", "G", "B"]
            let componentIndex = byteIndex % bytesPerPixel
            let component = componentNames[componentIndex]
            
            let pixelIndex = byteIndex / bytesPerPixel
            
            // X component is not shifted
            if componentIndex != 0 {
                XCTAssertNotEqual(
                    source,
                    shifted,
                    """
                    Pixel at index \(pixelIndex) was not shifted. \
                    Byte index: \(byteIndex), component: \(component).
                    """,
                    file: file,
                    line: line
                )
            }
            
            XCTAssertEqual(
                shifted,
                expected,
                """
                Pixel index \(pixelIndex) doesn't equal expected value: \
                \(shifted) != \(expected) \
                Byte index: \(byteIndex), component: \(component), source pixel: \(source).
                """,
                file: file,
                line: line
            )
        }
    }
}
