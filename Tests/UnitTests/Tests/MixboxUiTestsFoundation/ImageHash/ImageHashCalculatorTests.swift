import XCTest
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

class ImageHashCalculatorTests: TestCase {
    private let calculator = DHashImageHashCalculator()
    
    func test___imageHash___throws_error___for_empty_image() {
        // In addition to this error, there is also another line of code
        // inside "OSImageHashing" that returns "OSHashTypeError".
        // That case is hard to reproduce. This error will not be classified and `imageHash` will
        // just return "OSImageHashing returned OSHashTypeError".
        assertThrows(error: "OSImageHashing returned OSHashTypeError. Probable reason: UIImagePNGRepresentation is nil") {
            _ = try calculator.imageHash(image: UIImage())
        }
    }
    
    // Unfortunately, CocoaImageHashing doesn't make constant hashes for constant images on
    // different iOS versions.
    // swiftlint:disable:next function_body_length
    func test___imageHash___is_deterministic() {
        continueAfterFailure = true
        
        check(
            image: "size",
            expectedHash: valuesByIosVersion()
                .value(2170628984350433018)
                .since(ios: 12, 1)
                .value(2170628984349908730)
        )
        check(
            image: "text",
            expectedHash: valuesByIosVersion()
                .value(10817540268901261050)
                .since(ios: 12, 1)
                .value(10817540268901785338)
                .since(ios: 15)
                .value(10817540268901195514)
        )
        check(
            image: "color",
            expectedHash: valuesByIosVersion()
                .value(2170628984358756090)
                .since(ios: 15)
                .value(2170628984358231802)
        )
        check(
            image: "original",
            expectedHash: valuesByIosVersion()
                .value(2170628984349908730)
                .since(ios: 12, 1)
                .value(2170628984350433018)
                .since(ios: 15)
                .value(2170628984349843194)
        )
        check(
            image: "aspect",
            expectedHash: valuesByIosVersion()
                .value(1012762419733077534)
        )
        check(
            image: "borders",
            expectedHash: valuesByIosVersion()
                .value(3956103203127296)
        )
        check(
            image: "not_cat",
            expectedHash: valuesByIosVersion()
                .value(16564758914714907379)
        )
        check(
            image: "lots_of_text",
            expectedHash: valuesByIosVersion()
                .value(10817599643728672504)
        )
    }
    
    private func check(
        image imageName: String,
        expectedHash: ValuesByIosVersion<UInt64>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedHash = expectedHash.getValue()
        
        let image = UIImage(
            named: "imagehash_cats/imagehash_cat_\(imageName)",
            in: Bundle(for: type(of: self)),
            compatibleWith: nil
        ).unwrapOrFail()
        
        let actualHash = UnavoidableFailure.doOrFail {
            try calculator.imageHash(image: image)
        }
        
        let iosVersion = iosVersionProvider.iosVersion()
        
        XCTAssertEqual(
            actualHash,
            expectedHash,
            "Hash \(actualHash) is not equal to expected hash \(expectedHash) for image \(imageName) and iOS version \(iosVersion)",
            file: file,
            line: line
        )
    }
}
