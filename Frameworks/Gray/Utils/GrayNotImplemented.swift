import MixboxTestsFoundation

public func grayNotImplemented(function: StaticString = #function) -> Never {
    UnavoidableFailure.fail("Not implemented. Function: \(function)")
}

public func assertIsOnMainThread() {
    assert(Thread.isMainThread)
}
