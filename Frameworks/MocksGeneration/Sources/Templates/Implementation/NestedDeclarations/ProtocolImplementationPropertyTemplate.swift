import SourceryRuntime

public class ProtocolImplementationPropertyTemplate {
    private let variable: Variable
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func render() -> String {
        """
        var \(variable.name): \(returnType) {
            \(accessors.indent())
        }
        """
    }
    
    private var returnType: String {
        variable.typeName.validTypeName
    }
    
    private var accessors: String {
        let accessors = [
            getter,
            variable.isMutable ? setter : nil
        ]
        
        return accessors
            .compactMap { $0 }
            .joined(separator: "\n")
    }
    
    private var getter: String {
        """
        get {
            return getMockManager().call(
                functionIdentifier: MixboxMocksRuntime.FunctionIdentifierFactory.variableFunctionIdentifier(
                    variableName: \(Snippets.variableNameStringLiteral(variable: variable).indent(level: 3)),
                    type: .get
                ),
                defaultImplementation: getDefaultImplementation(MixboxMocksRuntimeVoid.self),
                defaultImplementationClosure: { (defaultImplementation, _) in
                    defaultImplementation.\(variable.name)
                },
                tupledArguments: (),
                recordedCallArguments: RecordedCallArguments(arguments: [])
            )
        }
        """
    }
    
    private var setter: String? {
        """
        set {
            let _: () = getMockManager().call(
                functionIdentifier: MixboxMocksRuntime.FunctionIdentifierFactory.variableFunctionIdentifier(
                    variableName: \(Snippets.variableNameStringLiteral(variable: variable).indent(level: 3)),
                    type: .set
                ),
                defaultImplementation: getDefaultImplementation(MixboxMocksRuntimeVoid.self),
                defaultImplementationClosure: { (defaultImplementation, newValue) in
                    defaultImplementation.\(variable.name) = newValue
                },
                tupledArguments: (newValue),
                recordedCallArguments: RecordedCallArguments(arguments: [
                    RecordedCallArgument.regular(newValue)
                ])
            )
        }
        """
    }
}
