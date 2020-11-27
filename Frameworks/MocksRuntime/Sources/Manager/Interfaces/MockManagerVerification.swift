import Foundation
import MixboxFoundation

public protocol MockManagerVerification {
    func verify(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
}
