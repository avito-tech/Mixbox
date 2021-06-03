import UIKit
import MixboxTestsFoundation
import MixboxUiTestsFoundation

class BaseSnapshotsComparatorTestCase: TestCase {
    var comparator: SnapshotsComparator {
        // TODO: Share this code and find all similar code and replace it with shared function.
        UnavoidableFailure.fail("\(#function) is not implemented")
    }
        
    private let defaultColor = UIColor(red: 5, green: 13, blue: 89, alpha: 233).cgColor
    private let defaultSize = CGSize(width: 1, height: 2)
    
    func check___compare___tells_images_are_similar___if_only_unrelated_image_settings_are_different_or_similar(
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        func iterateCombinations(body: (ByteOrder, ByteOrder) -> ()) {
            let byteOrders: [ByteOrder] = [.littleEndian, .bigEndian]
            
            for x in byteOrders {
                for y in byteOrders {
                    body(x, y)
                }
            }
        }
        
        iterateCombinations { lhsByteOrder, rhsByteOrder in
            compareImages(
                lhsByteOrder: lhsByteOrder,
                rhsByteOrder: rhsByteOrder,
                file: file,
                line: line,
                resultHandler: { result in
                    assertSimilar(snapshotsComparisonResult: result) { description in
                        "Images are different. Underlying error: \(description.message)"
                    }
                }
            )
        }
    }
    
    func check___compare___tells_images_are_similar(
        lhsByteOrder: ByteOrder,
        rhsByteOrder: ByteOrder,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        compareImages(
            lhsByteOrder: lhsByteOrder,
            rhsByteOrder: rhsByteOrder,
            file: file,
            line: line,
            resultHandler: { result in
                assertSimilar(snapshotsComparisonResult: result) { description in
                    "Images are different. Underlying error: \(description.message)"
                }
            }
        )
    }
    
    func compareImages(
        lhsByteOrder: ByteOrder? = nil,
        rhsByteOrder: ByteOrder? = nil,
        lhsSize: CGSize? = nil,
        rhsSize: CGSize? = nil,
        lhsColor: CGColor? = nil,
        rhsColor: CGColor? = nil,
        file: StaticString = #filePath,
        line: UInt = #line,
        resultHandler: (SnapshotsComparisonResult) -> ())
    {
        let lhsSize = lhsSize ?? defaultSize
        let rhsSize = rhsSize ?? defaultSize
        let lhsColor = lhsColor ?? defaultColor
        let rhsColor = rhsColor ?? defaultColor
        
        assertDoesntThrow {
            let result = comparator.compare(
                actualImage: try .image(
                    width: Int(lhsSize.width),
                    height: Int(lhsSize.height),
                    color: lhsColor,
                    byteOrder: lhsByteOrder
                ),
                expectedImage: try .image(
                    width: Int(rhsSize.width),
                    height: Int(rhsSize.height),
                    color: rhsColor,
                    byteOrder: rhsByteOrder
                )
            )
            
            resultHandler(result)
        }
    }
    
    func assertSimilar(
        snapshotsComparisonResult: SnapshotsComparisonResult,
        file: StaticString = #filePath,
        line: UInt = #line,
        failureDescription: (SnapshotsDifferenceDescription) -> String = { _ in "Images are expected to be similar" })
    {
        switch snapshotsComparisonResult {
        case .similar:
            break
        case .different(let snapshotsDifferenceDescription):
            XCTFail(failureDescription(snapshotsDifferenceDescription), file: file, line: line)
        }
    }
    
    func assertDifferent(
        snapshotsComparisonResult: SnapshotsComparisonResult,
        messageIfSimilar: @autoclosure () -> String = "Images are expected to be different",
        file: StaticString = #filePath,
        line: UInt = #line,
        additionalChecks: (SnapshotsDifferenceDescription, StaticString, UInt) -> () = { (_, _, _) in })
    {
        switch snapshotsComparisonResult {
        case .similar:
            XCTFail(messageIfSimilar(), file: file, line: line)
        case .different(let snapshotsDifferenceDescription):
            additionalChecks(snapshotsDifferenceDescription, file, line)
        }
    }
}
