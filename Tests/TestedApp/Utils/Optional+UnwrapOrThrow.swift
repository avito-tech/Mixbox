import MixboxFoundation

extension Optional {
    public func unwrapOrThrow(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw ErrorString(
                "Failed to unwrap \(type(of: self)), value is nil, which is not expected, file: \(file), line: \(line)"
            )
        }
        
        return unwrapped
    }
}
