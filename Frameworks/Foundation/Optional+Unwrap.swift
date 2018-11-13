extension Optional {
    public func unwrapOrThrow(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw ErrorString("Found nil when unwrapping optional at \(file):\(line)")
        }
    }
}
