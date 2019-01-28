public enum AllureStatus: String, Encodable {
    case passed
    case broken
    case failed
    case skipped
    // TODO: Check if it exists in API:
    // case unknown
}
