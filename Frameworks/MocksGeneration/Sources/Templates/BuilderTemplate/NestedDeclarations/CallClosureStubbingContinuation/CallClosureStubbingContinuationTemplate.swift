import SourceryRuntime

public final class CallClosureStubbingContinuationTemplate {
    private final class MethodData {
        let tupledArgumentsType: String
        let closureArguments: [ClosureArgument]
        
        init(
            tupledArgumentsType: String,
            closureArguments: [ClosureArgument])
        {
            self.tupledArgumentsType = tupledArgumentsType
            self.closureArguments = closureArguments
        }
    }
    
    private final class ClosureArgument {
        let index: Int
        let name: String
        let closureType: ClosureType
        let isOptional: Bool
        
        init(
            index: Int,
            name: String,
            closureType: ClosureType,
            isOptional: Bool)
        {
            self.index = index
            self.name = name
            self.closureType = closureType
            self.isOptional = isOptional
        }
    }
    
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func renderClass() -> (name: String, code: String)? {
        return methodData().map { methodData in
            let className = callClosureStubbingContinuationClassName(
                methodData: methodData
            )
            
            return (
                name: className,
                code: callClosureStubbingContinuation(
                    className: className,
                    methodData: methodData
                )
            )
        }
    }
    
    public func renderClassName() -> String? {
        return methodData().map {
            callClosureStubbingContinuationClassName(
                methodData: $0
            )
        }
    }
    
    private func methodData() -> MethodData? {
        guard method.returnTypeName.isVoid else {
            return nil
        }
        
        let closuresReturningVoid = method
            .parameters
            .enumerated()
            .compactMap { index, parameter in
                let name = parameter.argumentLabel.convertEmptyToNil()
                    ?? parameter.name.convertEmptyToNil()
                
                return name.flatMap { name in
                    parameter.typeName.validClosureType.flatMap { closureType in
                        ClosureArgument(
                            index: index,
                            name: name,
                            closureType: closureType,
                            isOptional: parameter.isOptional
                        )
                    }
                }
            }
            .filter { (closureArgument: ClosureArgument) -> Bool in
                closureArgument.closureType.returnTypeName.isVoid
                    && !closureArgument.closureType.throws
            }
        
        var countOfClosuresByName = [String: Int]()
        
        closuresReturningVoid.forEach { closure in
            countOfClosuresByName[closure.name, default: 0] += 1
        }
        
        let closureNamesAreUnique = countOfClosuresByName.values.allSatisfy {
            $0 == 1
        }
        
        if closuresReturningVoid.isEmpty || !closureNamesAreUnique {
            return nil
        } else {
            return MethodData(
                tupledArgumentsType: Snippets.tupledArgumentsType(
                    methodParameters: method.parameters
                ),
                closureArguments: closuresReturningVoid
            )
        }
    }
    
    private func callClosureStubbingContinuation(
        className: String,
        methodData: MethodData)
    -> String
    {
        return """
        final class \(className): MixboxMocksRuntime.CallClosureStubbingContinuation {
            private typealias TupledArguments = \(methodData.tupledArgumentsType)
            
            private let mockManager: MockManager
            private var functionIdentifier: FunctionIdentifier
            private let recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher
            private let fileLine: FileLine
            
            public init(
                mockManager: MockManager,
                functionIdentifier: FunctionIdentifier,
                recordedCallArgumentsMatcher: RecordedCallArgumentsMatcher,
                fileLine: FileLine)
            {
                self.mockManager = mockManager
                self.functionIdentifier = functionIdentifier
                self.recordedCallArgumentsMatcher = recordedCallArgumentsMatcher
                self.fileLine = fileLine
            }
            
            \(callClosureContinuationFunctions(closureArguments: methodData.closureArguments).indent())
        }
        """
    }
    
    private func callClosureStubbingContinuationClassName(methodData: MethodData) -> String {
        var name = "Continuation_"
        
        // Here's a simple algorithm to encode special characters
        // to characters that are valid for identifier. Escaping character is "_".
        // TODO: Make more correct and general algorithm of encoding
        methodData.closureArguments.forEach { closureArgument in
            name += "\(closureArgument.index)"
            
            closureArgument.closureType.parameters.forEach { parameter in
                name += parameter.inout ? "_io" : ""
                
                name += "_\(closureArgument.name)"
                
                let parameterTypeName = parameter
                    .typeName
                    .validTypeName
                
                name += parameterTypeName.isEmpty ? "Void" : parameterTypeName
                    .replacingOccurrences(of: "_", with: "__")
                    .replacingOccurrences(of: "(", with: "_po")
                    .replacingOccurrences(of: ")", with: "_pc")
                    .replacingOccurrences(of: "<", with: "_lt")
                    .replacingOccurrences(of: ">", with: "_gt")
                    .replacingOccurrences(of: " ", with: "_sp")
                    .replacingOccurrences(of: "@", with: "_at")
                    .replacingOccurrences(of: ",", with: "_cm")
                    .replacingOccurrences(of: "?", with: "_qm")
                    .replacingOccurrences(of: ".", with: "_dt")
            }
        }
        
        return name
    }
    
    private func callClosureContinuationFunctions(
        closureArguments: [ClosureArgument])
    -> String
    {
        return closureArguments
            .map(callClosureContinuationFunction)
            .joined(separator: "\n\n")
    }
    
    // swiftlint:disable:next function_body_length
    private func callClosureContinuationFunction(
        closureArgument: ClosureArgument)
    -> String
    {
        let parenthesisedSignature = closureArgument.closureType.parameters.render(
            separator: ",\n",
            valueIfEmpty: "() ",
            surround: {
                """
                (
                    \($0.indent()))
                
                """
            },
            transform: { index, parameter in
                """
                _ closureArgument\(index): \(parameter.typeName.validTypeName)
                """
            }
        )
        
        let callArguments = closureArgument.closureType.parameters.render(
            separator: ", ",
            transform: { index, _ in
                """
                closureArgument\(index)
                """
            }
        )
        
        let unwrappingOperator = closureArgument.isOptional
            ? "?"
            : ""
        
        let tupleAccessor = method.parameters.count > 1
            ? ".\(closureArgument.index)"
            : "" // "tuple" is actually a single type
        
        return """
        func \(closureArgument.name)\(parenthesisedSignature){
            mockManager.stub(
                functionIdentifier: functionIdentifier,
                callStub: CallStub(
                    returnValueProvider: { [fileLine] typeErasedTupledArguments in
                        UnavoidableFailure.doOrFail(fileLine: fileLine) {
                            let tupledArguments: TupledArguments = try typeErasedTupledArguments.tupledArguments()
                            
                            tupledArguments\(tupleAccessor)\(unwrappingOperator)(\(callArguments))
                        }

                        return TypeErasedReturnValue(())
                    },
                    recordedCallArgumentsMatcher: recordedCallArgumentsMatcher
                )
            )
        }
        """
    }
}
