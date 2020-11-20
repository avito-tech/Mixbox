public enum TimesMethodWasCalledMatchingResult {
    case match
    case mismatch(matchIsPossibleLater: Bool)
}
