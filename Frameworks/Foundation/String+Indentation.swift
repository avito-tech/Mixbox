extension String {
    // Useful methods for creating CustomDebugStringConvertible
    private static let newLine = "\n"
    
    public func mb_indent(_ indentation: String = "    ") -> String {
        return self
            .components(separatedBy: String.newLine)
            .map { indentation + $0 }
            .joined(separator: String.newLine)
    }
    
    public func mb_wrapAndIndent(prefix: String = "", postfix: String = "", skipIfEmpty: Bool = true) -> String {
        if isEmpty && skipIfEmpty {
            return ""
        } else {
            return prefix + String.newLine
                + mb_indent() + String.newLine
                + postfix
        }
    }
}
