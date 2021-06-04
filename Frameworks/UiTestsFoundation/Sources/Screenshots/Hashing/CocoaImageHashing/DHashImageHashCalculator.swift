import MixboxCocoaImageHashing

public final class DHashImageHashCalculator: BaseCocoaImageHashingImageHashCalculator {
    public init() {
        super.init(osImageHashingProviderId: .dHash)
    }
}
