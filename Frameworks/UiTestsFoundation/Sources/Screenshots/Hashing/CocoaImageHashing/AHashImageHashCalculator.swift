import MixboxCocoaImageHashing

public final class AHashImageHashCalculator: BaseCocoaImageHashingImageHashCalculator {
    public init() {
        super.init(osImageHashingProviderId: .aHash)
    }
}
