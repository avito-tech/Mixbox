import MixboxTestsFoundation
import Foundation
import UIKit
// Temporary stubs that help to commit code.
// TODO: Remove.

public func grayNotImplemented(function: StaticString = #function) -> Never {
    UnavoidableFailure.fail("Not implemented. Function: \(function)")
}

public func assertIsOnMainThread() {
    assert(Thread.isMainThread)
}
