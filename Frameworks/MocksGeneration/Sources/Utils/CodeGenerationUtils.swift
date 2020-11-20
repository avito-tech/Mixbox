public final class CodeGenerationUtils {
    private init() {}
    
    /// Returns just name of argument if label is same as name.
    /// Returns labeled argument otherwise.
    ///
    /// Imagine this function:
    ///
    /// `func x(a b: Int)`
    ///
    /// `a` is label, `b` is name.
    ///
    /// `labeledArgument(label: "a", name: "b")` will return `"a b"`
    /// `labeledArgument(label: "x", name: "x")` will return just `"x"`
    ///
    public static func labeledArgument(label: String, name: String) -> String {
        if label == name {
            return name
        } else {
            return "\(label) \(name)"
        }
    }
    
    /// Same as above, if label is `nil`, it is treated like it is `"_"`
    public static func labeledArgument(label: String?, name: String) -> String {
        return labeledArgument(
            label: label ?? "_",
            name: name
        )
    }
}
