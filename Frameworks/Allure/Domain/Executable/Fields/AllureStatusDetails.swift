public struct AllureStatusDetails: Encodable {
    let known: Bool?
    let muted: Bool?
    let flaky: Bool?
    let message: String?
    let trace: String?
    
    public init(
        known: Bool?,
        muted: Bool?,
        flaky: Bool?,
        message: String?,
        trace: String?)
    {
        self.known = known
        self.muted = muted
        self.flaky = flaky
        self.message = message
        self.trace = trace
    }
}
