import Foundation
import MixboxFoundation
import MixboxTestsFoundation

public protocol MockManagerVerification {
    func verify(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
}
