// I think it is this algorithm:
// http://www.hackerfactor.com/blog/index.php?/archives/432-Looks-Like-It.html
//
// I tried pHash/aHash/dHash/wavelet hash/simplified wavelet hash on screenshots of iOS app,
// it seems that pHash has bigger interval between similar screenshots and other screenshots.
//
// How I've got to this? Assume we have 17 similar screenshots (a0, a1, a2... a16) and tons of other screenshots (b1...b300),
// and "b" screenshots are sorted by hamming distance from a1. Meaning that b1 is more similar to a1 than b2.
//
//          | a     | p     | d     | w     | wdb4  |
//          +-------+-------+-------+-------+-------+
// a1       | 0     | 4     | 0     | 4     | 14    | <- distances from a1 for different hashes
// ...      |       |       |       |       |       |
// a16      | 5     | 12    | 22    | 15    | 84    |
// b1       | 8     | 26    | 28    | 14    | 78    |
// ...      |       |       |       |       |       |
//          +-------+-------+-------+-------+-------+
// m=max(b) | 50    | 40    | 41    | 48    | 118   |
// d=b1-a16 | 3     | 14    | 6     | -1    | -6    |
// a=d/m    | 0.06  | 0.35  | 0.146 | -0.02 | -0.05 |
//                    ^-(!)
//
// Distance from a16 and b1 is bigger for pHash (35% of whole range of differences).
//
// (also everybody tell that pHash is better)
//
// However, it is slower than aHash and dHash.
//
// WARNING! CocoaImageHashing produces bad pHash (espectially for low-detailed images, see
// https://github.com/ameingast/cocoaimagehashing/pull/13) so we are using dHash now. Also that library
// has other problems like failing tests on 32-bit machine and different hash values on different 64-bit devices.
//
// So we can not rely on compatibility of values between platforms. Quick check found that the only algorithm that
// produces same hashes on different platforms (32/64 bit iOS/OSX) is dHash.
//

import MixboxCocoaImageHashing
import UIKit
import MixboxFoundation

open class BaseCocoaImageHashingImageHashCalculator: ImageHashCalculator {
    private let osImageHashingProviderId: OSImageHashingProviderId
    
    public init(osImageHashingProviderId: OSImageHashingProviderId) {
        self.osImageHashingProviderId = osImageHashingProviderId
    }
    
    public func imageHash(image: UIImage) throws -> UInt64 {
        let hash = OSImageHashing.sharedInstance().hashImage(image, with: osImageHashingProviderId)
        
        if hash == OSHashTypeError {
            let defaultErrorMessage = "OSImageHashing returned OSHashTypeError"
            if image.pngData() == nil {
                throw ErrorString("\(defaultErrorMessage). Probable reason: UIImagePNGRepresentation is nil")
            } else {
                throw ErrorString(defaultErrorMessage)
            }
        }
        
        return UInt64(bitPattern: hash)
    }
    
    public func hashDistance(lhsHash: UInt64, rhsHash: UInt64) -> UInt8 {
        let hashDistance = OSImageHashing.sharedInstance().hashDistance(
            Int64(bitPattern: lhsHash),
            to: Int64(bitPattern: rhsHash),
            with: osImageHashingProviderId
        )
        
        // Actual range of the number is 0..64, so UInt will suit.
        return UInt8(hashDistance)
    }
}
