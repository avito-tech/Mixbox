#if MIXBOX_ENABLE_IN_APP_SERVICES

extension String {
    // Useful methods for creating CustomDebugStringConvertible
    private static let newLine = "\n"
    
    public func mb_indent(_ indentation: String = "    ") -> String {
        return self
            .components(separatedBy: String.newLine)
            .map { indentation + $0 }
            .joined(separator: String.newLine)
    }
    
    public func mb_wrapAndIndent(
        prefix: String = "",
        postfix: String = "",
        indentation: String = "    ",
        ifEmpty stringIfEmpty: String? = "[]")
        -> String
    {
        if isEmpty, let stringIfEmpty = stringIfEmpty {
            return stringIfEmpty
        } else {
            return prefix + String.newLine
                + mb_indent(indentation) + String.newLine
                + postfix
        }
    }
}

#endif
