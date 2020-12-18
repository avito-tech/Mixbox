import SourceryRuntime

public class BuilderTemplate {
    private let protocolType: Protocol
    private let builderType: BuilderType
    
    public init(
        protocolType: Protocol,
        builderType: BuilderType)
    {
        self.protocolType = protocolType
        self.builderType = builderType
    }
    
    public func render() throws -> String {
        """
        class \(builderType.builderClassName()): MixboxMocksRuntime.\(builderType.builderBaseClassName()) {
            \(try blocks().indent())
        }
        """
    }
    
    private func blocks() throws -> String {
        let blocks = callClosureStubbingContinuations
            + [properties, constructor]
            + propertyBuilders
            + (try functionBuilders())
        
        return blocks.joined(separator: "\n\n")
    }
    
    private var properties: String {
        """
        private let mockManager: MixboxMocksRuntime.MockManager
        private let fileLine: FileLine
        """
    }
    
    private var constructor: String {
        """
        required init(mockManager: MixboxMocksRuntime.MockManager, fileLine: FileLine) {
            self.mockManager = mockManager
            self.fileLine = fileLine
        }
        """
    }
    
    private var callClosureStubbingContinuations: [String] {
        switch builderType {
        case .stubbing:
            var classDeclarationCodeByName = [String: String]()
            
            protocolType.allMethodsToImplement.forEach { method in
                if let renderedClass = CallClosureStubbingContinuationTemplate(method: method).renderClass() {
                    classDeclarationCodeByName[renderedClass.name] = renderedClass.code
                }
            }
            
            return Array(classDeclarationCodeByName.values)
        case .verification:
            return []
        }
    }
    
    private var propertyBuilders: [String] {
        return protocolType.allVariables.map {
            let template = PropertyBuilderTemplate(
                variable: $0,
                builderType: builderType
            )
            
            return template.render()
        }
    }
    
    private func functionBuilders() throws -> [String] {
        return try protocolType.allMethodsToImplement.map { method in
            let template = try FunctionBuilderTemplate(
                method: method,
                functionBuilderClass: functionBuilderClass(
                    method: method
                )
            )
            
            return template.render()
        }
    }
    
    private func functionBuilderClass(method: Method) -> String {
        let argumentsTupleType = Snippets.tupledArgumentsType(
            methodParameters: method.parameters
        )
        
        let returnType = method
            .returnTypeName
            .validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional
        
        let regularBuilderTemplateArguments = "<\(argumentsTupleType), \(returnType)>"
        
        switch builderType {
        case .stubbing:
            let template = CallClosureStubbingContinuationTemplate(
                method: method
            )
            
            if let className = template.renderClassName() {
                let templateArguments = "<\(argumentsTupleType), \(returnType), \(className)>"
                return "StubbingFunctionWithClosureArgumentsBuilder\(templateArguments)"
            } else {
                return "StubbingFunctionBuilder\(regularBuilderTemplateArguments)"
            }
        case .verification:
            return "VerificationFunctionBuilder\(regularBuilderTemplateArguments)"
        }
    }
}
