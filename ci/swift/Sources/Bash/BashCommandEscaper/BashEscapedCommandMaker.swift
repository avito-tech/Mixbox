/// Makes string from arguments that can be used as command in BASH.
public protocol BashEscapedCommandMaker {
    func escapedCommand(arguments: [String]) -> String
}
