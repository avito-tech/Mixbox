import MixboxCocoaImageHashing

public final class PHashImageHashCalculator: BaseCocoaImageHashingImageHashCalculator {
    public init() {
        super.init(osImageHashingProviderId: .pHash)
    }
}
