import UIKit
import MixboxTestsFoundation
import MixboxFoundation
import XCTest
@testable import MixboxUiTestsFoundation

// TODO: Split to separate files? (Low priority)
// swiftlint:disable file_length type_body_length
final class ImageHashCalculatorSnapshotsComparatorTests: BaseSnapshotsComparatorTestCase {
    private var hashDistanceTolerance: UInt8 = 10
    private var shouldIgnoreTransparency: Bool = true
    
    // Colors that are not same from the point of view of hashing algorithm
    private let oppositeOpaqueColors = (UIColor.red, UIColor.black)
    
    override var comparator: SnapshotsComparator {
        return ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: DHashImageHashCalculator(),
            hashDistanceTolerance: hashDistanceTolerance,
            shouldIgnoreTransparency: shouldIgnoreTransparency
        )
    }
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        continueAfterFailure = true
    }
    
    func test___compare___returns_error___if_hashDistanceTolerance_is_not_within_closed_range_from_0_to_64() {
        forAnyValueForShouldIgnoreTransparency {
            let dotImage = UnavoidableFailure.doOrFail {
                try UIImage.image(width: 1, height: 1, color: UIColor.red.cgColor)
            }
            let emptyImage = UIImage()
            
            let compareSimilarImages = {
                self.comparator.compare(actualImage: dotImage, expectedImage: dotImage)
            }
            let compareEmptyImages = {
                self.comparator.compare(actualImage: emptyImage, expectedImage: emptyImage)
            }
            
            for hashDistanceTolerance in UInt8.min...64 {
                self.hashDistanceTolerance = hashDistanceTolerance
                assertSimilar(snapshotsComparisonResult: compareSimilarImages())
                assertSimilar(snapshotsComparisonResult: compareEmptyImages())
            }

            for hashDistanceTolerance in 65...UInt8.max {
                self.hashDistanceTolerance = hashDistanceTolerance
                assertDifferent(snapshotsComparisonResult: compareSimilarImages()) { (snapshotsDifferenceDescription, _, _) in
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.message,
                        "hashDistanceTolerance (the argument of init of ImageHashCalculatorSnapshotsComparator) is set to an inappropriate value \(hashDistanceTolerance), it should be >= 0 and <= 64"
                    )
                }
                // This should fail either (I know that empty images are always similar regardless
                // of any settings of comparison, however, it's better to notify developer that he
                // made a mistake anyway):
                assertDifferent(snapshotsComparisonResult: compareEmptyImages())
            }
        }
    }
    
    func test___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar() {
        forAnyComparatorSettings {
            check___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar()
        }
    }
    
    func test___compare___tells_images_are_similar___if_sizes_are_different_for_visually_similar_images() {
        forAnyValueForShouldIgnoreTransparency {
            compareImages(
                lhsSize: CGSize(width: 1, height: 2),
                rhsSize: CGSize(width: 3, height: 5),
                resultHandler: { result in
                    assertSimilar(snapshotsComparisonResult: result) { _ in
                        """
                        Images of different size are NOT expected to be different if they \
                        are visually similar if ImageHashCalculatorSnapshotsComparator is used, \
                        because it should be tolerant to difference in sizes
                        """
                    }
                }
            )
        }
    }
    
    func test___compare___tells_images_are_similar___if_images_have_little_difference_in_color() {
        forAnyValueForShouldIgnoreTransparency {
            compareImages(
                lhsColor: UIColor(red: 2, green: 5, blue: 11, alpha: 241).cgColor,
                rhsColor: UIColor(red: 3, green: 7, blue: 13, alpha: 251).cgColor,
                resultHandler: { result in
                    assertSimilar(snapshotsComparisonResult: result) { _ in
                        """
                        Images of slightly different colors are NOT expected to be different if they \
                        are visually similar if ImageHashCalculatorSnapshotsComparator is used, \
                        because it should be tolerant to small difference in colors
                        """
                    }
                }
            )
        }
    }
    
    func test___compare___tells_images_are_similar___if_images_have_significant_difference_in_color_but_lack_features() {
        let resultHandler: (SnapshotsComparisonResult) -> () = { result in
            self.assertSimilar(snapshotsComparisonResult: result) { _ in
                """
                Images of different colors, even different brightness, are (unfortunately?) similar
                from a point of view of ImageHashCalculatorSnapshotsComparator. This is only the case \
                if those images lack features (like monotone images).
                """
            }
        }
        
        forAnyValueForShouldIgnoreTransparency {
            compareImages(
                lhsColor: UIColor.yellow.cgColor,
                rhsColor: UIColor.blue.cgColor,
                resultHandler: resultHandler
            )
            
            compareImages(
                lhsColor: UIColor.white.cgColor,
                rhsColor: UIColor.black.cgColor,
                resultHandler: resultHandler
            )
        }
    }
    
    func test___compare___tells_images_are_different___if_images_have_significant_difference_in_colors_and_do_not_lack_features() {
        // Both images in test are opaque, so `shouldIgnoreTransparency` doesn't matter here,
        // but we want to to check if this statement holds true.
        // Note that this test has failed once, so it's important.
        forAnyValueForShouldIgnoreTransparency {
            let actualImage = imageWithShape(
                backgroundColor: oppositeOpaqueColors.0,
                foregroundColor: oppositeOpaqueColors.1
            )
            let expectedImage = imageWithShape(
                backgroundColor: oppositeOpaqueColors.1,
                foregroundColor: oppositeOpaqueColors.0
            )
            let result = comparator.compare(
                actualImage: actualImage,
                expectedImage: expectedImage
            )
            assertDifferent(
                snapshotsComparisonResult: result,
                messageIfSimilar:
                """
                Images are expected to be different, but they are similar.
                shouldIgnoreTransparency: \(shouldIgnoreTransparency)
                """,
                additionalChecks: { (snapshotsDifferenceDescription, _, _) in
                    // TODO: Fix inconsistency.
                    // I have no idea why it is happening, I didn't debug it. Let it be it for now.
                    // But it's an indicator of some kind of issue. Maybe clipping inside `ImagesForHashingProvider`
                    // is too hard on edges (e.g. treats alpha discretely, as zeroes and ones).
                    
                    let percentageOfMatchingAndMessage = shouldIgnoreTransparency
                        ? (
                            0.3148148148148148,
                            "Actual hashDistance is below hashDistanceTolerance. hashDistance: (47). hashDistanceTolerance: (10). Image hash of actual image: 1110000000110000001100000011010000110000001100000110000010000000. Image hash of expected image: 1110000111110001111100011111100100111000001110000111000000100000."
                        )
                        : valuesByIosVersion(type: (Double, String).self)
                            .value((
                                0.25925925925925924,
                                "Actual hashDistance is below hashDistanceTolerance. hashDistance: (50). hashDistanceTolerance: (10). Image hash of actual image: 1110000111100001110010011111100011111000111110000111000001100000. Image hash of expected image: 1100000110000001100001011000000110000001100000001110000001100000."
                            ))
                            .since(ios: 15)
                            .value((
                                0.2777777777777778,
                                "Actual hashDistance is below hashDistanceTolerance. hashDistance: (49). hashDistanceTolerance: (10). Image hash of actual image: 1110000111000001110010011111100011111000111110000111000001100000. Image hash of expected image: 1100000110000001100001011000000110000001100000001110000001100000."
                            ))
                            .getValue()
                    
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.percentageOfMatching,
                        percentageOfMatchingAndMessage.0
                    )
                    XCTAssertEqual(
                        snapshotsDifferenceDescription.message,
                        percentageOfMatchingAndMessage.1
                    )
                }
            )
        }
    }
    
    func test___compare___tells_images_are_different___if_only_difference_is_transparency_of_pixels___and_shouldIgnoreTransparency_false() {
        shouldIgnoreTransparency = false
        
        iterateCombinations { isTransparent0, isTransparent1, isTransparent2, isTransparent3 in
            if isTransparent0 == isTransparent2 && isTransparent1 == isTransparent3 {
                // ignore 100% equal images. They will not be different.
                return
            }
            
            if isTransparent0 == isTransparent1 && isTransparent2 == isTransparent3 {
                // ignore monotone images, hashing doesn't work well with them even if
                // they are opposite.
                //
                // See:
                // `test___compare___tells_images_are_similar___if_images_have_significant_difference_in_color_but_lack_features`
                return
            }
            
            assertDoesntThrow {
                let actualImage = imageWithShape(
                    backgroundColor: color(isTransparent: isTransparent0),
                    foregroundColor: color(isTransparent: isTransparent1)
                )
                let expectedImage = imageWithShape(
                    backgroundColor: color(isTransparent: isTransparent2),
                    foregroundColor: color(isTransparent: isTransparent3)
                )
                let result = comparator.compare(
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
                
                assertDifferent(
                    snapshotsComparisonResult: result,
                    messageIfSimilar:
                    """
                    Transparent pixels should be ignored when images are compared.

                    Current combination: \([isTransparent0, isTransparent1, isTransparent2, isTransparent3])
                    """
                )
            }
        }
    }
    
    // swiftlint:disable:next function_body_length
    func test___compare___handles_transparency_properly_when_shouldIgnoreTransparency_true() {
        shouldIgnoreTransparency = true
        
        iterateCombinations { isTransparent0, isTransparent1, isTransparent2, isTransparent3 in
            if isTransparent0 == isTransparent2 && isTransparent1 == isTransparent3 {
                // ignore 100% equal images, no need to test it.
                return
            }
            
            // Uncomment this line to debug:
            let (isTransparent0, isTransparent1, isTransparent2, isTransparent3) = (true, true, false, false)
            
            let currentCombination = [isTransparent0, isTransparent1, isTransparent2, isTransparent3]
            
            // swiftlint:disable comma
            let isSimilarByCombination: [[Bool]: Bool] = [
                [ false , false , false , false ]:  true, // Identical images
                [ false , false , false , true  ]:  true, // Partially matching
                [ false , false , true  , false ]:  true, // Partially matching
                [ false , false , true  , true  ]:  true, // Empty expected image
                [ false , true  , false , false ]: false,
                [ false , true  , false , true  ]:  true, // Identical images
                [ false , true  , true  , false ]: false,
                [ false , true  , true  , true  ]:  true, // Empty expected image
                [ true  , false , false , false ]: false,
                [ true  , false , false , true  ]: false,
                [ true  , false , true  , false ]:  true, // Identical images
                [ true  , false , true  , true  ]:  true, // Empty expected image
                [ true  , true  , false , false ]:  true, // UNFORTUNATELY. Two monotone images are treated as equal.
                [ true  , true  , false , true  ]: false,
                [ true  , true  , true  , false ]: false,
                [ true  , true  , true  , true  ]:  true  // Identical images
            ]
            // swiftlint:enable comma
            
            assertDoesntThrow {
                let actualImage = imageWithShape(
                    backgroundColor: color(isTransparent: isTransparent0),
                    foregroundColor: color(isTransparent: isTransparent1)
                )
                let expectedImage = imageWithShape(
                    backgroundColor: color(isTransparent: isTransparent2),
                    foregroundColor: color(isTransparent: isTransparent3)
                )
                let result = comparator.compare(
                    actualImage: actualImage,
                    expectedImage: expectedImage
                )
                
                switch isSimilarByCombination[currentCombination] {
                case true?:
                    assertSimilar(snapshotsComparisonResult: result) { description in
                        """
                        Transparent pixels should be ignored when images are compared.

                        Message: \(description.message)
                        Percentage of matching: \(description.percentageOfMatching)
                        Current combination: \(currentCombination)
                        """
                    }
                case false?:
                    assertDifferent(
                        snapshotsComparisonResult: result,
                        messageIfSimilar:
                        """
                        Images are expected to be different.
                        
                        Current combination: \(currentCombination)
                        """
                    )
                default:
                    XCTFail("Missing case")
                }
                
            }
        }
    }
    
    // MARK: - Internal implementation tests
    
    func test___ImagesForHashingProvider___handles_images_of_different_sizes_properly() {
        let provider = ImageHashCalculatorSnapshotsComparator.ImagesForHashingProvider(
            shouldIgnoreTransparency: true
        )
        
        let opaqueImage = imageWithShape(
            backgroundColor: .red,
            foregroundColor: .green,
            width: 150,
            height: 300
        )
        
        let transparentImage = imageWithShape(
            backgroundColor: .clear,
            foregroundColor: .blue,
            width: 300,
            height: 150
        )
        
        assertDoesntThrow {
            let imagesForHashing = try provider.imagesForHashing(
                actualImage: opaqueImage,
                expectedImage: transparentImage
            )
            
            let opaqueImageMinusTransparentImage = imageWithShape(
                backgroundColor: .clear,
                foregroundColor: .green,
                width: 150,
                height: 300
            )
            
            // Ii will not be 100% similar in this test due to antialiasing or something like that.
            XCTAssertEqual(
                percentageOfSamePixels(lhs: imagesForHashing.actualImage, rhs: opaqueImageMinusTransparentImage),
                0.9999777777777777,
                accuracy: 0.00001
            )
            
            XCTAssertEqual(
                percentageOfSamePixels(lhs: imagesForHashing.expectedImage, rhs: transparentImage),
                0.9999777777777777,
                accuracy: 0.00001
            )
        }
    }
    
    func test___ImagesForHashingProvider___doesnt_change_opaque_images() {
        let provider = ImageHashCalculatorSnapshotsComparator.ImagesForHashingProvider(
            shouldIgnoreTransparency: true
        )
        
        let image = self.image(name: "imagehash_cats/imagehash_cat_original")
        
        assertDoesntThrow {
            let imagesForHashing = try provider.imagesForHashing(actualImage: image, expectedImage: image)
            
            XCTAssertEqual(
                percentageOfSamePixels(lhs: imagesForHashing.expectedImage, rhs: image),
                1
            )
            
            XCTAssertEqual(
                percentageOfSamePixels(lhs: imagesForHashing.expectedImage, rhs: image),
                1
            )
        }
    }
    
    private func percentageOfSamePixels(lhs: UIImage, rhs: UIImage) -> Double {
        let comparator = PerPixelSnapshotsComparator(
            tolerance: 0,
            forceUsingNonDiscretePercentageOfMatching: true
        )
        
        let result = comparator.compare(actualImage: lhs, expectedImage: rhs)
        
        switch result {
        case .similar:
            return 1
        case .different(let snapshotsDifferenceDescription):
            return snapshotsDifferenceDescription.percentageOfMatching
        }
    }
    
    // MARK: - Health-check
    
    func test___this_test_imageWithShape___generates_images_with_usable_hashes() {
        // This checks that test works as intended:
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: oppositeOpaqueColors.0,
            color1: oppositeOpaqueColors.1,
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: color(isTransparent: false),
            color1: color(isTransparent: true),
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        
        // This is for you to know:
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: UIColor.red,
            color1: UIColor.clear,
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: UIColor.green,
            color1: UIColor.clear,
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: UIColor.blue,
            color1: UIColor.clear,
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: UIColor.white,
            color1: UIColor.clear,
            hashDistance: valuesByIosVersion()
                .value(50).since(ios: 15).value(49)
        )
        check___this_test_imageWithShape___generates_images_with_usable_hashes(
            color0: UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1),
            color1: UIColor(red: 0, green: 0, blue: 0.2, alpha: 1),
            hashDistance: valuesByIosVersion()
                .value(58).since(ios: 15).value(57)
        )
        
        // Example of which colors aren't suitable.
        // Clear color is treated as black color (or almost as black color).
        //
        // check___this_test_imageWithShape___generates_images_with_usable_hashes(
        //     color0: UIColor.black,
        //     color1: UIColor.clear
        // )
    }
    
    func check___this_test_imageWithShape___generates_images_with_usable_hashes(
        color0: UIColor,
        color1: UIColor,
        hashDistance: ValuesByIosVersion<UInt8>)
    {
        let hashDistance = hashDistance.getValue()
        let calculator = DHashImageHashCalculator()
        let image0 = imageWithShape(
            backgroundColor: color0,
            foregroundColor: color1
        )
        assertDoesntThrow {
            let hash0 = try calculator.imageHash(
                image: image0
            )
            
            // Images with simple shapes produce unuseful hashes.
            // Hashing algorithm is not perfect for simple shapes (hash is limited to 64 bit).
            // Maybe it was coloring issue, see below.
            XCTAssertNotEqual(hash0, 0)
            
            let image1 = imageWithShape(
                backgroundColor: color1,
                foregroundColor: color0
            )
            let hash1 = try calculator.imageHash(
                image: image1
            )
            
            // Chosen colors should result in different colors if they are alternated
            // in making different image. Tests show that hashing algorithm ignores color
            // and uses brightness. Almost. It still produces different hashes for different
            // colors.
            XCTAssertNotEqual(hash0, hash1)
            
            XCTAssertEqual(
                calculator.hashDistance(lhsHash: hash0, rhsHash: hash1),
                hashDistance
            )
        }
    }
    
    // MARK: - Private
    
    // Draws shape with `foregroundColor` on a background with `backgroundColor`.
    // It has to be nontrivial shape for whatever reason (this is how hashing algorithm works,
    // it uses Fourier transformations or something, so it an ignore simple features).
    private func imageWithShape(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        width: Int = 150,
        height: Int = 150)
        -> UIImage
    {
        UnavoidableFailure.doOrFail {
            try UIImage.image(width: width, height: height) { (context, frame) in
                context.setFillColor(backgroundColor.cgColor)
                context.fill(frame)
                
                let width = CGFloat(width)
                let height = CGFloat(height)
                let offsetRatio: CGFloat = 0.02
                let offsetX: CGFloat = offsetRatio * width
                let offsetY: CGFloat = offsetRatio * height
                
                let ellipseSideX: CGFloat = width - offsetX * 3
                let ellipseSideY: CGFloat = height - offsetY * 3
                
                let frameForBgEllipses = CGRect(
                    x: offsetX,
                    y: offsetY,
                    width: ellipseSideX,
                    height: ellipseSideY
                )
                let frameForFgEllipses = CGRect(
                    x: offsetX * 2,
                    y: offsetY * 2,
                    width: ellipseSideX,
                    height: ellipseSideY
                )
                
                context.setBlendMode(.copy)
                
                for level in (1...9).reversed() {
                    var currentHoleFrame = frameForFgEllipses.mb_scaleAndTranslate(
                        amount: CGFloat(level) / 10.0
                    )
                    currentHoleFrame.mb_center = frameForFgEllipses.mb_center
                    
                    // Cut hole
                    context.setFillColor(foregroundColor.cgColor)
                    context.fillEllipse(in: currentHoleFrame)
                    
                    var currentCircleFrame = frameForBgEllipses.mb_scaleAndTranslate(
                        amount: (CGFloat(level) - 0.5) / 10.0
                    )
                    currentCircleFrame.mb_center = frameForBgEllipses.mb_center
                    
                    // Fill
                    context.setFillColor(backgroundColor.cgColor)
                    context.fillEllipse(in: currentCircleFrame)
                }
            }
        }
    }
    
    private func forAnyComparatorSettings(body: () -> ()) {
        forAnyValueForShouldIgnoreTransparency {
            forAnyValueForHashDistanceTolerance {
                body()
            }
        }
    }
    private func forAnyValueForShouldIgnoreTransparency(body: () -> ()) {
        for shouldIgnoreTransparency in [false, true] {
            self.shouldIgnoreTransparency = shouldIgnoreTransparency
            
            body()
        }
    }
    
    private func forAnyValueForHashDistanceTolerance(body: () -> ()) {
        let cornerCaseHashDistanceTolerances: [UInt8] = [0, 10, 64]
        
        for hashDistanceTolerance in cornerCaseHashDistanceTolerances {
            self.hashDistanceTolerance = hashDistanceTolerance
            
            body()
        }
    }
    
    private func iterateCombinations(body: (Bool, Bool, Bool, Bool) -> ()) {
        let booleans = [false, true]
        
        for x in booleans {
            for y in booleans {
                for z in booleans {
                    for w in booleans {
                        body(x, y, z, w)
                    }
                }
            }
        }
    }
    
    private func color(isTransparent: Bool) -> UIColor {
        let transparentColor = UIColor.clear
        let opaqueColor = UIColor.red
        
        return isTransparent
            ? transparentColor
            : opaqueColor
    }
}
