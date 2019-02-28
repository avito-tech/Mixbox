import XCTest
import MixboxFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

class ImageHashCalculatorTests: XCTestCase {
    // Unfortunately, CocoaImageHashing doesn't make constant hashes for constant images on
    // different iOS versions.
    func test_hashes_should_be_always_same() {
        let calculator = DHashV0ImageHashCalculator()
        
        let images = ["size", "text", "color", "original", "aspect", "borders", "not_cat"].map {
            UIImage(named: "imagehash_cat_\($0)", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        }
        
        let hashes = images.map {
            calculator.imageHash(image: $0)
        }
        let expectedHashesForIosLesserOrEqual120: [UInt64] = [
            2170628984350433018,
            10817540268901261050,
            2170628984358756090,
            2170628984349908730,
            1012762419733077534,
            3956103203127296,
            16564758914714907379
        ]
        
        let expectedHashesForIosGreaterOrEqual121: [UInt64] = [
            2170628984349908730,
            10817540268901785338,
            2170628984358756090,
            2170628984350433018,
            1012762419733077534,
            3956103203127296,
            16564758914714907379
        ]
        
        if UIDevice.current.mb_iosVersion >= 12.1 {
            XCTAssertEqual(hashes, expectedHashesForIosGreaterOrEqual121)
        } else {
            XCTAssertEqual(hashes, expectedHashesForIosLesserOrEqual120)
        }
        
    }
}
