import SourceryRuntime

public class ExpectationBuilderFunctionTemplate {
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        return try WrappedFunctionTemplate(
            method: method,
            returnType: nil,
            customBody:
            """
            mockManager.addExpecatation(
                functionId:
                \"\"\"
                \(method.name)
                \"\"\",
                fileLine: fileLine,
                times: times,
                matcher: matcher
            )
            """
        ).render()
    }
}
