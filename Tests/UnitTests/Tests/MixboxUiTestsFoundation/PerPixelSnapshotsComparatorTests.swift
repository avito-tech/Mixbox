import UIKit
import MixboxUiTestsFoundation
import MixboxFoundation
import XCTest

final class PerPixelSnapshotsComparatorTests: TestCase {
    private let comparator = PerPixelSnapshotsComparator()
    
    // color0 is also default
    private let color0 = UIColor(red: 5, green: 13, blue: 89, alpha: 233).cgColor
    private let color1 = UIColor(red: 21, green: 34, blue: 55, alpha: 144).cgColor
    
    // size0 is also default
    private let size0 = CGSize(width: 1, height: 2)
    private let size1 = CGSize(width: 3, height: 5)
    
    func test___compare___tells_images_are_similar___if_encoded_to_little_and_little_endian() {
        paramertized_test___compare___tells_images_are_similar___if_byte_orders_are_different(
            lhsByteOrder: .littleEndian,
            rhsByteOrder: .littleEndian
        )
    }
    
    func test___compare___tells_images_are_similar___if_encoded_to_little_and_big_endian() {
        paramertized_test___compare___tells_images_are_similar___if_byte_orders_are_different(
            lhsByteOrder: .littleEndian,
            rhsByteOrder: .bigEndian
        )
    }
    
    func test___compare___tells_images_are_similar___if_encoded_to_big_and_little_endian() {
        paramertized_test___compare___tells_images_are_similar___if_byte_orders_are_different(
            lhsByteOrder: .bigEndian,
            rhsByteOrder: .littleEndian
        )
    }
    
    func test___compare___tells_images_are_similar___if_encoded_to_big_and_big_endian() {
        paramertized_test___compare___tells_images_are_similar___if_byte_orders_are_different(
            lhsByteOrder: .bigEndian,
            rhsByteOrder: .bigEndian
        )
    }
    
    func test___compare___tells_images_are_different___if_sizes_are_different() {
        compareImages(
            lhsSize: size0,
            rhsSize: size1,
            resultHandler: { result in
                switch result {
                case .similar:
                    XCTFail("Images are expected to be different")
                case .different(let description):
                    XCTAssertEqual(
                        description.message,
                        """
                        Failed to compare images: Images have different frame: (0.0, 0.0, 1.0, 2.0) != (0.0, 0.0, 3.0, 5.0)
                        """
                    )
                    XCTAssertEqual(
                        description.percentageOfMatching,
                        0
                    )
                }
            }
        )
    }
    
    func test___compare___tells_images_are_different___if_pixels_are_different() {
        compareImages(
            lhsColor: color0,
            rhsColor: color1,
            resultHandler: { result in
                switch result {
                case .similar:
                    XCTFail("Images are expected to be different")
                case .different(let description):
                    XCTAssertEqual(
                        description.message,
                        """
                        Failed to compare images: Image has different pixels
                        """
                    )
                    XCTAssertEqual(
                        description.percentageOfMatching,
                        0
                    )
                }
            }
        )
    }
    
    private func paramertized_test___compare___tells_images_are_similar___if_byte_orders_are_different(
        lhsByteOrder: ByteOrder,
        rhsByteOrder: ByteOrder)
    {
        compareImages(
            lhsByteOrder: lhsByteOrder,
            rhsByteOrder: rhsByteOrder,
            resultHandler: { result in
                switch result {
                case .similar:
                    break
                case .different(let description):
                    XCTFail("Images are different. Underlying error: \(description.message)")
                }
            }
        )
    }
    
    private func compareImages(
        lhsByteOrder: ByteOrder? = nil,
        rhsByteOrder: ByteOrder? = nil,
        lhsSize: CGSize? = nil,
        rhsSize: CGSize? = nil,
        lhsColor: CGColor? = nil,
        rhsColor: CGColor? = nil,
        resultHandler: (SnapshotsComparisonResult) -> ())
    {
        let lhsSize = lhsSize ?? size0
        let rhsSize = rhsSize ?? size0
        let lhsColor = lhsColor ?? color0
        let rhsColor = rhsColor ?? color0
        
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
}
