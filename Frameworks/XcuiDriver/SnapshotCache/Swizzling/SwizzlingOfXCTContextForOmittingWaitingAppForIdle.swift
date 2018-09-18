import MixboxFoundation
import MixboxTestsFoundation

// swiftlint:disable missing_spaces_after_colon

final class SwizzlingOfXCTContextForOmittingWaitingAppForIdle: Swizzling {
    private let swizzler: AssertingSwizzler
    
    init(swizzler: AssertingSwizzler) {
        self.swizzler = swizzler
    }
    
    func swizzle() {
        swizzler.swizzle(
            XCTContext.self,
            Selector(("_runActivityNamed:type:block:")),
            #selector(XCTContext.swizzled_runActivityNamed(_:_:_:)),
            .instanceMethod
        )
    }
}

private extension XCTContext {
    @objc(swizzled_runActivityNamed:type:block:)
    func swizzled_runActivityNamed(_ name: String?, _ type: Any, _ block: Any) {
        if let name = name, name.starts(with: "Wait for"), name.contains(" to idle") {
            return
        }
        
        return swizzled_runActivityNamed(name, type, block)
    }
}
