import Foundation
import MixboxInAppServices
import XCTest

final class ImagePixelDataTests: TestCase {
    private let object = NSObject()
    private let tracker = IdlingResourceObjectTracker()
    
    func test___copy() {
        let valueBefore: UInt8 = 42
        let valueAfter: UInt8 = 43
        
        let imagePixelData = ImagePixelData(
            imagePixelBuffer: UnsafeArray<UInt8>(count: 8),
            bytesPerPixel: 2,
            size: IntSize(width: 2, height: 2)
        )
        
        imagePixelData.imagePixelBuffer[0] = valueBefore
        
        XCTAssertEqual(imagePixelData.imagePixelBuffer[0], valueBefore)
        
        // When copy is made
        let copy = imagePixelData.copy()
        
        // It has same properties
        XCTAssertEqual(copy.imagePixelBuffer[0], valueBefore)
        XCTAssertEqual(copy.bytesPerPixel, 2)
        XCTAssertEqual(copy.size, IntSize(width: 2, height: 2))
        
        // When copy is changed
        copy.imagePixelBuffer[0] = valueAfter
        
        // Original is not changed
        XCTAssertEqual(imagePixelData.imagePixelBuffer[0], valueBefore)
        
        // But copy is
        XCTAssertEqual(copy.imagePixelBuffer[0], valueAfter)
    }
    
    func test___cropped() {
        //
        // bytesPerPixel: 4
        // size: 4*4
        // (total bytes = 4*4*4 = 64)
        //
        //   0   1   2   3
        // 0 ................      0   1
        // 1 ....XXXXXXXX.... => 0 ........
        // 2 ....XXXXXXXX.... => 1 ........
        // 3 ................
        //
        let imagePixelData = ImagePixelData(
            imagePixelBuffer: UnsafeArray<UInt8>(count: 64),
            bytesPerPixel: 4,
            size: IntSize(width: 4, height: 4)
        )
        
        for i in 0..<64 {
            imagePixelData.imagePixelBuffer[i] = UInt8(i)
        }
        
        let cropped = imagePixelData.cropped(
            rect: IntRect(
                origin: IntPoint(x: 1, y: 1),
                size: IntSize(width: 2, height: 2)
            )
        )
        
        let bytes = (0..<16).map { Int(cropped.imagePixelBuffer[$0]) }
        
        XCTAssertEqual(
            bytes,
            [
                /*  0,  1,  2,  3,    4,  5,  6,  7,  8,  9, 10, 11,    12, 13, 14, 15 */
                /* 16, 17, 18, 19 */ 20, 21, 22, 23, 24, 25, 26, 27, /* 28, 29, 30, 31 */
                /* 32, 33, 34, 35 */ 36, 37, 38, 39, 40, 41, 42, 43
            ]
        )
    }
}
