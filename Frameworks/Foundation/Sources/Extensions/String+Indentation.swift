#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Useful methods for creating CustomDebugStringConvertible
extension String {
    private static var newLine: String { "\n" }
    
    public func mb_indent(
        level: Int = 1,
        indentation: String = "    ",
        includingFirstLine: Bool
    ) -> String {
        let indentation = String(repeating: indentation, count: level)
        
        return self
            .components(separatedBy: String.newLine)
            .enumerated()
            .map { index, line in (index == 0 && !includingFirstLine) ? line : indentation + line }
            .joined(separator: String.newLine)
    }
    
    public func mb_wrapAndIndent(
        indentation: String = "    ",
        prefix: String = "",
        postfix: String = "",
        ifEmpty stringIfEmpty: String? = "[]"
    ) -> String {
        if isEmpty, let stringIfEmpty {
            return stringIfEmpty
        } else {
            return "\(prefix)\(String.newLine)\(mb_indent(indentation: indentation, includingFirstLine: true))\(String.newLine)\(postfix)"
        }
    }
}

#endif
