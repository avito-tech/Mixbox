extension Optional {
    public func unwrapOrFail(file: StaticString = #file, line: UInt = #line) -> Wrapped {
        guard let unwrapped = self else {
            UnavoidableFailure.fail(
                "Failed to unwrap \(type(of: self)), value is nil, which is not expected",
                file: file,
                line: line
            )
        }
        
        return unwrapped
    }
}
