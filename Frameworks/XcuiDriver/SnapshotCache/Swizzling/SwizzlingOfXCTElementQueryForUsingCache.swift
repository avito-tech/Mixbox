import MixboxFoundation
import MixboxTestsFoundation

// swiftlint:disable missing_spaces_after_colon

final class SwizzlingOfXCTElementQueryForUsingCache: Swizzling {
    private let swizzler: AssertingSwizzler
    
    init(swizzler: AssertingSwizzler) {
        self.swizzler = swizzler
    }
    
    func swizzle() {
        swizzler.swizzle(
            NSClassFromString("XCTElementQuery").flatMap { $0 as? NSObject.Type }!,
            Selector(("_rootElementSnapshot:")),
            #selector(NSObject.swizzled_rootElementSnapshot(_:)),
            .instanceMethod
        )
    }
    
    // The idea was to find a function in stacktrace that fetches hierarchy and cache its return value.
    //
    // Example of stacktrace:
    //
    //     #0    0x000000010609d20a in mach_msg_trap ()
    //     #1    0x000000010609c724 in mach_msg ()
    //     #2    0x00000001013b17d5 in __CFRunLoopServiceMachPort ()
    //     #3    0x00000001013b0c19 in __CFRunLoopRun ()
    //     #4    0x00000001013b030b in CFRunLoopRunSpecific ()
    //     #5    0x000000010039b03a in -[XCTWaiter waitForExpectations:timeout:enforceOrder:] ()
    //     #6    0x0000000100335b09 in -[XCTFutureResult _waitForFulfillment] ()
    //     #7    0x0000000100336335 in -[XCTFutureResult error] ()
    //     #8    0x0000000100366c96 in -[XCAXClient_iOS snapshotForElement:attributes:parameters:error:] ()
    //     #9    0x00000001003a4a89 in -[XCUIElementQuery snapshotForElement:attributes:parameters:error:] ()
    //     #10    0x00000001050cb577 in __45-[XCTElementQuery _snapshotForElement:error:]_block_invoke ()
    //     #11    0x00000001003ac98d in -[XCTContext _runActivityNamed:type:block:] ()
    //     #12    0x000000010034e518 in -[XCTestCase startActivityWithTitle:type:block:] ()
    //     #13    0x000000010034e6f5 in -[XCTestCase startActivityWithTitle:block:] ()
    //     #14    0x00000001003a44fa in __68-[XCUIElementQuery matchingSnapshotsForLocallyEvaluatedQuery:error:]_block_invoke ()
    //     #15    0x00000001050cb356 in -[XCTElementQuery _snapshotForElement:error:] ()
    //     #16    0x00000001050cb06f in -[XCTElementQuery _rootElementSnapshot:] ()
    //     #17    0x00000001050cb6cd in -[XCTElementQuery matchingSnapshotsWithRelatedElements:error:] ()
    //     #18    0x00000001003a4340 in -[XCUIElementQuery matchingSnapshotsForLocallyEvaluatedQuery:error:] ()
    //     #19    0x00000001003a41b3 in -[XCUIElementQuery matchingSnapshotsWithError:] ()
    //     #20    0x0000000100383da5 in -[XCUIElement exists] ()
}

private extension NSObject {
    @objc(swizzled_rootElementSnapshot:)
    func swizzled_rootElementSnapshot(_ unknown: UnsafeMutablePointer<AnyObject>) -> XCElementSnapshot? {
        return XcElementSnapshotCacheSyncronizationImpl.instance.rootElementSnapshot {
            swizzled_rootElementSnapshot(unknown)
        }
    }
}
