// Escaping rules:
// https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Double-Quotes
public final class BashEscapedCommandMakerImpl: BashEscapedCommandMaker {
    public init() {
    }
    
    public func escapedCommand(arguments: [String]) -> String {
        // ["a", "$b \"c\"", "`d`"] will be printed as this:
        //
        // """
        // "a" "\$b \"c\"" "\`d\`"
        // """
        //
        // not as this:
        //
        // """
        // a b "c" `d`
        // """
        //
        // and thus can be executed in bash. In this example "`d`" is a string, and `d` is and invocation.
        //
        // Potential improvement: do not put argument in quotes if it is not needed.
        // E.g.: "a b" should be inside quotes, but "a" should not.
        //
        return arguments
            .map { $0.replacingOccurrences(of: "\"", with: "\\\"") }
            .map { $0.replacingOccurrences(of: "!", with: "\\!") }
            .map { $0.replacingOccurrences(of: "`", with: "\\`") }
            .map { $0.replacingOccurrences(of: "$", with: "\\$") }
            .map { "\"\($0)\"" }
            .joined(separator: " ")
    }
}
