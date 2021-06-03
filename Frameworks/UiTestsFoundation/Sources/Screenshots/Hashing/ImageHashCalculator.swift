import UIKit

public protocol ImageHashCalculator: class {
    func imageHash(image: UIImage) throws -> UInt64
    func hashDistance(lhsHash: UInt64, rhsHash: UInt64) -> UInt8
}
