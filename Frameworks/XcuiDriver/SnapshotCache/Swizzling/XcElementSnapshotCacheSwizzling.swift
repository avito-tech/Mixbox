import MixboxFoundation

final class XcElementSnapshotCacheSwizzling {
    private let swizzlings: [Swizzling]
    private let swizzler = AssertingSwizzler()
    private let once = OnceToken()
    
    static let instance = XcElementSnapshotCacheSwizzling()
    
    private init() {
        self.swizzlings = [
            SwizzlingOfXCTElementQueryForUsingCache(swizzler: swizzler),
            SwizzlingOfXCUIElementForDroppingCache(swizzler: swizzler),
            SwizzlingOfXCUICoordinateForDroppingCache(swizzler: swizzler),
            SwizzlingOfXCTContextForOmittingWaitingAppForIdle(swizzler: swizzler)
        ]
    }
    
    func swizzleOnce() {
        once.executeOnce {
            swizzlings.forEach { $0.swizzle() }
        }
    }
}
