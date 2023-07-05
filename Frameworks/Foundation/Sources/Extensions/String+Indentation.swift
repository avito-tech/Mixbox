#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Useful methods for creating CustomDebugStringConvertible
extension String {
    private static var newLine: String { "\n" }
    
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
