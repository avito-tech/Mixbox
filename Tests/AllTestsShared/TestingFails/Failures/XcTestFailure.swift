struct XcTestFailure: Equatable {
    let description: String
    let file: String
    let line: Int
    let expected: Bool
}
