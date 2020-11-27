public final class TimesMethodWasCalledMatcher {
    private let name: String
    private let matchingFunction: (Int) -> TimesMethodWasCalledMatchingResult
    
    public init(
        name: String,
        matchingFunction: @escaping (Int) -> TimesMethodWasCalledMatchingResult)
    {
        self.name = name
        self.matchingFunction = matchingFunction
    }
    
    public func match(
        timesMethodIsCalled: Int)
        -> TimesMethodWasCalledMatchingResult
    {
        return matchingFunction(timesMethodIsCalled)
    }
    
    public func valueIsMatching(
        timesMethodIsCalled: Int)
        -> Bool
    {
        switch match(timesMethodIsCalled: timesMethodIsCalled) {
        case .match:
            return true
        case .mismatch:
            return false
        }
    }
    
    // MARK: - Sugar
    
    public static func never()
        -> TimesMethodWasCalledMatcher
    {
        return exactly(0)
    }
    
    public static func atLeastOnce()
        -> TimesMethodWasCalledMatcher
    {
        return atLeast(1)
    }
    
    public static func exactlyOnce()
        -> TimesMethodWasCalledMatcher
    {
        return exactly(1)
    }
    
    public static func atLeast(
        _ expectedTimesMethodIsCalled: Int)
        -> TimesMethodWasCalledMatcher
    {
        return Self(name: "atLeast(\(expectedTimesMethodIsCalled))") { actualTimesMethodIsCalled in
            if actualTimesMethodIsCalled < expectedTimesMethodIsCalled {
                return .mismatch(matchIsPossibleLater: true)
            } else {
                return .match
            }
        }
    }
    
    public static func exactly(
        _ expectedTimesMethodIsCalled: Int)
        -> TimesMethodWasCalledMatcher
    {
        return Self(name: "exactly(\(expectedTimesMethodIsCalled))") { actualTimesMethodIsCalled in
            if actualTimesMethodIsCalled < expectedTimesMethodIsCalled {
                return .mismatch(matchIsPossibleLater: true)
            } else if actualTimesMethodIsCalled == expectedTimesMethodIsCalled {
                return .match
            } else {
                return .mismatch(matchIsPossibleLater: false)
            }
        }
    }
}
