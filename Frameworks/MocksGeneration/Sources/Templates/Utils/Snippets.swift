import SourceryRuntime

// Resulable pieces of code
public final class Snippets {
    private init() {
    }
    
    // MARK: - Specific for current templates
    
    public static func argumentName(index: Int) -> String {
        return "argument\(index)"
    }
    
    public static func genericArgumentTypeName(index: Int) -> String {
        return "Argument\(index)"
    }
    
    public static func variableNameStringLiteral(variable: Variable) -> String {
        return identifier(
            value: "\(variable.name)"
        )
    }
    
    public static func functionIdentifier(method: Method) -> String {
        return identifier(
            value: "func/\(method.name)"
        )
    }
    
    // Multiline literal is necessary, because value can be multiline.
    // TODO: Add escaping!
    public static func identifier(value: String) -> String {
        """
        \"\"\"
        \(value)
        \"\"\"
        """
    }
    
    // MARK: - Generic for Swift
    
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
