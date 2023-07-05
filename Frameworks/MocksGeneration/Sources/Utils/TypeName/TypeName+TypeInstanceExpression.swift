import SourceryFramework
import SourceryRuntime
import Foundation

extension TypeName {
    // https://docs.swift.org/swift-book/ReferenceManual/Expressions.html#grammar_postfix-self-expression
    public var typeInstanceExpression: String {
        var typeName = validTypeName
        
        // `().self` leads to this error: `Cannot convert value of type '()' to expected argument type 'Any.Type'`
        // Note that `(()).self` is also an invalid expression and just adding more parentheses (like below) won't help.
        if typeName == "()" {
            typeName = "Void"
        }
        
        while typeName.hasSuffix("!") {
            // `(() -> ())!.self is not a valid expression
            typeName = "\(typeName.dropLast())"
        }
        
        if isReallyClosure || typeName.hasPrefix(")") || typeName.hasSuffix(")") {
            // `() -> ().self` is not a valid expression
            typeName = "(\(typeName))"
        }
        
        // `(_ x: Int) -> ()` is a valid type, but `((_ x: Int) -> ()).self` is not a valid expression
        let closureArgumentsRegularExpressions = [
            Self.labeledClosureLatterArgumentsRegex,
            Self.labeledClosureFirstArgumentRegex
        ].compactMap { $0 }
        
        if !closureArgumentsRegularExpressions.isEmpty {
            var oldTypeName: String
            let template = "$1$2"
            
            repeat {
                oldTypeName = typeName
                
                closureArgumentsRegularExpressions.forEach {
                    typeName = typeName.replace(
                        regex: $0,
                        template: template
                    )
                }
            } while oldTypeName != typeName
        }
        
        return """
        \(typeName).self
        """
    }
    
    // Very simple pattern, covers only most used cases:
    private static var identifierPattern: String { "[a-zA-Z_][a-zA-Z_0-9]*" }
    
    private static var labeledClosureArgumentRegexCommonPart: String { "_ \(identifierPattern): ?(.*?\\) ?-> ?\\()" }
    
    private static let labeledClosureFirstArgumentRegex = try? NSRegularExpression(
        pattern: "(\\()\(labeledClosureArgumentRegexCommonPart)",
        options: []
    )
    
    private static let labeledClosureLatterArgumentsRegex = try? NSRegularExpression(
        pattern: "(\\(.*?, ?)\(labeledClosureArgumentRegexCommonPart)",
        options: []
    )
}
