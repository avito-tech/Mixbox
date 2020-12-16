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
            return getMockManager(MixboxMocksRuntime.MixboxMocksRuntimeVoid.self).call(
                functionIdentifier: MixboxMocksRuntime.FunctionIdentifierFactory.variableFunctionIdentifier(
                    variableName: \(Snippets.variableNameStringLiteral(variable: variable).indent(level: 3)),
                    type: .get
                ),
                defaultImplementation: getDefaultImplementation(MixboxMocksRuntimeVoid.self),
                defaultImplementationClosure: { (defaultImplementation, _) in
                    defaultImplementation.\(variable.name.indent(level: 3))
                },
                tupledArguments: (),
                nonEscapingCallArguments: MixboxMocksRuntime.NonEscapingCallArguments(
                    arguments: []
                ),
                generatorSpecializations: \(generatorSpecializations.indent(level: 2))
            )
        }
        """
    }
    
    private var generatorSpecializations: String {
        """
        TypeErasedAnyGeneratorSpecializationsBuilder()
            .add(\(variable.typeName.typeInstanceExpression.indent()))
            .specializations
        """
    }
    
    private var setter: String? {
        """
        set {
            let _: () = getMockManager(MixboxMocksRuntime.MixboxMocksRuntimeVoid.self).call(
                functionIdentifier: MixboxMocksRuntime.FunctionIdentifierFactory.variableFunctionIdentifier(
                    variableName: \(Snippets.variableNameStringLiteral(variable: variable).indent(level: 3)),
                    type: .set
                ),
                defaultImplementation: getDefaultImplementation(MixboxMocksRuntimeVoid.self),
                defaultImplementationClosure: { (defaultImplementation, newValue) in
                    defaultImplementation.\(variable.name) = newValue
                },
                tupledArguments: (newValue),
                nonEscapingCallArguments: NonEscapingCallArguments(
                    arguments: [
                        NonEscapingCallArgument(
                            name: nil,
                            label: nil,
                            type: \(variable.typeName.typeInstanceExpression.indent(level: 5)),
                            value: MixboxMocksRuntime.NonEscapingCallArgumentValue.regular(
                                MixboxMocksRuntime.RegularArgumentValue(
                                    value: newValue
                                )
                            )
                        )
                    ]
                ),
                generatorSpecializations: \(generatorSpecializations.indent(level: 2))
            )
        }
        """
    }
}
