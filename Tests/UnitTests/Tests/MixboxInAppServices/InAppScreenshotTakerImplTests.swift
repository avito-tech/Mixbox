import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxGray
import MixboxUiKit
import XCTest
import MixboxInAppServices

final class InAppScreenshotTakerImplTests {
    class FakeScreenInContextDrawer: ScreenInContextDrawer {
        static let numberOfPixels = 16 // (width * scale) * (height * scale) == 2*2*2*2 == 16
        static let expectedPixel: [UInt8] = [255, 0, 255, 0] // XRGB, green
        static let expectedData = Array(Array(repeating: expectedPixel, count: numberOfPixels).joined())
        
        static let frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        
        func screenBounds() -> CGRect {
            return Self.frame
        }
        
        func screenScale() -> CGFloat {
            return 2
        }
        
        func drawScreen(context: CGContext, afterScreenUpdates: Bool) {
            let view = UIView()
            view.frame = Self.frame
            view.backgroundColor = .green
            view.drawHierarchy(
                in: screenBounds() * screenScale(),
                afterScreenUpdates: true
            )
        }
    }
    
    func test() {
        let inAppScreenshotTaker = InAppScreenshotTakerImpl(
            screenInContextDrawer: FakeScreenInContextDrawer()
        )
        
        let screenshot = UnavoidableFailure.doOrFail {
            try inAppScreenshotTaker.takeScreenshot(afterScreenUpdates: true)
        }
        
        let image = screenshot.cgImage.unwrapOrFail()
        
        do {
            let imagePixelDataFromImageCreator = ImagePixelDataFromImageCreatorImpl()
            
            let data = try imagePixelDataFromImageCreator.createImagePixelData(image: image)
        
            let dataAsArray = data.imagePixelBuffer.toArray()
            
            XCTAssertEqual(dataAsArray.count, FakeScreenInContextDrawer.expectedData.count)
            XCTAssertEqual(dataAsArray, FakeScreenInContextDrawer.expectedData)
        } catch {
            XCTFail("\(error)")
        }
    }
}
