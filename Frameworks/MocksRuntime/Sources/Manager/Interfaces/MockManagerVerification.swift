import Foundation
import MixboxFoundation

public protocol MockManagerVerification {
    func verify<Arguments>(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        argumentsMatcher: FunctionalMatcher<Arguments>,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
}
