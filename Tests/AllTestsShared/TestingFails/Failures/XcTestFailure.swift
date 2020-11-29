struct XcTestFailure: Equatable {
    let description: String
    let file: String
    let line: UInt
    let expected: Bool
}
