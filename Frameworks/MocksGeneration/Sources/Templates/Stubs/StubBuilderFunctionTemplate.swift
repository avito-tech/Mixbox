import SourceryRuntime

public class StubBuilderFunctionTemplate {
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        let returnType = "MixboxMocksRuntime.StubForFunctionBuilder<\(argumentsTupleType), \(method.returnTypeName.name)>"
        
        return try WrappedFunctionTemplate(
            method: method,
            returnType: returnType,
            customBody:
            """
            return \(returnType)(
                functionId: "\(method.name)",
                mockManager: mockManager,
                matcher: matcher
            )
            """
        ).render()
    }

    // (Int, Int)
    private var argumentsTupleType: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { _, parameter in
                parameter.typeName.name
            }
        )
    }
    
}
