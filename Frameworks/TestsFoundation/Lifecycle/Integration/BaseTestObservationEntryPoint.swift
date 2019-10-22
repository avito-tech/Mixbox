// USAGE: add to your Info.plist:
// key: "NSPrincipalClass"
// value: "PrincipalClass"
//
// ADD CODE:
//
//    import MixboxTestsFoundation
//
//    @objc(PrincipalClass)
//    final class TestObservationEntryPoint: BaseTestObservationEntryPoint {
//        override func main() {
//            startObservation(
//                testLifecycleManagers: [
//                    MyManager() // <- your TestLifecycleManager
//                ],
//                testLifecycleObservable: TestLifecycleObservableImpl() // <- optional
//            )
//        }
//    }
//
// --------------------------------------------------------------------------------------------------
//
// It was too hard to find a way to observe test bundle execution.
// I read documentation carefully and the only way I can find of using "Principal Class"
// is to setup hook in its constructor.
//
// I think it is not cool to do things in constructor.
// But documentation only says it calls constructor....
//
// Here's doc from https://developer.apple.com/documentation/xctest/xctestobservationcenter :
// > If an NSPrincipalClass key is declared in the test bundle's Info.plist file,
// > XCTest automatically creates a single instance of that class when the test bundle is loaded.
// > You can use this instance as a place to register observers or do other pretesting global setup
// > before testing for that bundle begins.
//
// Note also that we have NSPrincipalClass property set in Info.plist

import MixboxFoundation

open class BaseTestObservationEntryPoint: NSObject {
    private var testLifecycleManagers = [TestLifecycleManager]()
    private var testLifecycleObservable: TestLifecycleObservable?
    private let startObservingOnceToken = ThreadSafeOnceToken<Void>()
    
    // Entry point of Principal Class.
    // It is ugly. Use main() for entry point in your class.
    override public required init() {
        super.init()
        
        main()
    }
    
    open func main() {
        // To be overriden
    }
    
    public func startObservation(
        testLifecycleManagers: [TestLifecycleManager],
        testLifecycleObservable: TestLifecycleObservable = TestLifecycleObservableImpl())
    {
        _ = startObservingOnceToken.executeOnce {
            self.testLifecycleManagers = testLifecycleManagers
            self.testLifecycleObservable = testLifecycleObservable
            
            for manager in testLifecycleManagers {
                manager.startObserving(testLifecycleObservable: testLifecycleObservable)
            }
        }
    }
}
